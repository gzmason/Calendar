//Ruilin Liu	8011071387	ruilinli@usc.edu
/**
 * 
 */
 function follow(userID1,friendID1,userAccessToken){
	$.ajax({
		url:"FollowServlet",
		data:{
			field:"Follow",
			userID:userID1,
			friendID:friendID1,
			userAccessToken:userAccessToken
		},
		success:function(result){
			$("#eventTable").html(result);
			$("#ButtonContainer").html("<button class=\"followButton\" onclick=\"unfollow("+userID1+","+friendID1+")\">Unfollow</button>");
		}
	})
 }
 function unfollow(userID1,friendID1){
	 $.ajax({
			url:"FollowServlet",
			data:{
				field:"Unfollow",
				userID:userID1,
				friendID:friendID1
			},
			success:function(result){
				$("#eventTable").html(result);
				$("#ButtonContainer").html("<button class=\"followButton\" onclick=\"follow("+userID1+","+friendID1+")\">Follow</button>");
			}
		})
 }
 