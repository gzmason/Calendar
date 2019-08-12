//Ruilin Liu	8011071387	ruilinli@usc.edu

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.api.client.googleapis.auth.oauth2.GoogleCredential;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.google.api.client.util.DateTime;
import com.google.api.services.calendar.Calendar;
import com.google.api.services.calendar.Calendar.Builder;
import com.google.api.services.calendar.model.Event;
import com.google.api.services.calendar.model.Events;
import com.google.common.base.Preconditions;

/**
 * Servlet implementation class FollowServlet
 */
@WebServlet("/FollowServlet")
public class FollowServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public FollowServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#service(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			Connection conn=null;
			Statement st=null;
			ResultSet rs=null;
			PreparedStatement ps=null;	
			String field=request.getParameter("field");
	    	String userID=request.getParameter("userID");
	    	String friendID=request.getParameter("friendID");
	    	String access_token=request.getParameter("userAccessToken");
	    	Class.forName("com.mysql.cj.jdbc.Driver");
			conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/assignment3?user=root&password=root&useSSL=false&useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC");
			st=conn.createStatement();
			//get the friend's last name
			rs=st.executeQuery("SELECT * FROM userList WHERE userID="+friendID);
			rs.next();
			String username_result=rs.getString("username");
			String nameArray[]=username_result.split(" ");
			String userFname=nameArray[0];
			rs.close();
			
	    	if(field.equals("Unfollow"))
	    	{
				
	    		st.executeUpdate("DELETE FROM relationList WHERE userID="+userID+" AND friendID="+friendID);
				response.getWriter().println("<h1 style=\"color:red; font-size:20px; font-family:American Typewriter, sans-serif;\">Follow "+userFname+" to view Upcoming Events</h1>");
	    	}
	    	else if(field.equals("Follow"))
	    	{
				st.executeUpdate("INSERT IGNORE INTO relationList (userID,friendID) "+
						"VALUES ('"+userID+"','"+friendID+"') ");
				rs=st.executeQuery("SELECT * FROM eventList WHERE userID="+friendID+" ORDER BY inputStart");//get the friends event
				PrintWriter writer=response.getWriter();
				if(rs.next())//go over the friend's events
				{
					writer.println("<table><tr>" + 
							"			<th>Date</th>" + 
							"   		<th>Time</th>" + 
							"   		<th style=\"width: 100%;\">Summary</th>" + 
							"   		<tr/>");
					do {
						writer.println("<tr onclick=\"addFriendEvent(" +rs.getString("summary")+ ","+rs.getString("inputStart")+ ","+rs.getString("inputEnd")+ ","+access_token+")\">"+
								"		    <td>"+rs.getString("startDate")+"</td>" + 
								"		    <td>"+rs.getString("startTime")+"</td>" + 
								"		    <td>"+rs.getString("summary")+"</td>" + 
								"		 </tr>   	");
					}while(rs.next());
					writer.println("</table>");
				}
				else
				{
					writer.println("<h1 style=\"color:red; font-size:20px; font-family:American Typewriter, sans-serif;\">No Upcoming Events</h1>");
				}
	    	}
	    	conn.close();
	    	st.close();
	    	rs.close();
    	}catch (Exception e) {
            throw new RuntimeException(e);
        }
		
		
	}

}
