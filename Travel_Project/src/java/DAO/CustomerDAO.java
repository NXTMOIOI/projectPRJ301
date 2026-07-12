package DAO;

import Models.Customer;
import Utils.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class CustomerDAO extends DBContext {

    public Customer findByEmailOrPhone(String email, String phone) {
        String sql = "SELECT TOP 1 CustomerID, FullName, Gender, DateOfBirth, Phone, Email, Address, CCCD "
                + "FROM Customers WHERE (? <> '' AND Email = ?) OR (? <> '' AND Phone = ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, safe(email));
            ps.setString(2, safe(email));
            ps.setString(3, safe(phone));
            ps.setString(4, safe(phone));

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapCustomer(rs);
                }
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot find customer by email or phone", ex);
        }

        return null;
    }

    public int insert(Customer customer) {
        String sql = "INSERT INTO Customers(FullName, Gender, DateOfBirth, Phone, Email, Address, CCCD) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

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
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot insert customer", ex);
        }

        throw new RuntimeException("Cannot get generated customer id");
    }

    private Customer mapCustomer(ResultSet rs) throws SQLException {
        return new Customer(
                rs.getInt("CustomerID"),
                rs.getString("FullName"),
                rs.getString("Gender"),
                rs.getDate("DateOfBirth"),
                rs.getString("Phone"),
                rs.getString("Email"),
                rs.getString("Address"),
                rs.getString("CCCD")
        );
    }

    private String safe(String value) {
        return value == null ? "" : value.trim();
    }
}
