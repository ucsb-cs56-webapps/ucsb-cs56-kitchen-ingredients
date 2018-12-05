<nav class="navbar navbar-expand-md navbar-dark bg-dark">
    <div class="navbar-collapse collapse w-100 order-1 order-md-0 dual-collapse2">
        <ul class="navbar-nav mr-auto">
            <li class="nav-item active">
                <a class="nav-link" href="/ingredients">Ingredients</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="/recipes">Recipes</a>
            </li>
        </ul>
    </div>
    <div class="mx-auto order-0">
        <a class="navbar-brand mx-auto" href="#">Kitchen Ingredients</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target=".dual-collapse2">
            <span class="navbar-toggler-icon"></span>
        </button>
    </div>
    <div class="navbar-collapse collapse w-100 order-3 dual-collapse2">
        <ul class="navbar-nav ml-auto">
            <li class="nav-item">
                <div class="container authenticated" style="display: none">
                    Logged in as: <span id="user"></span>
                <div>
            </li>
            <li class="nav-item">
                <button onClick="logout()" type="button">Logout </button>
            </li>
        </ul>
    </div>
</nav>

<script>
	   $.ajaxSetup({
                beforeSend : function(xhr, settings) {
                  if (settings.type == 'POST' || settings.type == 'PUT'
                      || settings.type == 'DELETE') {
                    if (!(/^http:.*/.test(settings.url) || /^https:.*/
                        .test(settings.url))) {
                      xhr.setRequestHeader("X-XSRF-TOKEN",
                          Cookies.get('XSRF-TOKEN'));
                    }
                  }
                }
              });

          $.get("/user", function(data) {
	    var id =data.userAuthentication.details.id;
	    var email =data.userAuthentication.details.email;

            var ref = firebase.database().ref('users/' + id);
	    ref.once("value")
		.then(function(snapshot) {
			var a = snapshot.exists();
			if (!a) {
				ref.set(email);
	    			}
		});
            $("#user").html(data.userAuthentication.details.email);
            $(".unauthenticated").hide()
            $(".authenticated").show()
          });

           var logout = function() {
            $.post("/logout", function() {
              $("#user").html('');
              $(".unauthenticated").show();
              $(".authenticated").hide();
	      location.href='/';
            })
            return true;
          }

</script>
