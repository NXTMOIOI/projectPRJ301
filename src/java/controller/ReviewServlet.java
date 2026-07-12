import dal.DBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.*;

@WebServlet(name = "ReviewServlet", urlPatterns = {"/review"})
public class ReviewServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Integer customerId = (Integer) session.getAttribute("customerID");

        // Bắt buộc đăng nhập
        if (customerId == null || customerId == 0) {
            response.sendRedirect("login.jsp?msg=login_required");
            return;
        }

        int tourId = Integer.parseInt(request.getParameter("tourId"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String comment = request.getParameter("comment");

        try (Connection conn = new DBContext().getConnection()) {
            String sql = "INSERT INTO Reviews(CustomerID, TourID, Rating, Comment) VALUES(?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, customerId);
            ps.setInt(2, tourId);
            ps.setInt(3, rating);
            ps.setString(4, comment);
            
            ps.executeUpdate();
            
            // Trở lại trang chi tiết tour của bạn My làm
            response.sendRedirect("tourDetail?id=" + tourId);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}