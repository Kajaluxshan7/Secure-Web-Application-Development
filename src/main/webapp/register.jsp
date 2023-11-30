<%@ page import="com.services.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="com.services.DatabaseConnection" %>
<%@ include file="header.jsp" %>

<%
if (!AuthUtil.isAuthenticated(request)) {
    // if the user is not authenticated
    response.sendRedirect("index.jsp");
    return; // Add return to stop further processing
}

String username = (String) request.getSession().getAttribute("username");

// check if the form is submitted
if (request.getParameter("submit") != null) {
    String registrationMessage = "failure"; 

    // get form data
    String dateString = request.getParameter("date");
    String timeString = request.getParameter("time"); 
    String location = request.getParameter("location");
    String mileageStr = request.getParameter("current_mileage");
    String vehicleNo = request.getParameter("vehicle_registration");
    String message = request.getParameter("message");

    try {
        // convert String date to java.sql.Date
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        java.util.Date parsedDate = dateFormat.parse(dateString);
        java.sql.Date sqlDate = new java.sql.Date(parsedDate.getTime());

        // convert String mileage to integer
        int mileage = Integer.parseInt(mileageStr);

        // convert String time to java.sql.Time
        SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
        java.util.Date parsedTime = timeFormat.parse(timeString);
        java.sql.Time sqlTime = new java.sql.Time(parsedTime.getTime());

        // perform database insertion
        DatabaseConnection databaseConnection = new DatabaseConnection();
        try (Connection connection = databaseConnection.getConnection()) {
            PreparedStatement preparedStatement = connection.prepareStatement("INSERT INTO vehicle_service (date, time, location, vehicle_no, mileage, message, username) VALUES (?, ?, ?, ?, ?, ?, ?)");

            // set parameters for the prepared statement
            preparedStatement.setDate(1, sqlDate);
            preparedStatement.setTime(2, sqlTime);
            preparedStatement.setString(3, location);
            preparedStatement.setString(4, vehicleNo);
            preparedStatement.setInt(5, mileage);
            preparedStatement.setString(6, message);
            preparedStatement.setString(7, username);

            int rowsAffected = preparedStatement.executeUpdate();

            if (rowsAffected > 0) {
                // registration successful
                registrationMessage = "success";
                request.getSession().setAttribute("registrationMessage", registrationMessage);
                response.sendRedirect("register.jsp");
                return; // Add return to stop further processing
            }
        } // connection will be automatically closed here
    } catch (Exception e) {
        e.printStackTrace();
        registrationMessage = "exception";
        request.getSession().setAttribute("registrationMessage", registrationMessage);
        response.sendRedirect("register.jsp");
        return; 
    }

    // Redirect to display the appropriate message
    response.sendRedirect("register.jsp?msg=" + registrationMessage);
}
%>

<!DOCTYPE html>
<html>

<head>
    <meta charset="ISO-8859-1">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script type="text/javascript" src="/Javascript/userInformation.js"></script>
    <script type="text/javascript" src="Javascripts/register.js"></script>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/CSS/register.css">
    <title>Registration</title>
</head>

<body>
    <section id="service">
        <h2>Vehicle Service Registration</h2>

        <% 
        String registrationMessage = (String) request.getSession().getAttribute("registrationMessage");
        request.getSession().removeAttribute("registrationMessage");
        
        if (registrationMessage != null) { %>
            <% if (registrationMessage.equals("success")) { %>
                <div class="success-message">Registration successful!</div>
            <% } else if (registrationMessage.equals("failure")) { %>
                <div class="error-message">Registration failed. Please try again.</div>
            <% } else if (registrationMessage.equals("exception")) { %>
                <div class="error-message">An error occurred during registration. Please try again later.</div>
            <% } %>
        <% } %>

        <form id="reservation-form" method="post" action="">
            <input type="hidden" id="username" name="username" value="<%= username %>">

            <label for="date">Date</label>
            <input type="date" name="date" id="date" placeholder="Enter date" class="form-control" required min="<%= java.time.LocalDate.now() %>">
            <span id="date-error" class="error-message"></span>

            <label for="time">Time:</label>
            <input type="time" id="time" name="time" required>

            <label for="location">Location:</label>
            <select id="location" name="location">
                <option value="" selected disabled>Select one...</option>
                <option value="Colombo">Colombo</option>
                <option value="Gampaga">Gampaga</option>
                <option value="Kaluthara">Kaluthara</option>
                <option value="Galle">Galle</option>
                <option value="Matara">Matara</option>
                <option value="Hambanthota">Hambanthota</option>
                <option value="Kandy">Kandy</option>
                <option value="Matale">Matale</option>
                <option value="Nuwara Eliya">Nuwara Eliya</option>
                <option value="Kegalle">Kegalle</option>
                <option value="Ratnapura">Ratnapura</option>
                <option value="Anuradhapura">Anuradhapura</option>
                <option value="Polonnaruwa">Polonnaruwa</option>
                <option value="Puttalam">Puttalam</option>
                <option value="Kurunegala">Kurunegala</option>
                <option value="Badulla">Badulla</option>
                <option value="Monaragala">Monaragala</option>
                <option value="Trincomalee">Trincomalee</option>
                <option value="Batticaloa">Batticaloa</option>
                <option value="Ampara">Ampara</option>
                <option value="Jaffna">Jaffna</option>
                <option value="Kilinochchi">Kilinochchi</option>
                <option value="Mannar">Mannar</option>
                <option value="Mullaitivu">Mullaitivu</option>
                <option value="Vavuniya">Vavuniya</option>
            </select>

            <label for="vehicle_registration">Vehicle Registration Number (Format: AB-1234):</label>
            <input type="text" id="vehicle_registration" name="vehicle_registration" pattern="[A-Za-z]{2}-\d{4}" title="Please enter a valid vehicle registration number (e.g., AB-1234)" required>

            <label for="current_mileage">Current Mileage:</label>
            <input type="number" id="current_mileage" name="current_mileage" required min="0">

            <label for="message">Message:</label>
            <textarea id="message" name="message"></textarea>

            <button type="submit" name="submit">Submit</button>
        </form>
    </section>
</body>

</html>