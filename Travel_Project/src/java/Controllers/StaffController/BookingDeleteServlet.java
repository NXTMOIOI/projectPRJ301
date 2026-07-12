package Controllers.StaffController;

import DAO.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "BookingDeleteServlet", urlPatterns = {"/staff/booking-delete"})
public class BookingDeleteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int bookingID = parseInt(request.getParameter("id"));
        BookingDAO bookingDAO = new BookingDAO();

        if (bookingID <= 0) {
            response.sendRedirect(request.getContextPath() + "/staff/bookings?deleteError=1");
            return;
        }

        if (bookingDAO.hasPayment(bookingID)) {
            response.sendRedirect(request.getContextPath() + "/staff/bookings?deleteBlocked=1");
            return;
        }

        bookingDAO.delete(bookingID);
        response.sendRedirect(request.getContextPath() + "/staff/bookings?deleted=1");
    }

    private int parseInt(String value) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException ex) {
            return -1;
        }
    }
}
