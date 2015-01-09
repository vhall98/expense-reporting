ExpenseReporting::Application.routes.draw do
  get "sessions/login"

  get "sessions/home"

  get "sessions/profile"

  get "sessions/setting"

  #  get "users/new"
  #get "home/index"
  #root :to => 'home#index'
  
  #get "expenses/index"
  #root :to => 'expenses#index'
  #get "users/create"
  #root :to => 'users#new'
  root :to => "sessions#login"
  
  #match "signup", :to => "users#new"
  get "signup", :to => "expenses#index"
  get "login", :to => "sessions#login"
  get "logout", :to => "sessions#logout"
  get "home", :to => "sessions#home"
  get "profile", :to => "sessions#profile"
  get "setting", :to => "sessions#setting"  
  match ':controller(/:action(/:id))(.:format)', via: :all
  
  controller :expenses do
    get 'expenses'      => :index
    get 'expenses/:id'  => :index
    post '/save'        => :save
    post '/approve/:id' => :approve
    post '/delete/:id'  => :delete
    post '/submit/:id'  => :submit
    post '/reject/:id'  => :reject

    #get 'expenses/:slug'   => :show
  end

  # GET /expenses/1
  # GET /expenses/1.json
  def show
    @expenses = TblReceipt.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @expenses }
    end
  end

  # GET /expenses/new
  # GET /expenses/new.json
  def new
    @expenses = TblReceipt.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @expenses }
    end
  end

  # GET /expenses/1/edit
  def edit
    @expenses = TblReceipt.find(params[:id])
  end

  # POST /expenses
  # POST /expenses.json
  def create
    @expenses = TblReceipt.new(params[:expense])

    respond_to do |format|
      if @expenses.save
        format.html { redirect_to @expenses, notice: 'Receipt(s) successfully added.' }
        format.json { render json: @expenses, status: :created, location: @expenses }
      else
        format.html { render action: "new" }
        format.json { render json: @expenses.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /expenses/1
  # PUT /expenses/1.json
  def update
    @expenses = TblReceipt.find(params[:id])

    respond_to do |format|
      if @expenses.update_attributes(params[:expense])
        format.html { redirect_to @expenses, notice: 'Show me was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @expenses.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expenses/1
  # DELETE /expenses/1.json
  def destroy
    @expenses = TblReceipt.find(params[:id])
    @expenses.destroy

    respond_to do |format|
      format.html { redirect_to expenses_url }
      format.json { head :no_content }
    end
  end
end
