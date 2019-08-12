//Ruilin Liu	8011071387	ruilinli@usc.edu

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
import com.google.api.services.calendar.model.Events;
import com.google.common.base.Preconditions;

/**
 * Servlet implementation class LoginServlet
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    
    protected void service(HttpServletRequest request, HttpServletResponse response)
    		throws ServletException, IOException 
    {
    	try {
	    	String idToken = request.getParameter("id");
	    	String field=request.getParameter("field");
	    	String access_token=request.getParameter("access_token");
	    	//System.out.println(field);
	    	
	    	String nextPage;
	    	if(field.equals("Home"))
	    	{
	    		nextPage="/home.jsp";
	    	}
	    	else
	    	{
	    		nextPage="/profile.jsp";
	    	}
	    	//System.out.println(id);
	    	//response.setContentType("text/html");
	        GoogleIdToken.Payload payLoad = IdTokenVerifierAndParser.getPayload(idToken);
	        String name = (String) payLoad.get("name");
	        String pictureUrl = (String) payLoad.get("picture");
	        String email = payLoad.getEmail();
	        //System.out.println("User name: " + name);
	        //System.out.println("User email: " + email);
	        HttpSession session = request.getSession(true);
	        session.setAttribute("userName", name);
	        session.setAttribute("picture", pictureUrl);
	        session.setAttribute("idToken", idToken);
	        session.setAttribute("access_token",access_token);
	        session.setAttribute("email", email);
	        
	        if(field.equals("Profile"))//need to output events
	        {
	        	
	
		        
	        }
	        
	        request.getServletContext()
	        	.getRequestDispatcher(nextPage).forward(request, response);
	         
	    	/*String nextPage="/home.jsp";
	    	request.setAttribute("id", idToken);
	    	RequestDispatcher dispatch= request.getRequestDispatcher(nextPage);
	    	dispatch.forward(request, response);*/
    	}catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
class IdTokenVerifierAndParser {
    private static final String GOOGLE_CLIENT_ID = "231408607225-t5smqmc1ua87kchb94embbf3a892i6qd.apps.googleusercontent.com";

    public static GoogleIdToken.Payload getPayload (String tokenString) throws Exception {

        JacksonFactory jacksonFactory = new JacksonFactory();
        GoogleIdTokenVerifier googleIdTokenVerifier =
                            new GoogleIdTokenVerifier(new NetHttpTransport(), jacksonFactory);

        GoogleIdToken token = GoogleIdToken.parse(jacksonFactory, tokenString);

        if (googleIdTokenVerifier.verify(token)) {
            GoogleIdToken.Payload payload = token.getPayload();
            if (!GOOGLE_CLIENT_ID.equals(payload.getAudience())) {
                throw new IllegalArgumentException("Audience mismatch");
            } else if (!GOOGLE_CLIENT_ID.equals(payload.getAuthorizedParty())) {
                throw new IllegalArgumentException("Client ID mismatch");
            }
            return payload;
        } else {
            throw new IllegalArgumentException("id token cannot be verified");
        }
    }
}
