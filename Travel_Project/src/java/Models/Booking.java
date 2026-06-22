package Models;

import java.math.BigDecimal;
import java.sql.Date;

public class Booking {
    private int bookingID;
    private int customerID;
    private int tourID;
    private Date bookingDate;
    private int numberOfPeople;
    private BigDecimal totalAmount;
    private String status;

    public Booking() {
    }

    public Booking(int bookingID, int customerID, int tourID, Date bookingDate,
                   int numberOfPeople, BigDecimal totalAmount, String status) {
        this.bookingID = bookingID;
        this.customerID = customerID;
        this.tourID = tourID;
        this.bookingDate = bookingDate;
        this.numberOfPeople = numberOfPeople;
        this.totalAmount = totalAmount;
        this.status = status;
    }

    public int getBookingID() {
        return bookingID;
    }

    public void setBookingID(int bookingID) {
        this.bookingID = bookingID;
    }

    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public int getTourID() {
        return tourID;
    }

    public void setTourID(int tourID) {
        this.tourID = tourID;
    }

    public Date getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(Date bookingDate) {
        this.bookingDate = bookingDate;
    }

    public int getNumberOfPeople() {
        return numberOfPeople;
    }

    public void setNumberOfPeople(int numberOfPeople) {
        this.numberOfPeople = numberOfPeople;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
