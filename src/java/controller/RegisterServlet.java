import dal.DBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String username = request.getParameter("username");
        String pass = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");

        try (Connection conn = new DBContext().getConnection()) {
            // 1. Thêm vào bảng Customers trước
            String sqlCust = "INSERT INTO Customers(FullName, Phone, Email) VALUES(?, ?, ?)";
            PreparedStatement psCust = conn.prepareStatement(sqlCust, Statement.RETURN_GENERATED_KEYS);
            psCust.setString(1, fullName);
            psCust.setString(2, phone);
            psCust.setString(3, email);
            psCust.executeUpdate();
            
            // Lấy CustomerID vừa được tạo
            ResultSet rs = psCust.getGeneratedKeys();
            int newCustomerId = 0;
            if (rs.next()) {
                newCustomerId = rs.getInt(1);
            }

            // 2. Thêm vào bảng Users
            String sqlUser = "INSERT INTO Users(Username, Password, Role, CustomerID) VALUES(?, ?, 'CUSTOMER', ?)";
            PreparedStatement psUser = conn.prepareStatement(sqlUser);
            psUser.setString(1, username);
            psUser.setString(2, pass);
            psUser.setInt(3, newCustomerId);
            psUser.executeUpdate();

            response.sendRedirect("login.jsp?msg=registered");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đăng ký thất bại, tên đăng nhập có thể đã tồn tại.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}