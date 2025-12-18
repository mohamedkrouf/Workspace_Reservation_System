package dao;

import java.sql.*;
import java.util.*;
import model.Reservation;
import utils.DBConnection;

public class ReservationDAO {

    // Check if room is available during time slot
    public static boolean isRoomAvailable(int roomId, Timestamp start, Timestamp end) throws Exception {
        String sql = "SELECT COUNT(*) FROM reservations WHERE room_id = ? AND status = 'ACTIVE' " +
                     "AND NOT (end_time <= ? OR start_time >= ?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ps.setTimestamp(2, start);
            ps.setTimestamp(3, end);
            ResultSet rs = ps.executeQuery();
            rs.next();
            return rs.getInt(1) == 0;
        }
    }

    // Check if user already has reservation during time slot
    public static boolean isUserAvailable(int userId, Timestamp start, Timestamp end) throws Exception {
        String sql = "SELECT COUNT(*) FROM reservations WHERE user_id = ? AND status = 'ACTIVE' " +
                     "AND NOT (end_time <= ? OR start_time >= ?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setTimestamp(2, start);
            ps.setTimestamp(3, end);
            ResultSet rs = ps.executeQuery();
            rs.next();
            return rs.getInt(1) == 0;
        }
    }

    // Create new reservation
    public static boolean createReservation(int userId, int roomId, Timestamp start, Timestamp end) throws Exception {
        // Validate times
        if (start.getTime() >= end.getTime()) {
            return false;
        }

        String sql = "INSERT INTO reservations(user_id, room_id, start_time, end_time, status) " +
                     "VALUES (?, ?, ?, ?, 'ACTIVE')";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, roomId);
            ps.setTimestamp(3, start);
            ps.setTimestamp(4, end);
            return ps.executeUpdate() == 1;
        }
    }

    // Get all user reservations
    public static List<Reservation> getUserReservations(int userId) throws Exception {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT * FROM reservations WHERE user_id = ? ORDER BY start_time DESC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Reservation r = new Reservation();
                r.setId(rs.getInt("id"));
                r.setUserId(rs.getInt("user_id"));
                r.setRoomId(rs.getInt("room_id"));
                r.setStartTime(rs.getTimestamp("start_time"));
                r.setEndTime(rs.getTimestamp("end_time"));
                r.setStatus(rs.getString("status"));
                list.add(r);
            }
        }
        return list;
    }

    // Cancel reservation
    public static boolean cancelReservation(int reservationId, int userId) throws Exception {
        String sql = "UPDATE reservations SET status = 'CANCELLED' WHERE id = ? AND user_id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, reservationId);
            ps.setInt(2, userId);
            return ps.executeUpdate() == 1;
        }
    }
}