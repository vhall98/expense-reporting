//= require jquery
//= require csys
//= require jquery.validate
//= require jquery.validate.additional-methods

var Csys = Csys || {};
Csys.Sessions = (function() {


	// removeErrorObjects = = = = =
	// removeErrorObjects = = = = =
	// removeErrorObjects = = = = =
	
	// When errors occur when creating a new account, the form wraps the inputs inside error objects:
	//
	//  <div class="field_with_errors">
	//		<input type="text" value="" size="30" name="user[username]" id="user_username" class="text-field">
	//	</div> 
	//	<p></p>
	//
	// The code below extracts the inputs from the error object and then deletes the error object/div
	// and the <p> that follows.  
	//

	var removeErrorObjects = function(value) {    
		var field_with_errors = $('#new_signup ').find('form div.field_with_errors');
		field_with_errors.each( function() { 
			var prev = $(this).prev();
			var _input = $(this).find('input');
			prev.append(_input);
			$(this).next().remove();
			$(this).remove();
		});
	};


  // onDomReady = = = = =
  // onDomReady = = = = =
  // onDomReady = = = = =

  $(document).ready( function(){
    removeErrorObjects();
  });

  // return = = = = =
  // return = = = = =
  // return = = = = =

    return {
        removeErrorObjects:        removeErrorObjects
	};
})();