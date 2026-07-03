/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import Models.TourHotel;
import Utils.DBContext;

public class TourHotelDAO extends DBContext {

    public List<TourHotel> getAll() {
        List<TourHotel> tourHotels = new ArrayList<>();
        String sql = "SELECT TourHotelID, TourID, HotelID FROM TourHotels";

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                tourHotels.add(mapTourHotel(rs));
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot get tour hotels", ex);
        }

        return tourHotels;
    }

    public TourHotel getById(int tourHotelID) {
        String sql = "SELECT TourHotelID, TourID, HotelID FROM TourHotels WHERE TourHotelID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tourHotelID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapTourHotel(rs);
                }
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot get tour hotel by id", ex);
        }

        return null;
    }

    public List<TourHotel> getByTourId(int tourID) {
        List<TourHotel> tourHotels = new ArrayList<>();
        String sql = "SELECT TourHotelID, TourID, HotelID FROM TourHotels WHERE TourID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tourID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    tourHotels.add(mapTourHotel(rs));
                }
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot get tour hotels by tour id", ex);
        }

        return tourHotels;
    }

    public List<TourHotel> getByHotelId(int hotelID) {
        List<TourHotel> tourHotels = new ArrayList<>();
        String sql = "SELECT TourHotelID, TourID, HotelID FROM TourHotels WHERE HotelID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, hotelID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    tourHotels.add(mapTourHotel(rs));
                }
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot get tour hotels by hotel id", ex);
        }

        return tourHotels;
    }

    public boolean insert(TourHotel tourHotel) {
        String sql = "INSERT INTO TourHotels(TourID, HotelID) VALUES (?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tourHotel.getTourID());
            ps.setInt(2, tourHotel.getHotelID());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot insert tour hotel", ex);
        }
    }

    public boolean update(TourHotel tourHotel) {
        String sql = "UPDATE TourHotels SET TourID = ?, HotelID = ? WHERE TourHotelID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tourHotel.getTourID());
            ps.setInt(2, tourHotel.getHotelID());
            ps.setInt(3, tourHotel.getTourHotelID());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot update tour hotel", ex);
        }
    }

    public boolean delete(int tourHotelID) {
        String sql = "DELETE FROM TourHotels WHERE TourHotelID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tourHotelID);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot delete tour hotel", ex);
        }
    }

    private TourHotel mapTourHotel(ResultSet rs) throws SQLException {
        return new TourHotel(
                rs.getInt("TourHotelID"),
                rs.getInt("HotelID"),
                rs.getInt("TourID")
        );
    }
}
