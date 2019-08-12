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
      <div id="searchBody">
	<%
		Connection conn=null;
		Statement st=null;
		ResultSet rs=null;
		PreparedStatement ps=null;
		String result="";
		
		try
		{
			result=request.getParameter("search");
			result=result.toLowerCase();
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/assignment3?user=root&password=root&useSSL=false&useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC");
			
			if(result==null || result.trim().length()==0)
			{
				result="SELECT userID,username,pictureUrl FROM userList";
				ps=conn.prepareStatement(result);
			}
			else 
			{
				String[] splited = result.split("\\s+");
				result="SELECT userID,username,pictureUrl FROM userList WHERE username LIKE ";
				for(int i=0;i<splited.length;i++)
				{
					if(splited[i].equals(""))
					{
						continue;
					}
					result+="?";
					if(i+1!=splited.length)//if has more, add "OR"
					{
						result+=" OR username LIKE ";
					}
				}
				ps=conn.prepareStatement(result);
				int j=1;
				for (int i=0;i<splited.length;i++)
				{
					if(splited[i].equals(""))
					{
						continue;
					}
					else
					{
						ps.setString(j, "%" + splited[i] + "%");
						j++;
					}
				}
			}
			rs=ps.executeQuery();
			boolean noMatch=true;
			int count=0;%>
			<table style="border:none;border-collapse: collapse;width:98%;">
			<tr>
			<%while(rs.next())
			{
				int userID_result=rs.getInt("userID");
				if(userID_result==userID)//if is the current user
				{
					continue;
				}
				noMatch=false;
				String username_result=rs.getString("username");
				String pictureUrl_result=rs.getString("pictureUrl");
			%>
				<td style="vertical-align:top;border:none;">
				<div id="searchResult">
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
				if(count%3==0&&count!=0)
				{%>
					</tr><tr>	
				<% }
			}
			%>
			
			<% if(noMatch)
			{%>
				No Matches Found
			<%}%>
			<%while(count%3!=0)
				{%>
					<td style="vertical-align:top;border:none;"></td>
				<%count++;}%>
		</tr>
		</table>
	<%	}
		catch(SQLException sqle)
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
	</div>
</body>
<div id="downbar"></div>
</html>