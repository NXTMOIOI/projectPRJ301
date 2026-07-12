package Models;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

public class BookingSummary {
    private int bookingID;
    private int customerID;
    private String customerName;
    private String customerPhone;
    private String customerEmail;
    private int tourID;
    private String tourName;
    private Date bookingDate;
    private int numberOfPeople;
    private BigDecimal unitPrice;
    private BigDecimal totalAmount;
    private String status;
    private String paymentCode;
    private Timestamp paymentExpiredAt;

    public BookingSummary() {
    }

    public BookingSummary(int bookingID, int customerID, String customerName,
            String customerPhone, String customerEmail, int tourID, String tourName,
            Date bookingDate, int numberOfPeople, BigDecimal unitPrice,
            BigDecimal totalAmount, String status, String paymentCode,
            Timestamp paymentExpiredAt) {
        this.bookingID = bookingID;
        this.customerID = customerID;
        this.customerName = customerName;
        this.customerPhone = customerPhone;
        this.customerEmail = customerEmail;
        this.tourID = tourID;
        this.tourName = tourName;
        this.bookingDate = bookingDate;
        this.numberOfPeople = numberOfPeople;
        this.unitPrice = unitPrice;
        this.totalAmount = totalAmount;
        this.status = status;
        this.paymentCode = paymentCode;
        this.paymentExpiredAt = paymentExpiredAt;
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

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerPhone() {
        return customerPhone;
    }

    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }

    public String getCustomerEmail() {
        return customerEmail;
    }

    public void setCustomerEmail(String customerEmail) {
        this.customerEmail = customerEmail;
    }

    public int getTourID() {
        return tourID;
    }

    public void setTourID(int tourID) {
        this.tourID = tourID;
    }

    public String getTourName() {
        return tourName;
    }

    public void setTourName(String tourName) {
        this.tourName = tourName;
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

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
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

    public String getPaymentCode() {
        return paymentCode;
    }

    public void setPaymentCode(String paymentCode) {
        this.paymentCode = paymentCode;
    }

    public Timestamp getPaymentExpiredAt() {
        return paymentExpiredAt;
    }

    public void setPaymentExpiredAt(Timestamp paymentExpiredAt) {
        this.paymentExpiredAt = paymentExpiredAt;
    }
}
