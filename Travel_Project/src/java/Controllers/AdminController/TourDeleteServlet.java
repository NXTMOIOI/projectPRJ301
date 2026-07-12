package Controllers.AdminController;

import DAO.TourDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "TourDeleteServlet", urlPatterns = {"/admin/tour-delete"})
public class TourDeleteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int tourID = parseInt(request.getParameter("id"));
        TourDAO tourDAO = new TourDAO();

        if (tourID <= 0) {
            response.sendRedirect(request.getContextPath() + "/admin/tours?deleteError=1");
            return;
        }

        if (tourDAO.hasDependencies(tourID)) {
            response.sendRedirect(request.getContextPath() + "/admin/tours?deleteBlocked=1");
            return;
        }

        tourDAO.delete(tourID);
        response.sendRedirect(request.getContextPath() + "/admin/tours?deleted=1");
    }

    private int parseInt(String value) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException ex) {
            return -1;
        }
    }
}
