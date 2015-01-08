module ExpensesHelper
  #
  # Create the expense entry section
  #
  def expense_form(amnt_names, cat_names, login_id, states, paid_by, exp_reasons, categories, db_cols)  
    content = "<form id='receipt-form'>"\
    	"<div class='expense-details'>"
    	
		6.times do |i|
			content += "<div class='row'>"\
				"<div class='columns small-7 medium-7 large-7'>"
				
				case i 
				when 0
					content += "<label>Receipt Date:</label>"\
					"<input id='expense_date' name='expense[date]' type='textbox' class='numeric text-box' value='' data-date-format='yyyy-mm-dd hh:ii:ss'/>"\
					"<input id='expense_updatedate' type='hidden' name='expense[updatedate]' class='numeric text-box' value='' data-date-format='yyyy-mm-dd hh:ii:ss'/>"\
					"<input id='expense_updateuser' type='hidden' name='expense[updateuser]' value='#{login_id}'></input>"\
					"<input id='expense_employeeid' type='hidden' name='expense[employeeid]' value='#{login_id}'></input>"\
					"<input id='expense_receiptno' type='hidden' name='expense[receiptno]' value='0'></input>"\
          "<input id='expense_status' type='hidden' name='expense[status]' value='pending'></input>"\
					"<input id='expense_local' type='hidden' name='expense[local]' value=''></input>"\
					"<input id='action' type='hidden' value=''></input>"\
					"<div>"\
						"<label>Have Receipt:</label>"\
						"<input id='expense_havereceipt' class='check-box' type='checkbox' name='expense[havereceipt]' value='0' autocomplete='off'/>"\
					"</div>"
				when 1
					content += "<label>Exp. Reason:</label>"\
					"<select id='expense_reason' name='expense[reason]' class='select-size2'>"\
						"<option value='' default></option>"
					exp_reasons.each do |x|
						content += "<option value='#{x[db_cols[:reason]]}'>#{x[db_cols[:description]]}</option>"
					end
					content += "</select>"
					
				when 2
					content += "<div style='float:right'>"\
						"<label>&nbsp;&nbsp;State:&nbsp;</label>"\
						"<select id='expense_state' name='expense[state]' class='select-size1'>"\
							"<option value='' default></option>"
						states.each do |s|
							content += "<option value='#{s[db_cols[:stateabbr]]}'>#{s[db_cols[:stateabbr]]}</option>"
						end
						
						content += "</select>"\
					"</div>"\
   
				when 3
					content += "<div>"\
						"<label>Paid By:</label>"\
						"<select id='expense_paidby' name='expense[paidby]' class='select-size2'>"\
							"<option value='' default></option>"
						paid_by.each do |p|
							content += "<option value='#{p[db_cols[:codedesc]]}'>#{p[db_cols[:codedesc]]}</option>"
            			end
						content += "</select>"\
					"</div>"
				when 4
					content += "<div style='float:right'>"\
		                "<label>Duration:</label>"\
						"<input id='expense_duration' type='textbox' class='numeric text-box' name='expense[duration]'/>"\
						"<label>Type:</label>"\
						"<select id='expense_durationtype' name='expense[durationtype]' class='select-size1'>"\
							"<option value='' default></option>"\
							"<option value='Hours'>Hours</option>"\
							"<option value='Days'>Days</option>"\
						"</select>"\
					"</div>"
				when 5
					content += "<label>Vendor:</label>"\
						"<input id='expense_vendor' type='textbox' class='text-box2' name='expense[vendor]'/>"
				end

				content += "</div>"\
				"<div class='columns small-6 medium-6 large-6'>"
				
					if i < 5
  					content += "<select id='expense_category#{i+1}' name='expense[category#{i+1}]' data-val='#expense_amount#{i+1}'>"\
  						"<option value='' default></option>"
  					categories.each do |c|
  						content += "<option value='#{c[db_cols[:categoryID]]}'>#{c[db_cols[:description]]}</option>"
  					end
  					content += "</select>"\
            "</div>"\
    				"<div class='columns small-2 medium-2 large-2'>"\
    					"<input id='expense_amount#{i+1}' type='textbox' data-val='#expense_category#{i+1}'"\
    					      "class='amount numeric text-box' name='expense[amount#{i+1}]' autocomplete='off' value=''/>"\
    				"</div></div>"\
					else
						content += "<label style='float: right'>Total:</label>"\
            "</div>"\
    				"<div class='columns small-2 medium-2 large-2'>"\
    					"<input id='expense_total' name='expense[total]' type='textbox' class='total text-box'></input>"\
    				"</div></div>"
					end
		end
			content += "<div class='row'>"\
				"<div class='columns small-15 medium-15 large-15'>"\
					"<label>Purpose:</label>"\
					"<input id='expense_purpose' type='textbox' class='text-entry' name='expense[purpose]'/>"\
				"</div>"\
			"</div>"\
				"<div class='row'>"\
  				"<div class='columns small-15 medium-15 large-15'>"\
  					"<label>Persons:</label>"\
  					"<input id='expense_persons' type='textbox' class='text-entry' name='expense[persons]'/>"\
  				"</div>"\
				"</div>"\
		"</div>"\
  	"<div id='expense-buttons' class='row buttons-section'>"\
    	"<div class='columns small-15 medium-15 large-15'>"\
    		"<a id='new-button' class='button tiny radius btn' type=''>New</a>"\
    		"<a id='save-button' name='save' class='button tiny radius btn' type='' value=''>Save</a>"\
    		"<a id='edit-button' class='button tiny radius btn' type=''>Edit</a>"\
    		"<a id='cancel-button' class='cancel button tiny radius btn' type=''>Cancel</a>"\
    		"<a id='delete-button' class='delete button tiny radius btn' type='' value=''>Delete</a>"\
    		"<a id='submit-button' name='submit' class='submit button tiny radius btn' type='' value=''>Submit for Approval</a>"\
  		"</div>"\
  	"</div>"\
  	"<div id='approver-buttons' class='row buttons-section' style='display:none'>"\
    	"<div class='columns small-15 medium-15 large-15'>"\
    		"<a id='approve-button' class='button tiny radius btn'>Approve</a>"\
    		"<a id='reject-button' class='button tiny radius btn'>Reject</a>"\
  		"</div>"\
  	"</div>"\
    "</form>"
    	
	  content.html_safe
  end
  
  def build_expense_rows( user, expenses, db_cols, show )
    content = "<div id='#{user}' class='row expense_table' style='display: #{show == true ? 'block' : 'none'}'>"\
  	"<div class='columns small-15 medium-15 large-15' style='width:100%' >"\
  		"<table class='expense-table-contents'>"\
  		  "<thead>"\
  		    "<tr>"\
  		      "<th class='date'> Receipt Date </th>"\
  		      "<th class='vendor'> Vendor </th>"\
  		      "<th class='amount'> Amount </th>"\
  		      "<th class='purpose'> Purpose </th>"\
  		      "<th class='status'> Status </th>"\
  		    "</tr>"\
  		  "</thead>"\
  		  "<tbody>"
        
        unless expenses.nil?
    		  if !expenses.nil? && expenses.size > 0
      		  expenses.each do |expense|
      		    amount = 0.00
      		    content += "<tr class='pending_expenses' value='#{expense[db_cols[:status]]}'>"
      		      expense.attributes.each do |name, value|
                    # content += "<input id='#{name}' type='hidden' value='#{_value}'></input>"
                    content += "<input id='#{db_cols.key(name)}' type='hidden' value='#{value}'></input>"
  	      		  end		     

  	      		  date = expense[db_cols[:date]] ? expense[db_cols[:date]].to_time.strftime('%m/%d/%Y') : expense[db_cols[:date]]
      		      content += "<td class='date'>#{date}</td>"\
      		      "<td class='vendor'>#{expense[db_cols[:vendor]]}</td>"\
      		      "<td class='amount total'>#{expense[db_cols[:total]]}</td>"\
      		      "<td class='purpose'>#{expense[db_cols[:purpose]]}</td>"\
      		      "<td class='status'>#{expense[db_cols[:status]]}</td>"\
      		    "</tr>"
    		    end
          end
        end
        blank_rows = 9
        expense_count = expenses.nil? ? 0 : expenses.size
        blank_rows = expense_count < blank_rows ? blank_rows - expense_count : 0
        #content += "<tr>blank rows #{blank_rows}, expense count #{expense_count}</tr>"
        blank_rows.times do |i|
          content += "<tr class='blank_expenses'>"\
            "<td class='date'></td>"\
  		      "<td class='vendor'></td>"\
  		      "<td class='amount total'></td>"\
  		      "<td class='purpose'></td>"\
  		      "<td class='status'></td>"\
          "</tr>"
        end 

    		content += "</tbody>"\
    		"</table>"\
    	"</div>"\
    "</div>"
    
    content
  end
  
  
  def current_expenses( user, expenses, db_cols, reviewees, reviewee_expenses )
    content = build_expense_rows( user, expenses, db_cols, true )
    if !reviewees.nil? && reviewees.size > 0
      reviewees.each do |person|
        content += build_expense_rows( 'pending_' + person[db_cols[:employeeid]], reviewee_expenses[person[db_cols[:employeeid]]], db_cols, false )
      end
    end
    content += build_expense_rows( "blank_rows", nil, nil, false )
    content.html_safe
  end

end
