<%@ page import="java.util.Date" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="com.services.ReservationService" %>
<%@ page import="com.services.Reservation" %>
<%@ page import="com.services.AuthUtil" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ include file="header.jsp" %>
<%@ page import="com.services.DatabaseConnection" %>

<%
try {
    if (!AuthUtil.isAuthenticated(request)) {
        response.sendRedirect("index.jsp");
    } else {
        String username = (String) request.getSession().getAttribute("username");

        // instance of the ReservationService
        ReservationService reservationService = new ReservationService();

        // obtain past result set
        List<Reservation> pastReservations = reservationService.getPastReservations(username);

        // obtain future result set
        List<Reservation> futureReservations = reservationService.getFutureReservations(username);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/CSS/reservation.css">
    <title>Reservations</title>
</head>
<body>
    <script type="text/javascript" src="Javascript/reservation.js"></script>
    <section id="history">
        <!-- Future Reservations -->
        <div class="future" id="future">
            <h2 id="futureTableName">Future Reservations</h2>
            <br>
            <%
            if (futureReservations != null && !futureReservations.isEmpty()) {
            %>
            <table>
                <thead>
                    <tr>
                        <th>Booking ID</th>
                        <th>Date</th>
                        <th>Time</th>
                        <th>Location</th>
                        <th>Mileage</th>
                        <th>Vehicle Number</th>
                        <th>Message</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    for (Reservation reservation : futureReservations) {
                        LocalDateTime dateTime = reservation.getDateTime();
                        if (dateTime.isBefore(LocalDateTime.now())) {
                            continue;
                        }
                    %>
                    <tr>
                        <td><%= reservation.getBookingId() %></td>
                        <td><%= dateTime.format(DateTimeFormatter.ofPattern("dd-MM-yyyy")) %></td>
                        <td><%= dateTime.format(DateTimeFormatter.ofPattern("HH:mm")) %></td>
                        <td><%= reservation.getLocation() %></td>
                        <td><%= reservation.getMileage() %></td>
                        <td><%= reservation.getVehicleNo() %></td>
                        <td><%= reservation.getMessage() %></td>
                        <td><button onclick="showConfirmationPopup('<%= reservation.getBookingId() %>');" class="cancel">Cancel</button></td>
                    </tr>
                    <%
                    }
                    %>
                </tbody>
            </table>
            <%
            } else {
            %>
            <p>No upcoming reservations.</p>
            <%
            }
            %>
        </div>

        <!-- Past Reservations -->
        <div class="past" id="past">
            <h2 id="pastTableName">Past Reservations</h2>
            <br>
            <table>
                <thead>
                    <tr>
                        <th>Booking ID</th>
                        <th>Date</th>
                        <th>Time</th>
                        <th>Location</th>
                        <th>Mileage</th>
                        <th>Vehicle Number</th>
                        <th>Message</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    Date currentDate = new Date();
                    if (pastReservations != null) {
                        for (Reservation reservation : pastReservations) {
                            LocalDateTime dateTime = reservation.getDateTime();
                            if (dateTime.isAfter(LocalDateTime.now())) {
                                continue;
                            }
                    %>
                    <tr>
                        <td><%= reservation.getBookingId() %></td>
                        <td><%= dateTime.format(DateTimeFormatter.ofPattern("dd-MM-yyyy")) %></td>
                        <td><%= dateTime.format(DateTimeFormatter.ofPattern("HH:mm")) %></td>
                        <td><%= reservation.getLocation() %></td>
                        <td><%= reservation.getMileage() %></td>
                        <td><%= reservation.getVehicleNo() %></td>
                        <td><%= reservation.getMessage() %></td>
                    </tr>
                    <%
                    }
                    }
                    %>
                </tbody>
            </table>
        </div>
        <!-- Confirmation Popup HTML -->
        <div id="confirmationPopup" class="confirmation-popup">
            <p>Cancel this reservation?</p>
            <button class="yes" onclick="cancelReservation();">Yes</button>
            <button class="no" onclick="hideConfirmationPopup();">No</button>
            <!-- Hidden input to store the bookingId -->
            <input type="hidden" id="bookingIdToCancel" value="">
        </div>
    </section>
</body>
</html>
<%
    }
} catch (SQLException e) {
    out.println("An error occurred while fetching data from the database.");
    e.printStackTrace(); 
}
%>