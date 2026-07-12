package Models;

import java.math.BigDecimal;
import java.sql.Date;

public class Payment {
    private int paymentID;
    private int bookingID;
    private Date paymentDate;
    private BigDecimal amount;
    private String paymentMethod;
    private String status;
    private String sePayTransactionId;
    private String referenceCode;
    private String paymentCode;
    private String rawContent;

    public Payment() {
    }

    public Payment(int paymentID, int bookingID, Date paymentDate,
                   BigDecimal amount, String paymentMethod, String status,
                   String sePayTransactionId, String referenceCode,
                   String paymentCode, String rawContent) {
        this.paymentID = paymentID;
        this.bookingID = bookingID;
        this.paymentDate = paymentDate;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.status = status;
        this.sePayTransactionId = sePayTransactionId;
        this.referenceCode = referenceCode;
        this.paymentCode = paymentCode;
        this.rawContent = rawContent;
    }

    public int getPaymentID() {
        return paymentID;
    }

    public void setPaymentID(int paymentID) {
        this.paymentID = paymentID;
    }

    public int getBookingID() {
        return bookingID;
    }

    public void setBookingID(int bookingID) {
        this.bookingID = bookingID;
    }

    public Date getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(Date paymentDate) {
        this.paymentDate = paymentDate;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getSePayTransactionId() {
        return sePayTransactionId;
    }

    public void setSePayTransactionId(String sePayTransactionId) {
        this.sePayTransactionId = sePayTransactionId;
    }

    public String getReferenceCode() {
        return referenceCode;
    }

    public void setReferenceCode(String referenceCode) {
        this.referenceCode = referenceCode;
    }

    public String getPaymentCode() {
        return paymentCode;
    }

    public void setPaymentCode(String paymentCode) {
        this.paymentCode = paymentCode;
    }

    public String getRawContent() {
        return rawContent;
    }

    public void setRawContent(String rawContent) {
        this.rawContent = rawContent;
    }
}
