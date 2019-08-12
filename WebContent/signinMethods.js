//Ruilin Liu	8011071387	ruilinli@usc.edu
/**
 * 
 */
var id_token;
var access_token;
 function onSignInJump(googleUser) {
		        // Useful data for your client-side scripts:
		        var profile = googleUser.getBasicProfile();
		        console.log("ID: " + profile.getId()); // Don't send this directly to your server!
		        console.log('Full Name: ' + profile.getName());
		        console.log('Given Name: ' + profile.getGivenName());
		        console.log('Family Name: ' + profile.getFamilyName());
		        console.log("Image URL: " + profile.getImageUrl());
		        console.log("Email: " + profile.getEmail());
		
		        // The ID token you need to pass to your backend:
		        id_token = googleUser.getAuthResponse().id_token;
		        access_token=googleUser.getAuthResponse().access_token;
		        console.log("ID Token: " + id_token);
		        console.log("Access Token: "+access_token);
		        //location.href="logged-in.html";
		        toProfile();
		      };
		      
  function onSignIn(googleUser) {
        // Useful data for your client-side scripts:
        var profile = googleUser.getBasicProfile();
        console.log("ID: " + profile.getId()); // Don't send this directly to your server!
        console.log('Full Name: ' + profile.getName());
        console.log('Given Name: ' + profile.getGivenName());
        console.log('Family Name: ' + profile.getFamilyName());
        console.log("Image URL: " + profile.getImageUrl());
        console.log("Email: " + profile.getEmail());

        // The ID token you need to pass to your backend:
        id_token = googleUser.getAuthResponse().id_token;
        access_token=googleUser.getAuthResponse().access_token;
        console.log("ID Token: " + id_token);
        console.log("Access Token: "+access_token);
      };
     
  function toHome(){
	  //jquery from logicbig.com
	  var form = $('<form action="' + "LoginServlet" + '" method="post">' +
              '<input type="hidden" name="id" value="' +
               id_token + '" />' +
               '<input type="hidden" name="field" value="' +
               "Home" + '" />' +
               '<input type="hidden" name="access_token" value="' +
               access_token + '" />' +
                                                    '</form>');
	  	$('body').append(form);
	  	form.submit();
  }
  
  function toProfile(){
	  //jquery from logicbig.com
	  var form = $('<form action="' + "LoginServlet" + '" method="post">' +
              '<input type="hidden" name="id" value="' +
               id_token + '" />' +
               '<input type="hidden" name="field" value="' +
               "Profile" + '" />' +
               '<input type="hidden" name="access_token" value="' +
               access_token + '" />' +
                                                    '</form>');
	  	$('body').append(form);
	  	form.submit();
  }
  
  function toProfile2(idToken,accessToken){
	  id_token=idToken;
	  access_token=accessToken;
	  var form = $('<form action="' + "LoginServlet" + '" method="post">' +
              '<input type="hidden" name="id" value="' +
               id_token + '" />' +
               '<input type="hidden" name="field" value="' +
               "Profile" + '" />' +
               '<input type="hidden" name="access_token" value="' +
               access_token + '" />' +
                                                    '</form>');
	  	$('body').append(form);
	  	form.submit();
  }
  
  function toHome2(idToken,accessToken){
	  id_token=idToken;
	  access_token=accessToken;
	  var form = $('<form action="' + "LoginServlet" + '" method="post">' +
              '<input type="hidden" name="id" value="' +
               id_token + '" />' +
               '<input type="hidden" name="field" value="' +
               "Home" + '" />' +
               '<input type="hidden" name="access_token" value="' +
               access_token + '" />' +
                                                    '</form>');
	  	$('body').append(form);
	  	form.submit();
  }

  function signOut() {
	    var auth2 = gapi.auth2.getAuthInstance();
	    auth2.signOut({ "prompt": "none" }).then(function () {
	      console.log('User signed out.');
	    window.close();
	    location.href="sign-in.html";
    });
  }