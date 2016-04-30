<div class="container body-container">
<div class="row">
	<div class="col-md-6">
		<h2>Add New User</h2>
		<div class="well">
			 <form class="form-horizontal" role="form" id="addUserForm" onsubmit="return validateForm()" action="index.php?action=createUser" method="POST">
			 <div class="form-group">
			    <label class="control-label col-sm-2" for="fn">First Name:</label>
			    <div class="col-sm-10">
			      <input type="text" name="firstName" class="form-control" id="fn" placeholder="Enter first name" required>
			    </div>
			  </div>
			   <div class="form-group">
			    <label class="control-label col-sm-2" for="ln">Last Name:</label>
			    <div class="col-sm-10">
			      <input type="text" name="lastName" class="form-control" id="ln" placeholder="Enter last name" required>
			    </div>
			  </div>
              <div class="form-group">
                <label class="control-label col-sm-2" for="email">Email:</label>
			    <div class="col-sm-10">
			      <input type="email" name="email" class="form-control" id="email" placeholder="Enter email" required>
			    </div>
			  </div>
			  <div class="form-group">
			    <label class="control-label col-sm-2" for="pwd">Password:</label>
			    <div class="col-sm-10">
			      <input type="password" name="password" class="form-control" id="pwd" placeholder="Enter password" required>
			    </div>
			  </div>
			  <div class="form-group">
			    <label class="control-label col-sm-2" for="confpwd">Confirm Password:</label>
			    <div class="col-sm-10">
			      <input type="password" name="confirmPassword" class="form-control" id="confpwd" placeholder="Confirm password" required>
			    </div>
			  </div>
			  <div class="form-group">
			    <label class="control-label col-sm-2" for="at">Account Type:</label>
			    <div class="col-sm-10">
			      <select name="accountType">
			      	<option value=0 selected>0 - Student</option>
			      	<option value=1>1 - Staff</option>
			      </select>
			    </div>
			  </div>
			  <div class="form-group">
			    <div class="col-sm-offset-2 col-sm-10">
			      <button type="submit" class="btn btn-default">Submit</button>
			    </div>
			  </div>
            </form>		
			</div>
		</div>
	</div>
</div>

<script>

function validateForm(){

	pwd = $('#pwd').val();
	confpwd = $('#confpwd').val();
	if(pwd !== confpwd){

		toastr.error("Passwords do not match");
		return false;
	}
	if(pwd.length < 8){

		toastr.error("Password must be at least 8 characters long");
		return false;
	}
	return true;
}
</script>
