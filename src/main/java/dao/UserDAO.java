package dao;

import java.sql.*;
import model.User;
import utils.DBConnection;
import java.security.MessageDigest;
import java.util.Base64;

public class UserDAO {

    // Hash password using SHA-256 with Base64 encoding
    private static String hashPassword(String password) throws Exception {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hash = md.digest(password.getBytes());
        return Base64.getEncoder().encodeToString(hash);
    }

    // Register user with hashed password
    public static boolean register(String name, String email, String password) throws Exception {
        // Check if email already exists
        String checkSql = "SELECT id FROM users WHERE email = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(checkSql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                System.out.println("DEBUG: Email already exists: " + email);
                return false; // Email already exists
            }
        }

        String sql = "INSERT INTO users(name, email, password, role) VALUES (?, ?, ?, 'USER')";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            String hashedPwd = hashPassword(password);
            System.out.println("DEBUG: Registering user " + email + " with hash: " + hashedPwd);
            
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, hashedPwd);
            return ps.executeUpdate() == 1;
        }
    }

    // Login with hashed password comparison
    public static User login(String email, String password) throws Exception {
        System.out.println("DEBUG UserDAO: Looking for user: " + email);
        
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                System.out.println("DEBUG UserDAO: User found in database");
                
                String storedHash = rs.getString("password");
                String inputHash = hashPassword(password);
                
                System.out.println("DEBUG UserDAO: Stored hash: " + storedHash);
                System.out.println("DEBUG UserDAO: Input hash:  " + inputHash);
                System.out.println("DEBUG UserDAO: Hashes match: " + storedHash.equals(inputHash));
                
                if (storedHash.equals(inputHash)) {
                    System.out.println("DEBUG UserDAO: Password match! Creating user object");
                    User u = new User();
                    u.setId(rs.getInt("id"));
                    u.setName(rs.getString("name"));
                    u.setEmail(rs.getString("email"));
                    u.setRole(rs.getString("role"));
                    System.out.println("DEBUG UserDAO: User object created with role: " + u.getRole());
                    return u;
                } else {
                    System.out.println("DEBUG UserDAO: Password mismatch!");
                }
            } else {
                System.out.println("DEBUG UserDAO: User NOT found in database");
            }
        }
        return null;
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
}