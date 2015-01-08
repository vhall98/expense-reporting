class ExpensesController < ApplicationController
  before_filter :authenticate_user, :only => [:index]
  before_filter :save_login_state, :only => [:login, :login_attempt]
  
  def index
    # Create mapping to Expense table column names
    @db_cols = ExpenseReporting::Application.config.db_columns
    # @user = Sys::Admin.get_login

    @current_user = User.find session[:user_id]
    @user = Employee.where("#{@db_cols[:employeeid]} = ?", @current_user["#{@db_cols[:username]}"]).first
    @user = @user[@db_cols[:employeeid]]
    
    @categories = TblCategory.select("#{@db_cols[:categoryID]}, #{@db_cols[:description]}")
    @exp_reasons = TblExpReason.select("#{@db_cols[:description]}, #{@db_cols[:reason]}")
    @paid_by = TblCode.select("#{@db_cols[:codedesc]}").where("#{@db_cols[:parentid]} = ?", 14)
    @states = TblState.select("#{@db_cols[:stateabbr]}")
    @expenses = TblReceipt.where("#{@db_cols[:employeeid]} = ?", @user).order(@db_cols[:date])
    @cat_cols = TblReceipt.columns.select{ |c| c.type == :integer }.map(&:name)
    @other_cols = TblReceipt.columns.select{ |c| c.type == :string }.map(&:name)

    @cat_names = []
    @amnt_names = []
    
    @cat_cols.each do |e|
      if e.match('Cat')
        @cat_names.push(e)
      end
    end
    @other_cols.each do |e|
      if e.match('Amount')
        @amnt_names.push(e)
      end
    end

    # determine if current user is a Reviewer/Approver
    reviewer = Reviewer.where("#{@db_cols[:employeeid]} = ?", @user).first
    @approver = reviewer.nil? ? false : true
    
    @reviewees = []
    @reviewee_expenses = {};
    
    if @approver
      @reviewees = Employee.where("#{@db_cols[:reviewerid]} = ?", @user).order(@db_cols[:employeeid])
      if @reviewees.size > 0
        @reviewees.each do |person|
          @expenses_ = TblReceipt.where("#{@db_cols[:employeeid]} = ? AND #{@db_cols[:status]} = ?", person[@db_cols[:employeeid]], 'pending approval').order(@db_cols[:date])
          if @expenses_.size > 0
            @reviewee_expenses[person[@db_cols[:employeeid]]] = @expenses_
          end
        end
      end
    end
  end
  
  # post /approve/1  
  def approve
    @db_cols = ExpenseReporting::Application.config.db_columns
    @expense = TblReceipt.find(params[:id])
    @expense.Status = 'approved'
    good = @expense.save
    
    @user = @expense[@db_cols[:employeeid]]
    
    @orig_user = @user  
    @user = 'pending_'+@user  # user expenses with status "pending approval" is contained within div with id="pending_user"
                              # this id is used to redisplay table showing "pending approval" status since now this record"
                              #   will no longer show in table.
                              # determine if current user is a Reviewer/Approver
    reviewer = Reviewer.where("#{@db_cols[:employeeid]} = ?", @orig_user).first
    @approver = reviewer.nil? ? false : true
    @updated_expenses = nil
    if @approver
      @updated_expenses = TblReceipt.where("#{@db_cols[:employeeid]} = ?", @orig_user).order(@db_cols[:date])
      @updated_expenses = format_expenses( @updated_expenses, @db_cols )      
    end
    
    respond_to do |format|
      if good
        # format.js { render action: 'save.js.erb' }
        format.json { render :json => { :action => "approve", :expense_owner => @user, :orig_user => @orig_user,
          :updated_expenses => @updated_expenses, :db_col => @db_cols } }
      end
    end
  end
  
  # post /reject/1  
  def reject
    @db_cols = ExpenseReporting::Application.config.db_columns
    @expense = TblReceipt.find(params[:id])
    @expense.Status = 'rejected'
    good = @expense.save
    
    @user = @expense[@db_cols[:employeeid]]
    
    @orig_user = @user  
    @user = 'pending_'+@user  # user expenses with status "pending approval" is contained within div with id="pending_user"
                              # this id is used to redisplay table showing "pending approval" status since now this record"
                              #   will no longer show in table.
    reviewer = Reviewer.where("#{@db_cols[:employeeid]} = ?", @orig_user).first
    @updated_expenses = nil
    @approver = reviewer.nil? ? false : true
    if @approver
      @updated_expenses = TblReceipt.where("#{@db_cols[:employeeid]} = ?", @orig_user).order(@db_cols[:date])
      @updated_expenses = format_expenses( @updated_expenses, @db_cols )
    end
    
    respond_to do |format|
      if good
        # format.js { render action: 'save.js.erb' }
        format.json { render :json => { :action => "reject", :expense_owner => @user, :orig_user => @orig_user,
          :updated_expenses => @updated_expenses, :db_col => @db_cols  } }
      end
    end
  end
  
  # POST /save
  def save
    @data = params[:receipts]
    @db_cols = ExpenseReporting::Application.config.db_columns
    # @user = Sys::Admin.get_login
    #@user = "dshavers"
    @current_user = User.find session[:user_id]
    @user = Employee.where("#{@db_cols[:employeeid]} = ?", @current_user["#{@db_cols[:username]}"]).first
    @user = @user["#{@db_cols[:employeeid]}"]
    
    num = @data[:receiptno].to_i
    @expense = nil
    @expenses = nil
    
    # Get the highest receipt number and increment by 1
    if num == 0
      max_num = TblReceipt.maximum(@db_cols[:receiptno])
      num = max_num.nil? ? 1 : max_num + 1
      @expense = TblReceipt.new
      @expense[@db_cols[:receiptno]] = num
      @data[:receiptno] = num
    else
      @expense = TblReceipt.where("#{@db_cols[:receiptno]} = ?", num ).first
    end

    @pending_approval_expenses = nil
    if @data[:status] == 'pending approval'
      @pending_approval_expenses = TblReceipt.where("#{@db_cols[:employeeid]} = ? AND (#{@db_cols[:status]} = ?)", @user, 'pending approval').order(@db_cols[:date])
      @pending_approval_expenses = format_expenses( @pending_approval_expenses, @db_cols )
    end

    @data[:status] = "pending"
    if save_expense( @expense, @data, @db_cols )
      @data[:id] = @expense[:id]
      respond_to do |format|
        format.json { render :json => { :expense => @data, :action => "save", :user => @user, :db_col => @db_cols } }
      end
    end
  end


  ## format_expenses
  ## format_expenses
  ## format_expenses
  
  def format_expenses( expenses, db_cols)
    @list = []
    expenses.each do |exp|
      @formatted = {}
      exp.attributes.each do |name, value|
        @formatted[db_cols.key(name)] = value
      end
      @list.push(@formatted)
    end
    return @list
  end


  ## save_expense
  ## save_expense
  ## save_expense
  
  def save_expense( expense, data, db_cols )
    expense[db_cols[:employeeid]] = data[:employeeid]
    expense[db_cols[:date]] = data[:date]
    expense[db_cols[:updatedate]] = Time.now
    expense[db_cols[:updateuser]] = data[:updateuser]
    expense[db_cols[:reason]] = data[:reason]
    expense[db_cols[:vendor]] = data[:vendor]
    expense[db_cols[:duration]] = data[:duration].to_i
    expense[db_cols[:durationtype]] = data[:durationtype]
    expense[db_cols[:purpose]] = data[:purpose]
    expense[db_cols[:paidby]] = data[:paidby]
    expense[db_cols[:local]] = data[:local].to_i
    expense[db_cols[:havereceipt]] = data[:havereceipt].to_i
    expense[db_cols[:persons]] = data[:persons]
    expense[db_cols[:status]] = data[:status]
    expense[db_cols[:state]] = data[:state]
    expense[db_cols[:category1]] = data[:category1].to_i
    expense[db_cols[:category2]] = data[:category2].nil? ? nil : data[:category2].to_i
    expense[db_cols[:category3]] = data[:category3].nil? ? nil : data[:category3].to_i
    expense[db_cols[:category4]] = data[:category4].nil? ? nil : data[:category4].to_i
    expense[db_cols[:category5]] = data[:category5].nil? ? nil : data[:category5].to_i
    expense[db_cols[:amount1]] = data[:amount1].to_f
    expense[db_cols[:amount2]] = data[:amount2].nil? ? "" : data[:amount2].to_f
    expense[db_cols[:amount3]] = data[:amount3].nil? ? "" : data[:amount3].to_f
    expense[db_cols[:amount4]] = data[:amount4].nil? ? "" : data[:amount4].to_f
    expense[db_cols[:amount5]] = data[:amount5].nil? ? "" : data[:amount5].to_f
    expense[db_cols[:total]] = data[:total]
    return expense.save 
  end


  # GET /expenses/1
  # GET /expenses/1.json
  def show
    @expense = TblReceipt.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @expense }
    end
  end

  # GET /expenses/new
  # GET /expenses/new.json
  def new
    @expense = TblReceipt.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @expense }
    end
  end

  # GET /expenses/1/edit
  def edit
    @expense = TblReceipt.find(params[:id])
  end


  # post /delete/1  
  def delete

    @db_cols = ExpenseReporting::Application.config.db_columns
    # @user = Sys::Admin.get_login
    
    @current_user = User.find session[:user_id]
    @user = Employee.where("#{@db_cols[:employeeid]} = ?", @current_user["#{@db_cols[:username]}"]).first
    @user = @user["#{@db_cols[:employeeid]}"]
    
    @expense = TblReceipt.find(params[:id])
    status = @expense[@db_cols[:status]]
    TblReceipt.destroy(params[:id])
    @expenses = TblReceipt.where("#{@db_cols[:employeeid]} = ?", @user).order("#{@db_cols[:date]}");

    # determine if current user is a Reviewer/Approver
    reviewer = Reviewer.where("#{@db_cols[:employeeid]} = ?", @user).first
    @approver = reviewer.nil? ? false : true
    
    @pending_approval_expenses = nil
    if status == 'pending approval' && @approver
      @pending_approval_expenses = TblReceipt.where("#{@db_cols[:employeeid]} = ? AND (#{@db_cols[:status]} = ?)", @user, 'pending approval').order(@db_cols[:date])
      @pending_approval_expenses = format_expenses( @pending_approval_expenses, @db_cols )
    end
    respond_to do |format|
      format.json { render :json => { :action => "delete", :pending_approval_expenses => @pending_approval_expenses } }
      # format.html { redirect_to :back }
    end
  end

  # post /submit/1  
  def submit
    @data = params[:receipts]
    @expense = TblReceipt.find(params[:id])
    @expense.Status = 'pending approval'
    
    if @expense.save
      @data[:id] = @expense[:id]
      @data[:status] = "pending approval"
    else
      # flash[:notice] = "Form is invalid"
      # flash[:color]= "invalid"  
    end

    @db_cols = ExpenseReporting::Application.config.db_columns
    # @user = Sys::Admin.get_login
    
    @current_user = User.find session[:user_id]
    @user = Employee.where("#{@db_cols[:employeeid]} = ?", @current_user["#{@db_cols[:username]}"]).first
    @user = @user["#{@db_cols[:employeeid]}"]
    
    @expenses = TblReceipt.where("#{@db_cols[:employeeid]} = ? AND #{@db_cols[:status]} = ?", @user, 'pending').order("#{@db_cols[:date]}");

    @pending_approval_expenses = TblReceipt.where("#{@db_cols[:employeeid]} = ? AND (#{@db_cols[:status]} = ?)", @user, 'pending approval').order(@db_cols[:date])
    @pending_approval_expenses = format_expenses( @pending_approval_expenses, @db_cols )
    
    respond_to do |format|
      format.json { render :json => { :expense => @data, :action => "submit", :user => @user,
      :pending_approval_expenses => @pending_approval_expenses, :db_col => @db_cols } }
    end

  end

  # post /logout
  def logout
    session[:user_id] = nil
    # redirect_to :action => 'login'
    redirect_to sessions_login_path    
  end
end
