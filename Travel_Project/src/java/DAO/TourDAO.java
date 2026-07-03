/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import Models.Tour;
import Utils.DBContext;

public class TourDAO extends DBContext {

    public List<Tour> getAll() {
        List<Tour> tours = new ArrayList<>();
        String sql = "SELECT TourID, TourName, Destination, Duration, Price, MaxPeople, StartDate, EndDate, ImageURL FROM Tours";

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                tours.add(mapTour(rs));
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot get tours", ex);
        }

        return tours;
    }

    public Tour getById(int tourID) {
        String sql = "SELECT TourID, TourName, Destination, Duration, Price, MaxPeople, StartDate, EndDate, ImageURL FROM Tours WHERE TourID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tourID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapTour(rs);
                }
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot get tour by id", ex);
        }

        return null;
    }

    public List<Tour> searchByDestination(String destination) {
        List<Tour> tours = new ArrayList<>();
        String sql = "SELECT TourID, TourName, Destination, Duration, Price, MaxPeople, StartDate, EndDate, ImageURL "
                + "FROM Tours WHERE Destination LIKE ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + destination + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    tours.add(mapTour(rs));
                }
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot search tours by destination", ex);
        }

        return tours;
    }

    public boolean insert(Tour tour) {
        String sql = "INSERT INTO Tours(TourName, Destination, Duration, Price, MaxPeople, StartDate, EndDate, ImageURL) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            setTourParameters(ps, tour);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot insert tour", ex);
        }
    }

    public boolean update(Tour tour) {
        String sql = "UPDATE Tours SET TourName = ?, Destination = ?, Duration = ?, Price = ?, MaxPeople = ?, "
                + "StartDate = ?, EndDate = ?, ImageURL = ? WHERE TourID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            setTourParameters(ps, tour);
            ps.setInt(9, tour.getTourID());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot update tour", ex);
        }
    }

    public boolean delete(int tourID) {
        String sql = "DELETE FROM Tours WHERE TourID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tourID);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot delete tour", ex);
        }
    }

    private void setTourParameters(PreparedStatement ps, Tour tour) throws SQLException {
        ps.setString(1, tour.getTourName());
        ps.setString(2, tour.getDestination());
        ps.setInt(3, tour.getDuration());
        ps.setBigDecimal(4, tour.getPrice());
        ps.setInt(5, tour.getMaxPeople());
        ps.setDate(6, toSqlDate(tour.getStartDate()));
        ps.setDate(7, toSqlDate(tour.getEndDate()));
        ps.setString(8, tour.getImageURL());
    }

    private Date toSqlDate(java.util.Date date) {
        return date == null ? null : new Date(date.getTime());
    }

    private Tour mapTour(ResultSet rs) throws SQLException {
        return new Tour(
                rs.getInt("TourID"),
                rs.getString("TourName"),
                rs.getString("Destination"),
                rs.getInt("Duration"),
                rs.getBigDecimal("Price"),
                rs.getInt("MaxPeople"),
                rs.getDate("StartDate"),
                rs.getDate("EndDate"),
                rs.getString("ImageURL")
        );
    }
}
