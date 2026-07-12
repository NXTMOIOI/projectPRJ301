package DAO;

import Models.BookingSummary;
import Models.Payment;
import Utils.DBContext;
import java.math.BigDecimal;
import java.sql.DatabaseMetaData;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;

public class PaymentDAO extends DBContext {

    private Boolean sePayTransactionIdNumericColumn;

    public Payment getByBookingId(int bookingID) {
        String sql = "SELECT TOP 1 PaymentID, BookingID, PaymentDate, Amount, PaymentMethod, Status, "
                + "SePayTransactionId, ReferenceCode, PaymentCode, RawContent "
                + "FROM Payments WHERE BookingID = ? ORDER BY PaymentID DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapPayment(rs);
                }
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot get payment by booking id", ex);
        }

        return null;
    }

    public Payment getByReferenceCode(String referenceCode) {
        String sql = "SELECT TOP 1 PaymentID, BookingID, PaymentDate, Amount, PaymentMethod, Status, "
                + "SePayTransactionId, ReferenceCode, PaymentCode, RawContent "
                + "FROM Payments WHERE ReferenceCode = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, referenceCode);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapPayment(rs);
                }
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot get payment by reference code", ex);
        }

        return null;
    }

    public boolean createSandboxPayment(BookingSummary booking, String sePayTransactionId,
            String referenceCode, String rawContent, String paymentMethod) {
        String sql = "INSERT INTO Payments(BookingID, PaymentDate, Amount, PaymentMethod, Status, "
                + "SePayTransactionId, ReferenceCode, PaymentCode, RawContent) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, booking.getBookingID());
            ps.setDate(2, new Date(System.currentTimeMillis()));
            ps.setBigDecimal(3, booking.getTotalAmount());
            ps.setString(4, paymentMethod);
            ps.setString(5, "Đã thanh toán");
            setSePayTransactionId(ps, 6, sePayTransactionId);
            ps.setString(7, referenceCode);
            ps.setString(8, booking.getPaymentCode());
            ps.setString(9, rawContent);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot create payment record", ex);
        }
    }

    public boolean createSandboxPaymentAndMarkPaid(BookingSummary booking, String sePayTransactionId,
            String referenceCode, String rawContent, String paymentMethod) {
        try {
            connection.setAutoCommit(false);
            boolean inserted = createSandboxPayment(booking, sePayTransactionId, referenceCode, rawContent, paymentMethod);
            boolean updated = markBookingPaid(booking.getBookingID());
            connection.commit();
            return inserted && updated;
        } catch (RuntimeException ex) {
            rollbackQuietly();
            throw ex;
        } catch (SQLException ex) {
            rollbackQuietly();
            throw new RuntimeException("Cannot process payment transaction", ex);
        } finally {
            restoreAutoCommitQuietly();
        }
    }

    public boolean hasPaymentForCode(String paymentCode) {
        String sql = "SELECT COUNT(*) FROM Payments WHERE PaymentCode = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, paymentCode);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot check payment by code", ex);
        }

        return false;
    }

    public boolean markBookingPaid(int bookingID) {
        String sql = "UPDATE Bookings SET Status = N'Đã thanh toán' WHERE BookingID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingID);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot mark booking paid", ex);
        }
    }

    public boolean isAmountMatched(BigDecimal bookingAmount, BigDecimal paymentAmount) {
        return bookingAmount != null && paymentAmount != null && bookingAmount.compareTo(paymentAmount) == 0;
    }

    private Payment mapPayment(ResultSet rs) throws SQLException {
        return new Payment(
                rs.getInt("PaymentID"),
                rs.getInt("BookingID"),
                rs.getDate("PaymentDate"),
                rs.getBigDecimal("Amount"),
                rs.getString("PaymentMethod"),
                rs.getString("Status"),
                rs.getString("SePayTransactionId"),
                rs.getString("ReferenceCode"),
                rs.getString("PaymentCode"),
                rs.getString("RawContent")
        );
    }

    private void setSePayTransactionId(PreparedStatement ps, int parameterIndex, String value) throws SQLException {
        if (value == null || value.trim().isEmpty()) {
            ps.setNull(parameterIndex, isSePayTransactionIdNumericColumn() ? Types.BIGINT : Types.VARCHAR);
            return;
        }

        if (isSePayTransactionIdNumericColumn()) {
            try {
                ps.setLong(parameterIndex, Long.parseLong(value.trim()));
            } catch (NumberFormatException ex) {
                ps.setNull(parameterIndex, Types.BIGINT);
            }
            return;
        }

        ps.setString(parameterIndex, value.trim());
    }

    private boolean isSePayTransactionIdNumericColumn() {
        if (sePayTransactionIdNumericColumn != null) {
            return sePayTransactionIdNumericColumn;
        }

        try {
            DatabaseMetaData metaData = connection.getMetaData();
            try (ResultSet rs = metaData.getColumns(null, null, "Payments", "SePayTransactionId")) {
                if (rs.next()) {
                    int dataType = rs.getInt("DATA_TYPE");
                    sePayTransactionIdNumericColumn = dataType == Types.BIGINT
                            || dataType == Types.INTEGER
                            || dataType == Types.SMALLINT
                            || dataType == Types.TINYINT
                            || dataType == Types.NUMERIC
                            || dataType == Types.DECIMAL;
                } else {
                    sePayTransactionIdNumericColumn = false;
                }
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot inspect Payments.SePayTransactionId column type", ex);
        }

        return sePayTransactionIdNumericColumn;
    }

    private void rollbackQuietly() {
        try {
            connection.rollback();
        } catch (SQLException ignored) {
        }
    }

    private void restoreAutoCommitQuietly() {
        try {
            connection.setAutoCommit(true);
        } catch (SQLException ignored) {
        }
    }
}
