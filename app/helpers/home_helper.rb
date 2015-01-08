module HomeHelper

  def expenses_to_approve( reviewees, db_cols, approver )
    if approver 
      content = "<li id='expenses-to-approve' class='employees-section'>"\
        "<span id='nav-approve-expenses' class='expense-btn'>Expenses to Approve</span>"\
  			"<ul id='approve-list' style='display: none'>"
			
        reviewees.each do |p|
      		content += "<li id='expense_#{p[db_cols[:employeeid]]}' value='pending_#{p[db_cols[:employeeid]]}' class='expense-btn' style='cursor:pointer'>#{p[db_cols[:employeeid]]}</li>"
      end

      content += "</ul></li>"
      content.html_safe
    end
  end
end
