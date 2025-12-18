package dao;

import java.sql.*;
import java.util.*;
import model.Room;
import model.Reservation;
import model.User;
import utils.DBConnection;

public class AdminDAO {

    // Get all rooms
    public static List<Room> getAllRooms() throws Exception {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT * FROM rooms ORDER BY name";
        try (Connection c = DBConnection.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Room r = new Room();
                r.setId(rs.getInt("id"));
                r.setName(rs.getString("name"));
                r.setCapacity(rs.getInt("capacity"));
                r.setLocation(rs.getString("location"));
                r.setAvailable(rs.getInt("available"));
                list.add(r);
            }
        }
        return list;
    }

    // Add new room
    public static boolean addRoom(String name, int capacity, String location) throws Exception {
        if (name == null || name.trim().isEmpty() || capacity <= 0) {
            return false;
        }

        String sql = "INSERT INTO rooms(name, capacity, location, available) VALUES (?, ?, ?, 1)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, name.trim());
            ps.setInt(2, capacity);
            ps.setString(3, location != null ? location.trim() : "");
            return ps.executeUpdate() == 1;
        }
    }

    // Toggle room availability
    public static boolean toggleRoom(int roomId) throws Exception {
        String sql = "UPDATE rooms SET available = NOT available WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            return ps.executeUpdate() == 1;
        }
    }

    // Delete room - also cancels active reservations
    public static boolean deleteRoom(int roomId) throws Exception {
        try (Connection c = DBConnection.getConnection()) {
            // First, cancel all active reservations for this room
            String cancelSql = "UPDATE reservations SET status = 'CANCELLED' WHERE room_id = ? AND status = 'ACTIVE'";
            PreparedStatement ps1 = c.prepareStatement(cancelSql);
            ps1.setInt(1, roomId);
            ps1.executeUpdate();
            ps1.close();

            // Then delete the room
            String deleteSql = "DELETE FROM rooms WHERE id = ?";
            PreparedStatement ps2 = c.prepareStatement(deleteSql);
            ps2.setInt(1, roomId);
            return ps2.executeUpdate() == 1;
        }
    }

    // Get all reservations
    public static List<Reservation> getAllReservations() throws Exception {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT * FROM reservations ORDER BY start_time DESC";
        try (Connection c = DBConnection.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
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

    // Get user by ID
    public static User getUserById(int id) throws Exception {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setName(rs.getString("name"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getString("role"));
                return u;
            }
        }
        return null;
    }

    // Get room by ID
    public static Room getRoomById(int id) throws Exception {
        String sql = "SELECT * FROM rooms WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Room r = new Room();
                r.setId(rs.getInt("id"));
                r.setName(rs.getString("name"));
                r.setCapacity(rs.getInt("capacity"));
                r.setLocation(rs.getString("location"));
                r.setAvailable(rs.getInt("available"));
                return r;
            }
        }
        return null;
    }

    // Get statistics
    public static Map<String, Integer> getStatistics() throws Exception {
        Map<String, Integer> stats = new HashMap<>();

        try (Connection c = DBConnection.getConnection()) {
            // Total rooms
            String sql1 = "SELECT COUNT(*) FROM rooms";
            Statement st1 = c.createStatement();
            ResultSet rs1 = st1.executeQuery(sql1);
            rs1.next();
            stats.put("totalRooms", rs1.getInt(1));

            // Available rooms
            String sql2 = "SELECT COUNT(*) FROM rooms WHERE available = 1";
            Statement st2 = c.createStatement();
            ResultSet rs2 = st2.executeQuery(sql2);
            rs2.next();
            stats.put("availableRooms", rs2.getInt(1));

            // Active reservations
            String sql3 = "SELECT COUNT(*) FROM reservations WHERE status = 'ACTIVE'";
            Statement st3 = c.createStatement();
            ResultSet rs3 = st3.executeQuery(sql3);
            rs3.next();
            stats.put("activeReservations", rs3.getInt(1));

            // Total users
            String sql4 = "SELECT COUNT(*) FROM users";
            Statement st4 = c.createStatement();
            ResultSet rs4 = st4.executeQuery(sql4);
            rs4.next();
            stats.put("totalUsers", rs4.getInt(1));
        }
        return stats;
    }
}