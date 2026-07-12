import dal.DBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.*;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
public class ProfileServlet extends HttpServlet {
    
    // Xử lý cập nhật thông tin
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Integer customerId = (Integer) session.getAttribute("customerID");

        if (customerId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String fullName = request.getParameter("fullName");
        String gender = request.getParameter("gender");
        String dob = request.getParameter("dob");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String cccd = request.getParameter("cccd");

        try (Connection conn = new DBContext().getConnection()) {
            String sql = "UPDATE Customers SET FullName=?, Gender=?, DateOfBirth=?, Phone=?, Address=?, CCCD=? WHERE CustomerID=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, fullName);
            ps.setString(2, gender);
            ps.setString(3, dob);
            ps.setString(4, phone);
            ps.setString(5, address);
            ps.setString(6, cccd);
            ps.setInt(7, customerId);
            
            ps.executeUpdate();
            request.setAttribute("msg", "Cập nhật hồ sơ thành công!");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}