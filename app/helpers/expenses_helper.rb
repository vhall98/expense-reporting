module ExpensesHelper
  
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
                date = (expense[db_cols[:date]].to_s.split())[0].split('-')
      		      content += "<td class='date'>#{date[1] + '/' + date[2] + '/' + date[0]}</td>"\
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
