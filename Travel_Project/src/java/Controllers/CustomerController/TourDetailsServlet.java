package Controllers.CustomerController;

import DAO.IniteraryDAO;
import DAO.TourDAO;
import Models.Tour;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;


@WebServlet(name = "TourDetailsServlet", urlPatterns = {"/tour-details"})
public class TourDetailsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        int tourID = parseTourID(request.getParameter("id"));
        if (tourID <= 0) {
            response.sendRedirect(request.getContextPath() + "/tours");
            return;
        }

        Tour tour = new TourDAO().getById(tourID);
        if (tour == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Tour not found");
            return;
        }

        request.setAttribute("tour", tour);
        request.setAttribute("itineraries", new IniteraryDAO().getByTourId(tourID));
        request.getRequestDispatcher("view/tour_detail.jsp").forward(request, response);
    }

    private int parseTourID(String value) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException ex) {
            return -1;
        }
    }
}
