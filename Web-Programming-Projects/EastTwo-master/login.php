<div class="container">

	<div><?php if(isset($_GET['loginfailed'])){echo "<script> toastr.options = {'positionClass': 'toast-top-center'}; toastr.error('Credentials not found')</script>";}  ?></div>
      <form class="form-signin" action="index.php?action=login" method="POST">
        <h2 class="form-signin-heading">Please sign in</h2>
        <label for="inputEmail" class="sr-only">Email address</label>
        <input type="email" id="inputEmail" name="Email" class="form-control" placeholder="Email address" required autofocus>
        <label for="inputPassword" class="sr-only">Password</label>
        <input type="password" id="inputPassword" name="Password" class="form-control" placeholder="Password" required>
        <button class="btn btn-lg btn-primary btn-block" type="submit">Sign in</button>
      </form>

</div> <!-- /container -->