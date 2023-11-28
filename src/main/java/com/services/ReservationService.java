package com.services;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;


public class ReservationService {
    // retrieves past reservations for a given username
    public List<Reservation> getPastReservations(String username) throws SQLException {
        DatabaseConnection databaseConnection = new DatabaseConnection();
        String query = "SELECT * FROM vehicle_service WHERE username=? AND date <= CURRENT_DATE;";

        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        List<Reservation> pastReservations = new ArrayList<>();

        try {
            connection = databaseConnection.getConnection();
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, username);
            resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                Reservation reservation = new Reservation(
                    resultSet.getInt("booking_id"),
                    resultSet.getDate("date").toLocalDate(),  
                    resultSet.getTime("time").toLocalTime(), 
                    resultSet.getString("location"),
                    resultSet.getInt("mileage"),
                    resultSet.getString("vehicle_no"),
                    resultSet.getString("message")
                );
                pastReservations.add(reservation);
            }

            return pastReservations;
        } catch (Exception e) {
            throw e;
        } finally {
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public List<Reservation> getFutureReservations(String username) throws SQLException {
        DatabaseConnection databaseConnection = new DatabaseConnection();
        String query = "SELECT * FROM vehicle_service WHERE username=? AND date >= CURRENT_DATE;";

        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        List<Reservation> futureReservations = new ArrayList<>();

        try {
            connection = databaseConnection.getConnection();
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, username);
            resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                Reservation reservation = new Reservation(
                    resultSet.getInt("booking_id"),
                    resultSet.getDate("date").toLocalDate(),  
                    resultSet.getTime("time").toLocalTime(), 
                    resultSet.getString("location"),
                    resultSet.getInt("mileage"),
                    resultSet.getString("vehicle_no"),
                    resultSet.getString("message")
                );
                futureReservations.add(reservation);
            }

            return futureReservations;
        } catch (Exception e) {
            throw e;
        } finally {
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    public boolean cancelReservation(int bookingId) throws SQLException {
        DatabaseConnection databaseConnection = new DatabaseConnection();
        String query = "DELETE FROM vehicle_service WHERE booking_id=?";

        Connection connection = null;
        PreparedStatement preparedStatement = null;

        try {
            connection = databaseConnection.getConnection();
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setInt(1, bookingId);

            int affectedRows = preparedStatement.executeUpdate();
            return affectedRows > 0;
        } catch (Exception e) {
            throw e;
        } finally {
            try {
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
