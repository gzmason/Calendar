<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
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
 		<meta name="google-signin-scope" content="profile email">
    	<meta name="google-signin-client_id" content="231408607225-t5smqmc1ua87kchb94embbf3a892i6qd.apps.googleusercontent.com">
		<meta charset="ISO-8859-1">
		<script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
		<link rel="stylesheet" type="text/css" href="sign-in.css" />
		<script async defer src="https://apis.google.com/js/api.js"></script>
		<script src="signinMethods.js"></script>
		<title>Home</title>
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
          		<li class="menuitem" ><a onclick="toProfile2('<%=idToken%>','<%=access_token%>')" style="color:white;font-family:American Typewriter, sans-serif;text-decoration:none;">Profile</a></li>
          		<li class="menuitem" ><a onclick="toHome2('<%=idToken%>','<%=access_token%>')" style="color:white;font-family:American Typewriter, sans-serif;text-decoration:none;">Home</a></li>
        	</ul>
      	</div>
      	<br/><br/><br/>
      	<div id="homeBody">
      	<div style="color:black;font-family:American Typewriter, sans-serif;text-decoration:none;font-size: 25px;padding-left:35px;"> Home </div>
      	
      	<div id="home">
			<img src="<%=pictureUrl%>" style="width:128px;height:128px; left: 0%; margin-top:2%;border-radius: 50%;"><br />
			<%=name %> <br/>
			
			<div id="formarea">
			<form name="myform" method="POST" action="EventServlet" >
			<input placeholder="Event Title" type="text" name="summary" /><br/>
			<input placeholder="Start Date" class="textbox-n" type="text" onfocus="(this.type='date')"  onblur="(this.type='text')" name="startDate"> 
			<input placeholder="Start Time" class="textbox-n" type="text" onfocus="(this.type='time')" onblur="(this.type='text')" name="startTime">      
			&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;<input type="submit" value="Add Event"> <br/>
			<input placeholder="End Date" class="textbox-n" type="text" onfocus="(this.type='date')"  onblur="(this.type='text')" name="endDate"> 
			<input placeholder="End Time" class="textbox-n" type="text" onfocus="(this.type='time')"  onblur="(this.type='text')" name="endTime"> 
			<input type="hidden" name="access_token" value="<%=access_token %>">
			</form>
			</div>
			<br/>
			
			<div id="followList">
			Following
			<br/>
			<%
				Connection conn=null;
				Statement st=null;
				ResultSet rs=null;
				PreparedStatement ps=null;
				
				try
				{
					Class.forName("com.mysql.cj.jdbc.Driver");
					conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/assignment3?user=root&password=root&useSSL=false&useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC");
					st = conn.createStatement();
					rs=st.executeQuery("SELECT relationList.friendID,userList.username,userList.pictureUrl FROM relationList INNER JOIN userList ON relationList.friendID=userList.userID WHERE relationList.userID="+userID);
					int count=0;%>
					<table style="border:none;border-collapse: collapse;">
					<tr>
					<%while(rs.next())
					{
						int userID_result=rs.getInt("relationList.friendID");
						String username_result=rs.getString("userList.username");
						String pictureUrl_result=rs.getString("userList.pictureUrl");
					%>
						<td style="vertical-align:top;border:none;">
						<div id="followResult">
						<figure>
							<a style="text-decoration: none;color:black;" href="others.jsp?userID_result=<%=userID_result%>">		
							<img src="<%=pictureUrl_result%>" style="border-radius: 50%;">
							<figcaption><%=username_result%></figcaption>
							</a>
						</figure>
						</div>
						</td>
					<%
					count++;
					if(count%4==0&&count!=0)
					{%>
						</tr><tr>	
					<% }
					}
					%>
				<%while(count%4!=0)
				{%>
					<td style="vertical-align:top;border:none;"></td>
				<%count++;}%>
				</tr>
				</table>			
				<%}catch(SQLException sqle)
				{
					System.out.println("sqle: "+sqle.getMessage());
				}
				catch(ClassNotFoundException snfe)
				{
					System.out.println("cnfe: "+snfe.getMessage());
				}
			%>
			</div>
			
		</div>
		</div>
		
		<div id="downbar"></div>
		<script type="text/javascript"> window.onload = alertName; </script>
	</body>
</html>