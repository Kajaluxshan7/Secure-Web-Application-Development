package com.services;
import java.time.LocalDateTime;
import java.time.LocalDate;
import java.time.LocalTime;

public class Reservation {
    private int bookingId;
    private LocalDate date;
    private LocalTime time;
    private String location;
    private int mileage;
    private String vehicleNo;
    private String message;
    

    public Reservation(int bookingId, LocalDate date, LocalTime time, String location, int mileage, String vehicleNo, String message) {
        this.bookingId = bookingId;
        this.date = date;
        this.time = time;
        this.location = location;
        this.mileage = mileage;
        this.vehicleNo = vehicleNo;
        this.message = message;
    }
    public LocalDateTime getDateTime() {
        return LocalDateTime.of(date, time);
    }

    public int getBookingId() {
        return bookingId;
    }

    public LocalDate getDate() {
        return date;
    }

    public LocalTime getTime() {
        return time;
    }

    public String getLocation() {
        return location;
    }

    public int getMileage() {
        return mileage;
    }

    public String getVehicleNo() {
        return vehicleNo;
    }

    public String getMessage() {
        return message;
    }
}
