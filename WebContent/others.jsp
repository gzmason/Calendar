<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import ="java.util.List"%>
<%@ page import ="com.google.api.services.calendar.model.Event"%>
<%@ page import ="java.text.DateFormat"%>
<%@ page import ="java.text.SimpleDateFormat"%>
<%@ page import ="com.google.api.client.util.DateTime"%>
<%@ page import ="java.util.Date"%>
<%@ page import ="com.google.api.client.googleapis.auth.oauth2.GoogleCredential"%>
<%@ page import ="com.google.api.services.calendar.Calendar"%>
<%@ page import="com.google.api.client.http.javanet.NetHttpTransport"%>
<%@ page import="com.google.api.client.json.jackson2.JacksonFactory" %>
<%@ page import="com.google.api.services.calendar.model.Events" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.Statement" %>
<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <meta name="google-signin-scope" content="https://www.googleapis.com/auth/calendar">
    <meta name="google-signin-client_id" content="231408607225-t5smqmc1ua87kchb94embbf3a892i6qd.apps.googleusercontent.com">
    <script src="https://apis.google.com/js/platform.js" async defer></script>
    <script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
    <link rel="stylesheet" type="text/css" href="sign-in.css" />
    <script src="signinMethods.js"></script>
    <script src="followMethods.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<meta charset="ISO-8859-1">
