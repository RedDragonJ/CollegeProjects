<div class="container">

    <div class="panel panel-default">
        <div class="panel-body">

            <div class="jumbotron">
                <h1>Welcome Back Algimee!</h1>
                <p class="lead">Log In</p>
            </div>




        </div>
    </div>

    <div class="well">

		<form action="index.php?action=login" method="post" class="form-horizontal">
			<div class="form-group">
				<label for="username" class="col-sm-2 control-label">Username:</label>
				<div class="col-sm-10">
					<input type="text" name="Email" class="form-control" id="inputUsername" placeholder="Username" required>
				</div>
			</div>
			<br>
			<div class="form-group">
				<label for="password" class="col-sm-2 control-label">Password:</label>
				<div class="col-sm-10">
					<input type="password" name="Password" class="form-control" id="inputPassword" placeholder="Password" required>
				</div>
			</div>
			<br>
			<div class="form-group">
				<div class="col-sm-offset-2 col-sm-10">
					<button type="submit" class="btn btn-primary btn-lg btn-block">Log in</button>
				</div>
			</div>
		</form>
    </div>



</div>
