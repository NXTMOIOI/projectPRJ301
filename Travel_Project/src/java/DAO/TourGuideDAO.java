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
import Models.TourGuide;
import Utils.DBContext;

public class TourGuideDAO extends DBContext {

    public List<TourGuide> getAll() {
        List<TourGuide> guides = new ArrayList<>();
        String sql = "SELECT GuideID, FullName, Phone, Experience, Language FROM TourGuides";

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                guides.add(mapGuide(rs));
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot get tour guides", ex);
        }

        return guides;
    }

    public TourGuide getById(int guideID) {
        String sql = "SELECT GuideID, FullName, Phone, Experience, Language FROM TourGuides WHERE GuideID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, guideID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapGuide(rs);
                }
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot get tour guide by id", ex);
        }

        return null;
    }

    public boolean insert(TourGuide guide) {
        String sql = "INSERT INTO TourGuides(FullName, Phone, Experience, Language) VALUES (?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            setGuideParameters(ps, guide);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot insert tour guide", ex);
        }
    }

    public boolean update(TourGuide guide) {
        String sql = "UPDATE TourGuides SET FullName = ?, Phone = ?, Experience = ?, Language = ? WHERE GuideID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            setGuideParameters(ps, guide);
            ps.setInt(5, guide.getGuideID());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot update tour guide", ex);
        }
    }

    public boolean delete(int guideID) {
        String sql = "DELETE FROM TourGuides WHERE GuideID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, guideID);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot delete tour guide", ex);
        }
    }

    private void setGuideParameters(PreparedStatement ps, TourGuide guide) throws SQLException {
        ps.setString(1, guide.getFullName());
        ps.setString(2, guide.getPhone());
        ps.setInt(3, guide.getExperience());
        ps.setString(4, guide.getLanguage());
    }

    private TourGuide mapGuide(ResultSet rs) throws SQLException {
        return new TourGuide(
                rs.getInt("GuideID"),
                rs.getString("FullName"),
                rs.getString("Phone"),
                rs.getInt("Experience"),
                rs.getString("Language")
        );
    }
}
