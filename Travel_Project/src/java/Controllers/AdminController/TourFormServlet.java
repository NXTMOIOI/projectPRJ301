package Controllers.AdminController;

import DAO.TourDAO;
import Models.Tour;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.LinkedHashMap;
import java.util.Map;

@WebServlet(name = "TourFormServlet", urlPatterns = {"/admin/tour-form"})
public class TourFormServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int tourID = parseInt(request.getParameter("id"));
        Tour tour = tourID > 0 ? new TourDAO().getById(tourID) : new Tour();
        if (tourID > 0 && tour == null) {
            response.sendRedirect(request.getContextPath() + "/admin/tours");
            return;
        }

        request.setAttribute("tour", tour);
        request.setAttribute("formMode", tourID > 0 ? "edit" : "create");
        request.getRequestDispatcher("/view/AdminTourForm.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        int tourID = parseInt(request.getParameter("tourID"));
        String mode = tourID > 0 ? "edit" : "create";
        Map<String, String> errors = new LinkedHashMap<>();
        Tour tour = buildTour(request, errors);
        tour.setTourID(tourID);

        if (!errors.isEmpty()) {
            request.setAttribute("tour", tour);
            request.setAttribute("errors", errors);
            request.setAttribute("formMode", mode);
            request.getRequestDispatcher("/view/AdminTourForm.jsp").forward(request, response);
            return;
        }

        TourDAO tourDAO = new TourDAO();
        if (tourID > 0) {
            tourDAO.update(tour);
        } else {
            tourDAO.insert(tour);
        }

        response.sendRedirect(request.getContextPath() + "/admin/tours?saved=1");
    }

    private Tour buildTour(HttpServletRequest request, Map<String, String> errors) {
        Tour tour = new Tour();
        tour.setTourName(safe(request.getParameter("tourName")));
        tour.setDestination(safe(request.getParameter("destination")));
        tour.setImageURL(safe(request.getParameter("imageURL")));

        if (tour.getTourName().isEmpty()) {
            errors.put("tourName", "Vui long nhap ten tour.");
        }
        if (tour.getDestination().isEmpty()) {
            errors.put("destination", "Vui long nhap diem den.");
        }
        if (tour.getImageURL().isEmpty()) {
            errors.put("imageURL", "Vui long nhap ten file anh.");
        }

        try {
            int duration = Integer.parseInt(safe(request.getParameter("duration")));
            if (duration <= 0) {
                errors.put("duration", "So ngay tour phai lon hon 0.");
            }
            tour.setDuration(duration);
        } catch (NumberFormatException ex) {
            errors.put("duration", "So ngay tour khong hop le.");
        }

        try {
            BigDecimal price = new BigDecimal(safe(request.getParameter("price")));
            if (price.compareTo(BigDecimal.ZERO) <= 0) {
                errors.put("price", "Gia tour phai lon hon 0.");
            }
            tour.setPrice(price);
        } catch (NumberFormatException ex) {
            errors.put("price", "Gia tour khong hop le.");
        }

        try {
            int maxPeople = Integer.parseInt(safe(request.getParameter("maxPeople")));
            if (maxPeople <= 0) {
                errors.put("maxPeople", "Suc chua phai lon hon 0.");
            }
            tour.setMaxPeople(maxPeople);
        } catch (NumberFormatException ex) {
            errors.put("maxPeople", "Suc chua khong hop le.");
        }

        try {
            String startDate = safe(request.getParameter("startDate"));
            String endDate = safe(request.getParameter("endDate"));
            if (startDate.isEmpty()) {
                errors.put("startDate", "Vui long chon ngay khoi hanh.");
            } else {
                tour.setStartDate(Date.valueOf(startDate));
            }
            if (endDate.isEmpty()) {
                errors.put("endDate", "Vui long chon ngay ket thuc.");
            } else {
                tour.setEndDate(Date.valueOf(endDate));
            }
            if (tour.getStartDate() != null && tour.getEndDate() != null
                    && tour.getEndDate().before(tour.getStartDate())) {
                errors.put("endDate", "Ngay ket thuc phai sau ngay khoi hanh.");
            }
        } catch (IllegalArgumentException ex) {
            errors.put("startDate", "Ngay thang khong hop le.");
        }

        return tour;
    }

    private int parseInt(String value) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException ex) {
            return -1;
        }
    }

    private String safe(String value) {
        return value == null ? "" : value.trim();
    }
}
