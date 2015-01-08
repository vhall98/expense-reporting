//= require jquery
//= require csys
//= require jquery.validate
//= require jquery.validate.additional-methods

var Csys = Csys || {};
Csys.Expense = ( function() {
	
	// initExpensePage = = = = =
	// initExpensePage = = = = =
	// initExpensePage = = = = =
	
	var initExpensePage = function(e) {
		if ( !$('#signup').is(':visible') ) {
			$('#logged-in-page').toggle();
		}
		var approve = 0;
		
		var main_user = $('#main-user').val();
		$('#system-hdr').html("Expenses for: " + main_user);
		//
		// add calendar/datepicker to page
		//
		$('#expense_date').fdatepicker();
		var closeButton = $(".datepicker").find('a.datepicker-close'); 
		if ( closeButton ) {
			closeButton.hide();
		}
		
		if ( $('#nav-approve-expenses').is(':visible') ) {
			approve = 1;	// Set this if Approve is visible in nav box.
							// Check authentication/permission value set 
							// by controller to hide/show Approve in helper file.
		}
		else if ( $('#new-button').is(':visible') ) {
			$('#main').removeClass('row').addClass('short-row');
		}
							
		_setupLeftSideNavClicks(approve);
		_disable_total_box();
		
		var expense_tables = $('#expenses-page #expense-table div.expense_table');
		expense_tables.each(function() {
			var expenses = $(this).find('table tbody tr.pending_expenses');
			_setupTableRowEditing(expenses); 
		});

		if ( approve == 1 ) {
			_setupToApproveList();
			_setupApproveButtons();
		}
    },


	// _disable_total_box = = = = =
	// _disable_total_box = = = = =
	// _disable_total_box = = = = =

	 _disable_total_box = function() {
		$('#expense_total').keydown( function(e) {
			e.preventDefault();
		});
    },
	
	
	// _setupToApproveList = = = = =
	// _setupToApproveList = = = = =
	// _setupToApproveList = = = = =

	 _setupToApproveList = function() {
		var to_approve_list = $('#approve-list li');
		
		to_approve_list.click( function() {
			$(this).addClass('yellow2');
			var exp_to_view = $(this).attr('value');
			var viewing = $('#viewing').val();
			if ( viewing !== "blank_rows" ) { 
				var _name = (viewing.split('_'))[1];
				$('#expense_'+_name).removeClass('yellow2');
				var c = $('#'+viewing).find('table tbody tr.yellow');
				if ( c.length > 0 ) {
					c.removeClass('yellow');
				}
			}
			
			$('#'+viewing).hide();
			$('#'+exp_to_view).show();
			$('#viewing').attr('value', exp_to_view);
			$('#system-hdr').html("Expenses to approve for: " + (exp_to_view.split('_'))[1]);			
		});
	},
	

	// _setupApproveButtons = = = = =
	// _setupApproveButtons = = = = =
	// _setupApproveButtons = = = = =

	 _setupApproveButtons = function() {

		$('#approve-button, #reject-button').click( function (e) {
			var action_url = "/approve";
			
			if ( $(this).attr('id').match(/reject/i)) {
				action_url = "/reject";
			}
			var id = $(this).attr('value');
			action_url += '/'+id;
			
			$.ajax({
				context: this,
				url: action_url,
				type: 'post',
				dataType: 'json',
				success: _success_ok,
				error: _process_error
			});
		});
	},
	
		
	// _setupLeftSideNavClicks = = = = =
	// _setupLeftSideNavClicks = = = = =
	// _setupLeftSideNavClicks = = = = =

	 _setupLeftSideNavClicks = function(approve) {
		if ( approve == 1 ) {
			$('#nav-approve-expenses').click( function() {
				if ( !$('#approve-button').is(':visible') ) {
					$('#approve-list').toggle();
					$('#expense-buttons').toggle();
					$('#approver-buttons').toggle();
					$('#'+$('#viewing').val()).toggle();
					$('#blank_rows').css('display', 'block');
					$('#viewing').attr('value', "blank_rows");
				}
				else {
					$('#approve-list').toggle();
				}
				$('#approve-button, #reject-button').attr('disabled', true).addClass('darken');
				
				var main_user = $('#main-user').val();
				var len = $('#'+main_user).find('table tbody tr.yellow').length;
				len > 0 ? $('#'+main_user).find('table tbody tr.yellow').removeClass('yellow') : len;
			});
		}
	
		$('#nav-expense-form').click( function() {
			var main_user = $('#main-user').val();
			$('#system-hdr').html("Expenses for: " + main_user);
			
			if ( $('#approve-button').is(':visible') ) {
				$('#approve-list').toggle();
				$('#expense-buttons').toggle();
				$('#approver-buttons').toggle();
				
				var $inputs = $('#receipt-form :input');
				$inputs.removeAttr('disabled');
				
				var viewing = $('#viewing').val();			
				$('#'+viewing).css('display', 'none');
			
				if ( viewing != 'blank_rows') {
					var _name = (viewing.split('_'))[1];
					$('#expense_'+_name).removeClass('yellow2');
					var c = $('#'+viewing).find('table tbody tr.yellow');
					if ( c.length > 0 ) {
						c.removeClass('yellow');
					}
				}
				
				var main_user = $('#main-user').val();
				$('#'+main_user).toggle();
				$('#viewing').attr('value', main_user);
			}
		});
	},
		
		
	// _setupTableRowEditing = = = = =
	// _setupTableRowEditing = = = = =
	// _setupTableRowEditing = = = = =

	 _setupTableRowEditing = function(expenses) {
		var rows = expenses;
		if ( rows.length > 0 ) {
			rows.click( function() {
				rows.removeClass('yellow');
				$(this).addClass('yellow');
				var row_inputs = $(this).find('input');
				row_inputs.each(function() {
					if ( this.id == "id" ) {
						$('#submit-button').attr('value', $(this).val());
						$('#delete-button').attr('value', $(this).val());
					}
					var _input = $('#expense_' + this.id); // Form inputs identified by expense_<xxxxxx>
					if ( _input.length > 0 ) {
						_input.val($(this).val() == null ? "":$(this).val());
						_input.attr('value', $(this).val());
						if ( _input.children().length > 0 ) {
							_input.children().each( function() {
								if ( $(this).val() == _input.val() ) {
									$(this).attr('selected', 'selected');
								}
							});
						}
						else if ( _input.is(':checkbox') ) {
							var val = _input.val() == "false" ? 0 : 1;
							_input.val(val);
							if ( _input.val() == 0 ) {
								_input.removeAttr('checked');
							}
							else {
								_input.attr('checked', '');
							}
						}
						else {
							_input.html($(this).val() == null ? "":$(this).val());		
						}
					}
			    });
				_clearErrors();
				if ( $('#approve-button').is(':visible') ) {
					$('#approve-button, #reject-button').removeAttr('disabled');
					var id = $(this).find('#id').attr('value');
					$('#approve-button, #reject-button').attr('value', id);
				}
				else {
					$('#save-button, #cancel-button').addClass('disable');			
					var $inputs = $('#receipt-form :input');
					$inputs.attr('disabled', true);
					$("#expense_total").removeAttr('disabled');
					$('#delete-button, #new-button, #edit-button').removeAttr('disabled').removeClass('disable');
					$('#submit-button').addClass('disable');
					
					if ( !$(this).attr('value').match(/approval/) && $(this).attr('value').match(/pending/) ) {
						$('#submit-button').removeAttr('disabled').removeClass('disable');
					}
					else if ( $(this).attr('value').match(/approved/) ) {
						$('#edit-button').addClass('disable').attr('disabled', true);
					}					
				}
			});			
		}
	},		


	// calcTotalFromAmounts = = = = =
	// calcTotalFromAmounts = = = = =
	// calcTotalFromAmounts = = = = =

	 calcTotalFromAmounts = function() {
		$('.numeric').keydown( function(e) {
			_suppressNonNumericInput(e, $(this));
		});
		$('.numeric').keyup( function(e) {
			var test = $(this).val();
			if ( _IsFloatOnly($(this).val()) ) {
				$(this).val(parseFloat($(this).val()).toFixed(2));
			}
			_calcReceiptsTotal();
		});
    },
	
		
	// _clearErrors = = = = =
	// _clearErrors = = = = =
	// _clearErrors = = = = =

	 _clearErrors = function() {
		var errors = $('#receipt-form').find('.yellow');
		if ( errors && errors.length > 0 ) {
			errors.each( function () {
				$(this).removeClass('yellow');
			});
			$("#form-error").css('display', 'none');
		}
	},
	

	// displayUserLoggedIn = = = = =
	// displayUserLoggedIn = = = = =
	// displayUserLoggedIn = = = = =

	 displayUserLoggedIn = function() {
		var user = $('#expense_updateuser').val();

		$('#logged-in').html("user: " + user).css('display', 'block');
		if ( !$('#nav-approve-expenses').is(':visible') ) {
			$('#leftContent').remove();
			$('#logged-in-page').css('float', 'left');
		}
		else {
			$('#mainContent').removeClass("small-15 medium-15 large-15").addClass("small-12 medium-12 large-12");
		}
	},


	// disable_inputs = = = = =
	// disable_inputs = = = = =
	// disable_inputs = = = = =

	 disable_inputs = function(disable) {
		var $inputs = $('#receipt-form :input');

		disable ? $inputs.attr('disabled', true).addClass('disable') : 
					$inputs.removeClass('disable').removeAttr('disabled');
	},


	// clear_form = = = = =
	// clear_form = = = = =
	// clear_form = = = = =

	 clear_form = function() {
		var $inputs = $('#receipt-form :input');
		$('#expense_date').val('');
		// var receipt = $inputs.filter(function() {
		//     return /receipt/i.test($(this).attr('id'));
		// });
		// receipt.val(0);
	},
	
	
	// setupButtons = = = = =
	// setupButtons = = = = =
	// setupButtons = = = = =

	 setupButtons = function() {
		$('#cancel-button, #delete-button, #edit-button, #save-button, #submit-button').addClass('disable').attr('disabled', true);
		$('#new-button').removeAttr('disabled').removeClass('disable');

		$('#save-button, #submit-button').click( function(e) {	
		    e.preventDefault();
			_clearErrors();
			if ($('#receipt-form').valid()) {
				if ( $(this).attr('name') == "submit" ) {
					$('#action').attr('value', '/submit/'+$(this).attr('value'));
					$(this).addClass('disable').attr('disabled', true);
				}
				else {
					$('#action').attr('value', '/save');
					$('#new-button').removeAttr('disabled').removeClass('disable');
					$('#cancel-button, #save-button').addClass('disable').attr('disabled', true);
				}
				$('#receipt-form').submit();
				disable_inputs(true);
			}
		});

		$('#edit-button').click( function(e) {
			$('#delete-button, #edit-button, #new-button, #submit-button').addClass('disable').attr('disabled', true);
			$('#cancel-button, #save-button').removeAttr('disabled').removeClass('disable');
			disable_inputs(false);
		});

		$('#delete-button').click( function(e) {
			var action = "/delete/" + $(this).attr('value');
			disable_inputs(true);
			$('#edit-button, #cancel-button, #delete-button, #save-button, #submit-button').addClass('disable').attr('disabled', true);
			$('#new-button').removeAttr('disabled').removeClass('disable');
			if ( !$('#edit-button').hasClass('disable') ) {
				$('#edit-button').addClass('disable').attr('disabled', true);
			}
		
			$.ajax({
			      context:this,
			      url: action,
			      type: 'post',
			      dataType: 'json',
			      success: _success_ok,
			      error: _process_error
		    });
		});
	
		$('#cancel-button, #new-button').click( function(e) {
			_clearErrors();
			var novalid = $('#receipt-form').attr('novalidate');
			if ( novalid == 'novalidate' ) {
				$('#receipt-form').removeAttr('novalidate');
			}

			var expenses = $('#expense-table').find('table tbody tr.pending_expenses');
			expenses.removeClass('yellow'); 
			
			if ( $(this).hasClass('cancel') ) {	
				$('#delete-button, #edit-button, #save-button, #submit-button').addClass('disable').attr('disabled', true);
				disable_inputs(true);
				$('#new-button').removeAttr('disabled').removeClass('disable');
			}
			else {  // New button clicked if you made it here.
				$('#expense_receiptno').attr('value', 0).html(0);
				$(this).addClass('disable').attr('disabled', true);
				if ( !$('#edit-button').hasClass('disable') ) {
					$('#edit-button').addClass('disable').attr('disabled', true);
				}
				$('#save-button, #cancel-button').removeAttr('disabled').removeClass('disable');
				$('#new-button, #submit-button, #delete-button').addClass('disable').attr('disabled', true);
				disable_inputs(false);

			}			
		});
    },


	// _success_ok = = = = =
	// _success_ok = = = = =
	// _success_ok = = = = =

	 _success_ok = function(data) {
		//
		// This function processes reject, delete, and approve
		//
		var main_user = $('#main-user').val();
		var _tbody = $('#'+main_user).find('table tbody');

		var min_rows = get_min_blank_rows();
		
		if ( data["action"] == "delete" ) {
			_tbody.find('.yellow').remove();
			var exp_len = _tbody.find('.pending_expenses').length;
			if ( exp_len < min_rows ) {
				adjust_blank_rows(_tbody, 1);
			}			
			
			// If you're an approver and you delete an expense from your expense list, then delete it from the 
			//   "Employee" list that shows your "pending approval" expense.  This means in your expense list,
			//   this expense has status "pending approval".  Since you're approver, you see your name listed 
			//   in the "Employee" list of expenses to approve.
			//
			var pndg_apprvl_exps = data["pending_approval_expenses"];
			if ( pndg_apprvl_exps !== undefined && pndg_apprvl_exps !== null ) {
				update_expense_list($('#pending_'+main_user).find('table tbody'), pndg_apprvl_exps, 'pending_'+main_user, data["action"]); 
			}
		}
		else { // processing approve or reject
			_tbody = $('#'+data["expense_owner"]).find('table tbody');
			var selected = _tbody.find('tr.yellow');
			selected.remove();
			var exp_len = _tbody.find('.pending_expenses').length;
			if ( exp_len < min_rows ) {
				adjust_blank_rows(_tbody, 1);
			}			
			var updated_expenses = data["updated_expenses"];
			if ( updated_expenses !== undefined && updated_expenses !== null ) {
				update_expense_list($('#'+main_user).find('table tbody'), updated_expenses, main_user, data["action"]);
			}
		}
	},


	// update_expense_list = = = = =
	// update_expense_list = = = = =
	// update_expense_list = = = = =

	 update_expense_list = function(elem, expenses_in, user, action) {
		if ( expenses_in !== undefined && expenses_in !== null ) {	// pending_expenses exists only if 
																			//  you're an approver
			var min_rows = get_min_blank_rows();
			var pndg_exps = elem.find('tr.pending_expenses');
			var pndg_len = pndg_exps.length;

			pndg_exps.remove();
		
			if ( action == "delete" && expenses_in.length < min_rows ) {
				adjust_blank_rows(elem, pndg_len);
			}
			else if ( expenses_in.length < min_rows ) {
				adjust_blank_rows(elem, 1);
			}
			
			for (i = 0; i < expenses_in.length; i++) {
				_build_expense_list(elem, expenses_in[i], action);
			}
			_setupTableRowEditing(elem.find('.pending_expenses'));
		}
	},


	// adjust_blank_rows = = = = =
	// adjust_blank_rows = = = = =
	// adjust_blank_rows = = = = =

	 adjust_blank_rows = function(elem, count) {
		for (i = 0; i < count; i++) {
		    elem.append ("<tr class='blank_expenses'><td class='date'></td>" +
		      "<td class='vendor'></td>" +
		      "<td class='amount total'></td>" +
		      "<td class='purpose'></td>" +
		      "<td class='status'></td></tr>");
		}	
	},


	// get_form_inputs = = = = =
	// get_form_inputs = = = = =
	// get_form_inputs = = = = =

	 get_form_inputs = function() {
		var $inputs = $('#receipt-form :input');

		var values = {};
		$inputs.each(function() {
			var _name = this.id ? this.id.split("_") : false;

			if ( $(this).val() && _name && _name[1] ) {
				values[_name[1]] = $(this).val();
			}
		});
		return values;
	},


	// setupValidation = = = = =
	// setupValidation = = = = =
	// setupValidation = = = = =

	 setupValidation = function() {

		 $.validator.addMethod( "isThisElementRequired", function(value, element) {
				var val2 = $(element.getAttribute('data-val')).val();
				val2 = val2 ? true : false;
				var val1 = value ? true : false;
				//
				// val1 will be amountX and val2 will be categoryX or vice versa.
				// If val2 does not exists and val1 does, require val2. 
				// If val2 exists & val1 doesn't, require val1.
				// A return_val of false will trigger val1 to be required.
				//
				var return_val = ((val1 && val2) || !(val1 || val2)) || val1;
				return return_val;
			},
			"Required");

		$('#receipt-form').validate({
			rules: {
				'expense[date]' : {
					required: true
				},
				'expense[category1]' : {
					required: true
				},
				'expense[amount1]' : {
					required: true,
					maxlength: 8
				},
				'expense[amount2]' : {
					isThisElementRequired : true,
					maxlength: 8
				},
				'expense[category2]' : {
					isThisElementRequired: true
				},
				'expense[amount3]' : {
					maxlength: 8,
					isThisElementRequired: true
				},
				'expense[category3]' : {
					isThisElementRequired: true
				},
				'expense[category4]' : {
					isThisElementRequired: true
				},
				'expense[amount4]' : {
					maxlength: 8,
					isThisElementRequired: true
				},
				'expense[category5]' : {
					isThisElementRequired: true
				},
				'expense[amount5]' : {
					maxlength: 8,
					isThisElementRequired: true
				},
				'expense[reason]' : {
					required: true
				},
				'expense[state]' : {
					required: true
				},
				'expense[paidby]' : {
					required: true
				},
				'expense[duration]' : {
					required: true,
					maxlength: 30
				},
				'expense[durationtype]' : {
					required: true
				},
				'expense[vendor]' : {
					required: true,
					maxlength: 50
				},
				'expense[purpose]' : {
					required: true,
					maxlength: 200
				},
				'expense[persons]' : {
					required: true,
					maxlength: 200
				}
			},
			// Specify the validation error messages
			messages: {
				//date: "Please enter a valid date",
			},
			errorPlacement: function(error, element) {    
				element.addClass('yellow');
				if ( $(element)[0].type && $(element)[0].type === 'checkbox') {
					$(element).parent().find('label').addClass('yellow');
				}
			},
			invalidHandler: function(event, validator) {
				var errors = validator.numberOfInvalids();
				if (errors) {
					var message = errors == 1
					? 'You missed 1 field. It has been highlighted'
					: 'You missed ' + errors + ' fields. They have been highlighted';
					$("#form-error span").html(message);
					$("#form-error").css('display', 'block');
				} 
				else {
					$("#form-error").css('display', 'none');
				}
			},
			submitHandler: function() { 
			   var values = get_form_inputs();
			   var action = $('#action').val();
			    $.ajax({
			      context:this,
			      url: action,
			      data: {receipts: values},
			      type: 'post',
			      dataType: 'json',
			      success: _success_save,
			      error: _process_error
			    });
				if ( $('#form-error').css('display') == 'block' ) {
					$('#form-error').css('display', 'none');
				}
			}
		});
	},
	

	// _success_save = = = = =
	// _success_save = = = = =
	// _success_save = = = = =

	 _success_save = function(data) {
		var main_user = $('#main-user').val();
		var _tbody = $('#'+main_user).find('table tbody');	
		var expense = data["expense"];
		var action = data["action"];
		
		_build_expense_list(_tbody, expense, action);
		// if user viewed is the same as main user, which means you are a reviewer, when you update a
		//  pending expense, you need to updated your expense list shown in Employee list.
		if ( expense["status"] == "pending approval"  && $('#viewing').val() == main_user ) {
			var pndg_apprvl_exps = data["pending_approval_expenses"];
			var pndg_apprvl_len = pndg_apprvl_exps.length;
			
			_tbody = $('#pending_'+main_user).find('table tbody');
			_tbody.find('tr.pending_expenses').remove();
			
			var min_rows = get_min_blank_rows();
			if ( pndg_apprvl_len < min_rows ) {
				adjust_blank_rows(_tbody, pndg_apprvl_len-1);
			}
			
			for (i = 0; i < pndg_apprvl_exps.length; i++) {
				_build_expense_list(_tbody, pndg_apprvl_exps[i], action);
			}
		}
	},


	// _build_expense_list = = = = =
	// _build_expense_list = = = = =
	// _build_expense_list = = = = =

	 _build_expense_list = function(elem_tbody, expns_entry, action) {
		var new_exp_row = true;		
		
		var _selected = elem_tbody.find('.yellow').length > 0 ? elem_tbody.find('.yellow') : ( elem_tbody.find('tr.blank_expenses').length > 0 ? 
				elem_tbody.find('tr.blank_expenses').first() : $("<tr class='pending_expenses' value='"+expns_entry["status"]+"'><td class='date'></td>" +
  		      "<td class='vendor'></td>" +
  		      "<td class='amount total'></td>" +
  		      "<td class='purpose'></td>" +
  		      "<td class='status'></td></tr>"));

		var date = expns_entry["date"].split('-');
		var formatted = date[1] + '/' + date[2] + '/' + date[0];

		_selected.find('td.date').attr('value', expns_entry["date"]).html(formatted);
		_selected.find('td.vendor').attr('value', expns_entry["vendor"]).html(expns_entry["vendor"]);
		_selected.find('td.total').attr('value', expns_entry["total"]).html(expns_entry["total"]);
		_selected.find('td.purpose').attr('value', expns_entry["purpose"]).html(expns_entry["purpose"]);
		_selected.find('td.status').attr('value', expns_entry["status"]).html(expns_entry["status"]);
		_selected.attr('value', expns_entry["status"]);
		
		var yellow_len = elem_tbody.find('.yellow').length;
		var blanks_len = elem_tbody.find('tr.blank_expenses').length;
		if ( yellow_len > 0 ) {
			_selected.find('input').remove();
		}
		else if ( blanks_len > 0 ) {
			_selected.removeClass('blank_expenses').addClass('pending_expenses').attr('value', expns_entry["status"]);
			new_exp_row = false;
		}
		
		$.each(expns_entry, function (_name, value) {
		    _selected.append("<input id='" + _name + "' type='hidden' value='" + value + "'></input>");
		});
		
		if ( yellow_len == 0 ) {
			if ( new_exp_row == true ) {
				elem_tbody.find('.pending_expenses').unbind();
				elem_tbody.prepend(_selected);
				_sort_expenses(elem_tbody);
				_setupTableRowEditing(elem_tbody.find('.pending_expenses'));
				// elem_tbody.find('.pending_expenses').first().addClass('yellow');
			}
			else {
				elem_tbody.find('.pending_expenses').unbind();
				_sort_expenses(elem_tbody);
				_setupTableRowEditing(elem_tbody.find('.pending_expenses'));
			}
		}
	},


	// sort_by_date = = = = =
	// sort_by_date = = = = =
	// sort_by_date = = = = =	

	 _sort_by_date = function(a, b) {
		if($(a).find('#date').val() < $(b).find('#date').val()) return -1;
		if($(a).find('#date').val() > $(b).find('#date').val()) return 1;
		return 0;
    },


	// sort_expenses = = = = =
	// sort_expenses = = = = =
	// sort_expenses = = = = =	

	 _sort_expenses = function( list ) {
	    var list_tr = list.find('tr.pending_expenses'); //$("#table1 > li").get();
	    list_tr.sort(_sort_by_date);
		list.find('tr.pending_expenses').remove();
		list.prepend(list_tr);
	},
	
		
	// _process_error = = = = =
	// _process_error = = = = =
	// _process_error = = = = =	
	
	 _process_error = function(e) {
		console.log("submitHandlerERROR", e);
		alert(e.meta.errorMsg);
	},
	
	
	// _calcReceiptsTotal = = = = =
	// _calcReceiptsTotal = = = = =
	// _calcReceiptsTotal = = = = =
		
	 _calcReceiptsTotal = function() {
		var amounts = $('#receipt-form').find('.amount');
		var calc = 0.00;

		amounts.each( function() {
			if ( $(this).val() ) {
				if ( !isNaN(1*$(this).val()) ) {
					calc = 1*$(this).val() + 1*calc;
				}
				calc = ""+calc;
				if ( !calc.match(/\./) ) {
					calc = parseFloat(calc).toFixed(2);
				}		
			}
		});
		$("#expense_total").attr('value', calc).val(calc);
	},
	

	// _suppressNonNumericInput = = = = =
	// _suppressNonNumericInput = = = = =
	// _suppressNonNumericInput = = = = =
	
	 _suppressNonNumericInput = function(event, elem){
		var val = elem.val();

	    if ( elem.attr('name') == 'expense[total]'				// disable column text box. No input.
			|| !(event.keyCode == 8								// backspace
		    || event.keyCode == 190                             // Mac keyboard period
	        || event.keyCode == 46                              // delete or period
	        || (event.keyCode >= 35 && event.keyCode <= 40)     // arrow keys/home/end
	        || (event.keyCode >= 48 && event.keyCode <= 57)     // numbers on keyboard
	        || (event.keyCode >= 96 && event.keyCode <= 105)	// number on keypad
	        || ((elem.attr('name') == 'date') 
				&& (event.keyCode == 191 
					|| event.keyCode == 47)) ) // allow forward slash for date textbox
	        ) {
	            event.preventDefault();     // Prevent character input
			}
		else if ( (event.keyCode == 190 || event.keyCode == 46) && 
			( !(val === undefined || val === null || val === "") && val.match(/\./)  // don't allow another period
			|| (val === undefined || val === null || val === "") ) ) { // no digits present so don't allow period
				event.preventDefault();     // Prevent character input
		}
	},
	
	
	// get_min_blank_rows = = = = =
	// get_min_blank_rows = = = = =
	// get_min_blank_rows = = = = =
	
	 get_min_blank_rows = function() {    
		return 9;
	},

	// _IsFloatOnly = = = = =
	// _IsFloatOnly = = = = =
	// _IsFloatOnly = = = = =
	
	 _IsFloatOnly = function(value) {    
		var regExp1 = /^\d+(\.(\d\d))/;
		var regExp2 = /^\d+(\.(\d\d\d))/;
		return regExp1.test(value) || regExp2.test(value);
	};

  // onDomReady = = = = =
  // onDomReady = = = = =
  // onDomReady = = = = =

  $(document).ready( function(){
    initExpensePage();	
	displayUserLoggedIn();
	setupValidation();
	disable_inputs(true);
	setupButtons();
	calcTotalFromAmounts();
  });

  // return = = = = =
  // return = = = = =
  // return = = = = =

    return {
        initExpensePage:        initExpensePage,
		displayUserLoggedIn: 	displayUserLoggedIn,
		setupValidation: 		setupValidation,
		disable_inputs: 		disable_inputs,
		setupButtons: 			setupButtons,			
		calcTotalFromAmounts: 	calcTotalFromAmounts
	};
})();