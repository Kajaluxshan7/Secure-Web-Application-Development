package com.services;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.Serializable;


@WebServlet("/CancelReservationServlet")
public class CancelReservationServlet extends HttpServlet implements Serializable {
    private static final long serialVersionUID = 1L;
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String bookingId = request.getParameter("bookingId");

            // JDBC Connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/isec_assessment2", "root", "Kajan2000#");

            // Update the reservation status in the database
            String deleteQuery = "DELETE FROM vehicle_service WHERE booking_id = ?";
            try (PreparedStatement preparedStatement = connection.prepareStatement(deleteQuery)) {
                preparedStatement.setString(1, bookingId);
                preparedStatement.executeUpdate();
            }

            // close the database connection
            connection.close();

            // send a success response to the client
            response.getWriter().write("Reservation canceled successfully");
        } catch (Exception e) {
            // send an error response to the client
            response.getWriter().write("Error canceling reservation");
            e.printStackTrace();
        }
    }
}
