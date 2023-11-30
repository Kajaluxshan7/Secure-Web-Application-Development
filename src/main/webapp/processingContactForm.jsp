<%@ page import="java.util.Properties" %>
<%@ page import="javax.mail.*" %>
<%@ page import="javax.mail.internet.*" %>
<%@ page import="java.util.regex.Pattern" %>

<%
if ("POST".equalsIgnoreCase(request.getMethod())) {
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String message = request.getParameter("message");

    // set the recipient email address
    String to = "partshop453@gmail.com";

    // set the subject of the email
    String subject = "Contact Form Submission";

    // validate email format
    String emailRegex = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
    if (!Pattern.matches(emailRegex, email)) {
        response.sendRedirect("contact.jsp?status=error");
        return;
    }

    // set up the properties for the mail server
    Properties properties = new Properties();
    properties.put("mail.smtp.host", "smtp.mailgun.org");
    properties.put("mail.smtp.port", "587"); //
    properties.put("mail.smtp.auth", "true");

    // create a session with authentication
    Session emailSession = Session.getInstance(properties, new Authenticator() {
        protected PasswordAuthentication getPasswordAuthentication() {
            return new PasswordAuthentication("", ""); 
        }
    });

    try {
        // create a default MimeMessage object
        MimeMessage mimeMessage = new MimeMessage(emailSession);

        // set the sender email address
        mimeMessage.setFrom(new InternetAddress(email));

        // set the recipient email address
        mimeMessage.addRecipient(Message.RecipientType.TO, new InternetAddress(to));

        // set the subject of the email
        mimeMessage.setSubject(subject);

        // set the content of the email
        mimeMessage.setText("Name: " + name + "\nEmail: " + email + "\n\nMessage:\n" + message);

        // send the email
        Transport.send(mimeMessage);

        // redirect back to the contact form with a success message
        response.sendRedirect("contact.jsp?status=success");
    } catch (MessagingException e) {
        // redirect back to the contact form with an error message
        response.sendRedirect("contact.jsp?status=error");
        e.printStackTrace();
    }
} else {
    // redirect back to the contact form if the request method is not POST
    response.sendRedirect("contact.html");
}
%>