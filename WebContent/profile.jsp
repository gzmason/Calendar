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
 		<meta name="google-signin-scope" content="profile email">
    	<meta name="google-signin-client_id" content="231408607225-t5smqmc1ua87kchb94embbf3a892i6qd.apps.googleusercontent.com">
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
		<meta charset="ISO-8859-1">
		<link rel="stylesheet" type="text/css" href="sign-in.css" />
		<title>Profile</title>
		<script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
		<script async defer src="https://apis.google.com/js/api.js"></script>
		<script src="signinMethods.js"></script>
      
	</head>
	<body>
		
		<%
			String idToken=(String)session.getAttribute("idToken");
			String access_token=(String)session.getAttribute("access_token");
			String name = (String)session.getAttribute("userName");
			String pictureUrl = (String)session.getAttribute("picture");
			String email=(String)session.getAttribute("email");
			
			
			//add to mysql database
			Connection conn=null;
			Statement st=null;
			ResultSet rs=null;
			PreparedStatement ps=null;
			try
			{
				Class.forName("com.mysql.cj.jdbc.Driver");
				conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/assignment3?allowPublicKeyRetrieval=true&useSSL=false&user=root&password=root&useSSL=false&useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC");
				st = conn.createStatement();
				//add name and pictureUrl to the userList form in database
				//st.executeUpdate("INSERT INTO userList (username,pictureUrl) "+
				//		"VALUES ('"+name+"','"+pictureUrl+"');"); 
				
				/*st.execute("INSERT INTO userList (username,pictureUrl,idToken) "+
						"SELECT * FROM (SELECT 'Ruilin Liu','abcURL','abcidToken') AS tmp " +
						"WHERE NOT EXISTS ("+ "SELECT idToken FROM userList WHERE idToken ='abcidToken') LIMIT 1;"); */
				st.execute("INSERT INTO userList (username,pictureUrl,email) "+
						"VALUES ('"+name+"','"+pictureUrl+"','"+email+"') ON DUPLICATE KEY UPDATE username=\""+name+"\",pictureUrl=\""+pictureUrl+"\"");
						
				
			}catch(SQLException sqle)
			{
				System.out.println("sqle: "+sqle.getMessage());
			}
			catch(ClassNotFoundException snfe)
			{
				System.out.println("cnfe: "+snfe.getMessage());
			}
			
			//get the id of this current user
			rs=st.executeQuery("SELECT s.userID FROM userList s WHERE email='"+email+"';");
			rs.next();
			int userID=rs.getInt("userID");
			session.setAttribute("userID", userID);
			
			
			GoogleCredential credential = new GoogleCredential().setAccessToken(access_token);
	        Calendar calendar = new Calendar.Builder(new NetHttpTransport(),
	                                     JacksonFactory.getDefaultInstance(),
	                                     credential)
	            .setApplicationName("Calendar")
	            .build();
	        session.setAttribute("calendar", calendar);
	        //copied from www.programcreek.com
	        List<String> eventStrings = new ArrayList<String>();
	        DateTime now = new DateTime(System.currentTimeMillis());
	        Events events = calendar.events().list("primary")
	                .setMaxResults(10)
	                .setTimeMin(now)
	                .setOrderBy("startTime")
	                .setSingleEvents(true)
	                .execute();
	        List<Event> items = events.getItems();
	        
	        
		%>
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
      	<br/><br/><br/><br/>
      	<div style="color:black;font-family:American Typewriter, sans-serif;text-decoration:none;font-size: 25px;padding-left:35px;"> Upcoming Events </div>
      	
      	<div id="profile">
			<img src="<%=pictureUrl%>" style="width:128px;height:128px; left: 0%; margin-top:2%;border-radius: 50%;"><br />
			<%=name %> <br/>
		</div>
		
		<div id="eventTable">
		
		<%
			if (items.size()==0)
			{%>
				No Event
		<% 	}
			else
			{%>
			
			<table>
			<tr>
			<th>Date</th>
   			<th>Time</th>
   			<th style="width: 100%;">Summary</th>
   			<tr/>
				
			
			<% 	for (Event event : items) {
		            DateTime start = event.getStart().getDateTime();
		            if (start == null) {
		                // All-day events don't have start times, so just use
		                // the start date.
		                start = event.getStart().getDate();
		            }
		            DateTime end=event.getEnd().getDateTime();
		            if(end==null){
		            	end=event.getEnd().getDate();
		            }
		            
		            DateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSXXX");
		            Date today=sdf.parse(start.toString());
		            SimpleDateFormat sdfD = new SimpleDateFormat("MMMMMMMMMMM dd, yyyy");
		            String startDate = sdfD.format(today);
		            SimpleDateFormat sdft = new SimpleDateFormat("h:mm a");
		            String startTime = sdft.format(today);
		        	String summary=event.getSummary();
		        	String eventID=event.getId();
		        	
		        	today=sdf.parse(end.toString());
		        	sdfD = new SimpleDateFormat("MMMMMMMMMMM dd, yyyy");
		            String endDate = sdfD.format(today);
		            sdft = new SimpleDateFormat("h:mm a");
		            String endTime = sdft.format(today);
		            
		            try
					{
						//add events to the userList form in database
						
						st.execute("INSERT IGNORE INTO eventList (userID,summary,startDate,startTime,endDate,endTime,inputStart,inputEnd,eventID) "+
								"VALUES ('"+userID+"','"+summary+"','"+startDate+"','"+startTime+"','"+endDate+"','"+endTime+"','"+start.toString()+"','"+end.toString()+"','"+eventID+"') ");
						
						/*st.execute("INSERT INTO eventList (userID,summary,startDate,startTime,endDate,endTime,eventID) "+
								"SELECT * FROM (SELECT '"+userID+"','"+summary+"','"+startDate+"','"+startTime+"','"+endDate+"','"+endTime+"','"+eventID+"') AS tmp "+
								"WHERE NOT EXISTS ("+ "SELECT eventID FROM eventList WHERE eventID ='"+eventID+"') LIMIT 1;");*/
								
						
					}catch(SQLException sqle)
					{
						System.out.println("sqle: "+sqle.getMessage());
					}
					/*catch(ClassNotFoundException snfe)
					{
						System.out.println("cnfe: "+snfe.getMessage());
					}*/
		            
		     %>
	    
	     <tr>
		    <td><%=startDate %></td>
		    <td><%=startTime %></td>
		    <td><%=summary %></td>
		 </tr>   	
	        	
	    
	    <% }%> 
	    </table>  
	    <%}%>
	    
	    <%
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
	    %>
	    
		</div>
		
		<div id="downbar"></div>
		
	</body>
</html>