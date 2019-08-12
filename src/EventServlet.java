//Ruilin Liu	8011071387	ruilinli@usc.edu

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.io.IOException;
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
import com.google.api.services.calendar.model.EventDateTime;
import com.google.api.services.calendar.model.Events;
import com.google.common.base.Preconditions;

/**
 * Servlet implementation class EventServlet
 */
@WebServlet("/EventServlet")
public class EventServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public EventServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#service(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String summary = request.getParameter("summary");
    	String startDate = request.getParameter("startDate");
    	String startTime=request.getParameter("startTime");
    	String endDate=request.getParameter("endDate");
    	String endTime=request.getParameter("endTime");
    	String access_token=request.getParameter("access_token");
    	RequestDispatcher rd = request.getRequestDispatcher("/home.jsp");
    	HttpSession session = request.getSession(true);
    	int userID=(int)session.getAttribute("userID");
    	
    	if(summary.equals("")||startDate.equals("")||startTime.equals("")||endDate.equals("")||endTime.equals(""))
    	{
    		request.setAttribute("success", "Not Added: Please Complete the Form");
    		rd.forward(request, response);  
    	}
    	else
    	{
	    	Event event = new Event()
	    		    .setSummary(summary);
	    	
	    	DateTime startDateTime = new DateTime(startDate+"T"+startTime+":00-07:00");
	    	EventDateTime start = new EventDateTime()
	    	    .setDateTime(startDateTime)
	    	    .setTimeZone("America/Los_Angeles");
	    	
	    	DateTime endDateTime = new DateTime(endDate+"T"+endTime+":00-07:00");
	    	EventDateTime end = new EventDateTime()
	    	    .setDateTime(endDateTime)
	    	    .setTimeZone("America/Los_Angeles");
	    	
	    	boolean correctRange=true;
	    	DateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSXXX");
	        try {
				Date startCompare=sdf.parse(startDateTime.toString());
				Date endCompare=sdf.parse(endDateTime.toString());
				if(startCompare.compareTo(endCompare)>0)//if start is after end
				{
					correctRange=false;
				}
				else
				{
					correctRange=true;
				}
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	       
	        if(correctRange)  
	    	{
		        event.setStart(start);
		    	event.setEnd(end);
		    	
		    	String calendarId = "primary";
		    	
		    	GoogleCredential credential = new GoogleCredential().setAccessToken(access_token);
		        Calendar calendar = new Calendar.Builder(new NetHttpTransport(),
		                                     JacksonFactory.getDefaultInstance(),
		                                     credential)
		            .setApplicationName("Calendar")
		            .build();
		    	
		    	event = calendar.events().insert(calendarId, event).execute();
		    	String eventID=event.getId();
		    	
		    	//add that event to database after parsing it to the same format
		    	DateTime start1 = event.getStart().getDateTime();
	            if (start1 == null) {
	                // All-day events don't have start times, so just use
	                // the start date.
	                start1 = event.getStart().getDate();
	            }
	            DateTime end1=event.getEnd().getDateTime();
	            if(end1==null){
	            	end1=event.getEnd().getDate();
	            }
	            
	            DateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSXXX");
	            Date today=null;
				try {
					today = sdf1.parse(start1.toString());
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
	            SimpleDateFormat sdfD = new SimpleDateFormat("MMMMMMMMMMM dd, yyyy");
	            String startDate1 = sdfD.format(today);
	            SimpleDateFormat sdft = new SimpleDateFormat("h:mm a");
	            String startTime1 = sdft.format(today);
	        	String summary1=event.getSummary();
	        	
	        	
				try {
					today=sdf1.parse(end1.toString());
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
	        	sdfD = new SimpleDateFormat("MMMMMMMMMMM dd, yyyy");
	            String endDate1 = sdfD.format(today);
	            sdft = new SimpleDateFormat("h:mm a");
	            String endTime1 = sdft.format(today);
		    	
		    	Connection conn=null;
				Statement st=null;
				ResultSet rs=null;
				PreparedStatement ps=null;	
		    	try 
		    	{
			    	Class.forName("com.mysql.cj.jdbc.Driver");
					conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/assignment3?user=root&password=root&useSSL=false&useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC");
					st=conn.createStatement();
					st.execute("INSERT IGNORE INTO eventList (userID,summary,startDate,startTime,endDate,endTime,inputStart,inputEnd,eventID) "+
							"VALUES ('"+userID+"','"+summary+"','"+startDate1+"','"+startTime1+"','"+endDate1+"','"+endTime1+"','"+start1.toString()+"','"+end1.toString()+"','"+eventID+"') ");
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
		    	
		    	
		    	request.setAttribute("success", "Event Added");
	    	}
	        else
	        {
	        	request.setAttribute("success", "Not Added: Start Should be Before End");
	        }
	    	rd.forward(request, response);  
    	}
	}

}