<title>Search</title>
</head>
<body>
 	<%
			String idToken=(String)session.getAttribute("idToken");
			String access_token=(String)session.getAttribute("access_token");
			String name = (String)session.getAttribute("userName");
			String pictureUrl = (String)session.getAttribute("picture");
			int userID=(int)session.getAttribute("userID");
	%>
	
	<script type="text/javascript">
			var Msg ='<%=request.getAttribute("success")%>';
		    if (Msg != "null") {
		 	function alertName(){
		 		alert(Msg);
		 	} 
		 	}
 	</script> 
	
	<div id="menubar">
			<div id="ToLogged-in">
				<li class="menuitem" ><a href="logged-in.html" style="color:white;font-family:American Typewriter, sans-serif;text-decoration:none;">Sycamore Calendar</a></li>
			</div>
			
			<div id="search-container">
			    <form action="search.jsp">
			      <input type="text" placeholder="Search Friends" name="search">
			      <button type="submit"><i class="fa fa-search"></i></button>
			    </form>
			 </div>
			 
       		<ul id="menulist">
          		<li class="menuitem" ><a onclick="toProfile2('<%=idToken%>','<%=access_token%>')" style="color:white;font-family:American Typewriter;text-decoration:none;">Profile</a></li>
          		<li class="menuitem" ><a onclick="toHome2('<%=idToken%>','<%=access_token%>')" style="color:white;font-family:American Typewriter;text-decoration:none;">Home</a></li>
        	</ul>
      </div>
      <br/><br/><br/>
	
	<%	
		String userID_result=request.getParameter("userID_result"); 
		Connection conn=null;
		Statement st=null;
		ResultSet rs=null;
		PreparedStatement ps=null;	
		String username_result="";
		String pictureUrl_result="";
		String userFname="";
		int relationID=-1;
		
		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/assignment3?user=root&password=root&useSSL=false&useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC");
			st=conn.createStatement();
			rs=st.executeQuery("SELECT * FROM userList WHERE userID="+userID_result);
			while(rs.next())
			{
				username_result=rs.getString("username");
				pictureUrl_result=rs.getString("pictureUrl");
				String nameArray[]=username_result.split(" ");
				userFname=nameArray[0];
			}
			rs.close();
			//check if current user has followed the result user
			rs=st.executeQuery("SELECT * FROM relationlist WHERE userID="+userID+" AND friendID="+userID_result);
			if(rs.next())//if exists such relation
			{
				relationID=rs.getInt("relationID");
				rs.close();%>
				<div style="color:black;font-family:American Typewriter, sans-serif;text-decoration:none;font-size: 25px;padding-left:35px;"><%=userFname%>'s Upcoming Events</div>
				<% //get that friend's events
				rs=st.executeQuery("SELECT * FROM eventList WHERE userID="+userID_result+" ORDER BY inputStart");//get the friends event
				if(rs.next())
				{
			%>
				<div id="eventTable">
				<table>
				<tr>
				<th>Date</th>
	   			<th>Time</th>
	   			<th style="width: 100%;">Summary</th>
	   			<tr/>
	   			<% 
	   				do{
	   					%>
	   					<tr style="cursor: pointer;" onclick="addFriendEvent('<%= rs.getString("summary")%>','<%=rs.getString("inputStart")%>','<%=rs.getString("inputEnd")%>','<%=userID_result%>','<%=access_token%>')"> 
								<td><%= rs.getString("startDate")%></td> 
								<td><%= rs.getString("startTime")%></td>
								<td><%= rs.getString("summary")%></td> 
						</tr>
				<%
					}while(rs.next()); %>
				</table>
				</div>
				
				<%}
				else{%>
					<div id="eventTable">
					<h1 style="color:red; font-size:20px; font-family:American Typewriter, sans-serif;">No Upcoming Events</h1>
					</div>
				<%}%>
				
				<div id="profile">
					<div id="ButtonContainer">
					<button class="followButton" onclick="unfollow('<%=userID%>','<%=userID_result%>')">Unfollow</button> 
					</div>
					<img src="<%=pictureUrl_result%>" style="width:128px;height:128px; left: 0%; margin-top:20%;border-radius: 50%;"><br />
					<%=username_result%> <br/>
				</div>
				
			<% }
			else//if has not followed yet
			{%>
				<div style="color:black;font-family:American Typewriter, sans-serif;text-decoration:none;font-size: 25px;padding-left:35px;"><%=userFname%>'s Upcoming Events</div>
				<div id="eventTable">
					<h1 style="color:red; font-size:20px; font-family:American Typewriter, sans-serif;">Follow <%=userFname%> to view Upcoming Events</h1>
				</div>
				<div id="profile">
					<div id="ButtonContainer">
					<button class="followButton" onclick="follow('<%=userID%>','<%=userID_result%>','<%=access_token%>')">Follow</button>
					</div> 
					<img src="<%=pictureUrl_result%>" style="width:128px;height:128px; left: 0%; margin-top:20%;border-radius: 50%;"><br />
					<%=username_result%> <br/>
				</div>
			<%}%>
			
		<%
		}catch(SQLException sqle)
		{
			System.out.println("sqle: "+sqle.getMessage());
		}
		catch(ClassNotFoundException snfe)
		{
			System.out.println("cnfe: "+snfe.getMessage());
		}
		finally
		{	
			try
			{
				if(rs!=null)
				{
					rs.close();
				}
				if(st!=null)
				{
					st.close();
				}
				if(conn!=null)
				{
					conn.close();
				}
			}
			catch(SQLException sqle)
			{
				System.out.println("sqle "+sqle.getMessage());
			}
		}
	%>
	
	<script>
		function addFriendEvent(summary,inputStart,inputEnd,friendID,access_token) {
			//jquery from logicbig.com
			  var form = $('<form action="' + "FriendEventServlet" + '" method="post">' +
		              '<input type="hidden" name="summary" value="' +
		               summary + '" />' +
		               '<input type="hidden" name="inputStart" value="' +
		               inputStart + '" />' +
		               '<input type="hidden" name="inputEnd" value="' +
		               inputEnd + '" />' +
		               '<input type="hidden" name="friendID" value="' +
		               friendID + '" />' +
		               '<input type="hidden" name="access_token" value="' +
		               access_token + '" />' +
		                                                    '</form>');
			  	$('body').append(form);
			  	form.submit();  
		}
	</script>

<div id="downbar"></div>
<script type="text/javascript"> window.onload = alertName; </script>
	
</body>
</html>