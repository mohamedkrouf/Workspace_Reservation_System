package dao;

import java.sql.*;
import java.util.*;
import model.Room;
import utils.DBConnection;

public class RoomDAO {

    // Get all available rooms
    public static List<Room> getAllRooms() throws Exception {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT * FROM rooms WHERE available = 1 ORDER BY name";
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

    // Get room by ID
    public static Room getRoomById(int id) throws Exception {
        String sql = "SELECT * FROM rooms WHERE id = ? AND available = 1";
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

    // Get available rooms by capacity
    public static List<Room> getRoomsByCapacity(int minCapacity) throws Exception {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT * FROM rooms WHERE available = 1 AND capacity >= ? ORDER BY capacity";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, minCapacity);
            ResultSet rs = ps.executeQuery();
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
}