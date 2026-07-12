package Controllers.CustomerController;

import DAO.BookingDAO;
import Models.BookingSummary;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "BookingSuccessServlet", urlPatterns = {"/booking-success"})
public class BookingSuccessServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int bookingID = parseInt(request.getParameter("id"));
        if (bookingID <= 0) {
            response.sendRedirect(request.getContextPath() + "/tours");
            return;
        }

        BookingDAO bookingDAO = new BookingDAO();
        bookingDAO.markExpiredIfNeeded(bookingID);
        BookingSummary booking = bookingDAO.getSummaryById(bookingID);
        if (booking == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Booking not found");
            return;
        }

        request.setAttribute("booking", booking);
        request.getRequestDispatcher("/view/BookingSuccess.jsp").forward(request, response);
    }

    private int parseInt(String value) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException ex) {
            return -1;
        }
    }
}
