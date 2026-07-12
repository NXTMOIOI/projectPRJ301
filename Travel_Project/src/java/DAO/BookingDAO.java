package DAO;

import Models.Booking;
import Models.BookingSummary;
import Models.Customer;
import Utils.DBContext;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO extends DBContext {

    private static final int PAYMENT_EXPIRE_MINUTES = 15;

    public int createBooking(Customer customer, int tourID, int numberOfPeople, BigDecimal unitPrice) {
        String findCustomerSql = "SELECT TOP 1 CustomerID FROM Customers WHERE (? <> '' AND Email = ?) OR (? <> '' AND Phone = ?)";
        String insertCustomerSql = "INSERT INTO Customers(FullName, Gender, DateOfBirth, Phone, Email, Address, CCCD) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        String insertBookingSql = "INSERT INTO Bookings(CustomerID, TourID, BookingDate, NumberOfPeople, TotalAmount, Status, PaymentCode, PaymentExpiredAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        String updateCodeSql = "UPDATE Bookings SET PaymentCode = ? WHERE BookingID = ?";

        try {
            connection.setAutoCommit(false);

            int customerID = findExistingCustomerId(findCustomerSql, customer.getEmail(), customer.getPhone());
            if (customerID <= 0) {
                customerID = insertCustomer(insertCustomerSql, customer);
            }

            int bookingID = insertBooking(insertBookingSql, customerID, tourID, numberOfPeople, unitPrice);
            updatePaymentCode(updateCodeSql, bookingID, generatePaymentCode(bookingID));
            connection.commit();
            return bookingID;
        } catch (SQLException ex) {
            rollbackQuietly();
            throw new RuntimeException("Cannot create booking", ex);
        } finally {
            restoreAutoCommitQuietly();
        }
    }

    public Booking getById(int bookingID) {
        String sql = "SELECT BookingID, CustomerID, TourID, BookingDate, NumberOfPeople, TotalAmount, Status, PaymentCode, PaymentExpiredAt "
                + "FROM Bookings WHERE BookingID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapBooking(rs);
                }
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot get booking by id", ex);
        }

        return null;
    }

    public BookingSummary getSummaryById(int bookingID) {
        String sql = baseSummaryQuery() + " WHERE b.BookingID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapSummary(rs);
                }
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot get booking summary", ex);
        }

        return null;
    }

    public int countBookings(String keyword, String status) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM Bookings b "
                + "INNER JOIN Customers c ON b.CustomerID = c.CustomerID "
                + "INNER JOIN Tours t ON b.TourID = t.TourID WHERE 1 = 1");

        List<String> params = new ArrayList<>();
        appendFilters(sql, params, keyword, status);

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            setStringParams(ps, params);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot count bookings", ex);
        }

        return 0;
    }

    public List<BookingSummary> searchBookings(String keyword, String status, int offset, int pageSize) {
        StringBuilder sql = new StringBuilder(baseSummaryQuery() + " WHERE 1 = 1");
        List<String> params = new ArrayList<>();
        appendFilters(sql, params, keyword, status);
        sql.append(" ORDER BY b.BookingDate DESC, b.BookingID DESC")
                .append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int index = setStringParams(ps, params);
            ps.setInt(index++, Math.max(offset, 0));
            ps.setInt(index, Math.max(pageSize, 1));

            List<BookingSummary> bookings = new ArrayList<>();
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    bookings.add(mapSummary(rs));
                }
            }
            return bookings;
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot search bookings", ex);
        }
    }

    public boolean updateBooking(int bookingID, int numberOfPeople, BigDecimal totalAmount, String status) {
        String sql = "UPDATE Bookings SET NumberOfPeople = ?, TotalAmount = ?, Status = ? WHERE BookingID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, numberOfPeople);
            ps.setBigDecimal(2, totalAmount);
            ps.setString(3, status);
            ps.setInt(4, bookingID);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot update booking", ex);
        }
    }

    public boolean delete(int bookingID) {
        String sql = "DELETE FROM Bookings WHERE BookingID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingID);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot delete booking", ex);
        }
    }

    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM Bookings WHERE Status = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot count booking status", ex);
        }

        return 0;
    }

    public int getReservedPeopleByTour(int tourID) {
        String sql = "SELECT ISNULL(SUM(NumberOfPeople), 0) FROM Bookings WHERE TourID = ? "
                + "AND Status NOT IN (N'\u0110\u00e3 h\u1ee7y', N'H\u1ebft h\u1ea1n')";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tourID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot count reserved people", ex);
        }

        return 0;
    }

    public int getReservedPeopleByTourExcludingBooking(int tourID, int bookingID) {
        String sql = "SELECT ISNULL(SUM(NumberOfPeople), 0) FROM Bookings "
                + "WHERE TourID = ? AND BookingID <> ? AND Status NOT IN (N'\u0110\u00e3 h\u1ee7y', N'H\u1ebft h\u1ea1n')";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tourID);
            ps.setInt(2, bookingID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot count reserved people excluding booking", ex);
        }

        return 0;
    }

    public boolean hasPayment(int bookingID) {
        String sql = "SELECT COUNT(*) FROM Payments WHERE BookingID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot check booking payments", ex);
        }

        return false;
    }

    public BookingSummary getByPaymentCode(String paymentCode) {
        String sql = baseSummaryQuery() + " WHERE b.PaymentCode = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, paymentCode);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapSummary(rs);
                }
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot get booking by payment code", ex);
        }

        return null;
    }

    public boolean markExpiredIfNeeded(int bookingID) {
        String sql = "UPDATE Bookings SET Status = N'Hết hạn' "
                + "WHERE BookingID = ? AND Status = N'Chờ thanh toán' AND PaymentExpiredAt IS NOT NULL AND PaymentExpiredAt < ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingID);
            ps.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot mark booking expired", ex);
        }
    }

    public int expirePendingBookings() {
        String sql = "UPDATE Bookings SET Status = N'Hết hạn' "
                + "WHERE Status = N'Chờ thanh toán' AND PaymentExpiredAt IS NOT NULL AND PaymentExpiredAt < ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            return ps.executeUpdate();
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot expire pending bookings", ex);
        }
    }

    public boolean isExpired(BookingSummary booking) {
        return booking != null
                && booking.getPaymentExpiredAt() != null
                && booking.getPaymentExpiredAt().before(new Timestamp(System.currentTimeMillis()));
    }

    private String baseSummaryQuery() {
        return "SELECT b.BookingID, b.CustomerID, c.FullName AS CustomerName, c.Phone, c.Email, "
                + "b.TourID, t.TourName, b.BookingDate, b.NumberOfPeople, t.Price, b.TotalAmount, b.Status, "
                + "b.PaymentCode, b.PaymentExpiredAt "
                + "FROM Bookings b "
                + "INNER JOIN Customers c ON b.CustomerID = c.CustomerID "
                + "INNER JOIN Tours t ON b.TourID = t.TourID";
    }

    private void appendFilters(StringBuilder sql, List<String> params, String keyword, String status) {
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (CAST(b.BookingID AS VARCHAR(20)) LIKE ? OR c.FullName LIKE ? OR c.Phone LIKE ? OR t.TourName LIKE ?)");
            String pattern = "%" + keyword.trim() + "%";
            params.add(pattern);
            params.add(pattern);
            params.add(pattern);
            params.add(pattern);
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND b.Status = ?");
            params.add(status.trim());
        }
    }

    private int setStringParams(PreparedStatement ps, List<String> params) throws SQLException {
        int index = 1;
        for (String param : params) {
            ps.setString(index++, param);
        }
        return index;
    }

    private int findExistingCustomerId(String sql, String email, String phone) throws SQLException {
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, safe(email));
            ps.setString(2, safe(email));
            ps.setString(3, safe(phone));
            ps.setString(4, safe(phone));

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return -1;
    }

    private int insertCustomer(String sql, Customer customer) throws SQLException {
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, customer.getFullName());
            ps.setString(2, customer.getGender());
            ps.setDate(3, customer.getDateOfBirth());
            ps.setString(4, customer.getPhone());
            ps.setString(5, customer.getEmail());
            ps.setString(6, customer.getAddress());
            ps.setString(7, customer.getCccd());
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }

        throw new SQLException("Cannot get generated customer id");
    }

    private int insertBooking(String sql, int customerID, int tourID, int numberOfPeople, BigDecimal unitPrice) throws SQLException {
        BigDecimal totalAmount = unitPrice.multiply(BigDecimal.valueOf(numberOfPeople));
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, customerID);
            ps.setInt(2, tourID);
            ps.setDate(3, new Date(System.currentTimeMillis()));
            ps.setInt(4, numberOfPeople);
            ps.setBigDecimal(5, totalAmount);
            ps.setString(6, "Ch\u1edd thanh to\u00e1n");
            ps.setString(7, null);
            ps.setTimestamp(8, buildPaymentExpiredAt());
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }

        throw new SQLException("Cannot get generated booking id");
    }

    private void updatePaymentCode(String sql, int bookingID, String paymentCode) throws SQLException {
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, paymentCode);
            ps.setInt(2, bookingID);
            ps.executeUpdate();
        }
    }

    private Booking mapBooking(ResultSet rs) throws SQLException {
        return new Booking(
                rs.getInt("BookingID"),
                rs.getInt("CustomerID"),
                rs.getInt("TourID"),
                rs.getDate("BookingDate"),
                rs.getInt("NumberOfPeople"),
                rs.getBigDecimal("TotalAmount"),
                rs.getString("Status"),
                rs.getString("PaymentCode"),
                rs.getTimestamp("PaymentExpiredAt")
        );
    }

    private BookingSummary mapSummary(ResultSet rs) throws SQLException {
        return new BookingSummary(
                rs.getInt("BookingID"),
                rs.getInt("CustomerID"),
                rs.getString("CustomerName"),
                rs.getString("Phone"),
                rs.getString("Email"),
                rs.getInt("TourID"),
                rs.getString("TourName"),
                rs.getDate("BookingDate"),
                rs.getInt("NumberOfPeople"),
                rs.getBigDecimal("Price"),
                rs.getBigDecimal("TotalAmount"),
                rs.getString("Status"),
                rs.getString("PaymentCode"),
                rs.getTimestamp("PaymentExpiredAt")
        );
    }

    private Timestamp buildPaymentExpiredAt() {
        return new Timestamp(System.currentTimeMillis() + PAYMENT_EXPIRE_MINUTES * 60L * 1000L);
    }

    private String generatePaymentCode(int bookingID) {
        return "BK" + bookingID;
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

    private String safe(String value) {
        return value == null ? "" : value.trim();
    }
}
