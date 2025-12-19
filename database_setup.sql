-- ============================================================================
-- WORKSPACE RESERVATION SYSTEM - DATABASE SETUP
-- ============================================================================
-- This script creates the complete database schema and inserts sample data
-- Execute this script in MySQL Workbench or MySQL command line
-- Author: Mohamed Krouf
-- Last Updated: December 2024
-- ============================================================================

-- ============================================================================
-- STEP 1: CREATE DATABASE
-- ============================================================================

-- Drop database if it exists (WARNING: This will delete all existing data!)
DROP DATABASE IF EXISTS workspace_reservation_db;

-- Create new database
CREATE DATABASE workspace_reservation_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

-- Select the database
USE workspace_reservation_db;

-- ============================================================================
-- STEP 2: CREATE TABLES
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Table: users
-- Purpose: Store user accounts and authentication information
-- ----------------------------------------------------------------------------
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Unique user identifier',
    name VARCHAR(100) NOT NULL COMMENT 'User full name',
    email VARCHAR(255) NOT NULL UNIQUE COMMENT 'Login email (must be unique)',
    password VARCHAR(255) NOT NULL COMMENT 'SHA-256 hashed password with Base64 encoding',
    role ENUM('USER', 'ADMIN') NOT NULL DEFAULT 'USER' COMMENT 'User access level',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Account creation timestamp',
    INDEX idx_email (email),
    INDEX idx_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='User accounts and authentication data';

-- ----------------------------------------------------------------------------
-- Table: rooms
-- Purpose: Store workspace room information
-- ----------------------------------------------------------------------------
CREATE TABLE rooms (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Unique room identifier',
    name VARCHAR(100) NOT NULL COMMENT 'Room name or identifier',
    capacity INT NOT NULL COMMENT 'Maximum number of people',
    location VARCHAR(100) NOT NULL COMMENT 'Physical location (floor, building, etc.)',
    available TINYINT(1) NOT NULL DEFAULT 1 COMMENT 'Availability status: 1=available, 0=disabled',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Room creation timestamp',
    INDEX idx_available (available),
    INDEX idx_capacity (capacity),
    CHECK (capacity > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Workspace rooms and their properties';

-- ----------------------------------------------------------------------------
-- Table: reservations
-- Purpose: Store booking information linking users to rooms
-- ----------------------------------------------------------------------------
CREATE TABLE reservations (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Unique reservation identifier',
    user_id INT NOT NULL COMMENT 'User who made the reservation',
    room_id INT NOT NULL COMMENT 'Reserved room',
    start_time DATETIME NOT NULL COMMENT 'Reservation start time',
    end_time DATETIME NOT NULL COMMENT 'Reservation end time',
    status ENUM('ACTIVE', 'CANCELLED', 'COMPLETED') NOT NULL DEFAULT 'ACTIVE' 
        COMMENT 'Reservation status: ACTIVE=current/upcoming, CANCELLED=cancelled, COMPLETED=past',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Booking creation timestamp',
    
    -- Foreign key constraints
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE ON UPDATE CASCADE,
    
    -- Indexes for performance
    INDEX idx_user_id (user_id),
    INDEX idx_room_id (room_id),
    INDEX idx_start_time (start_time),
    INDEX idx_end_time (end_time),
    INDEX idx_status (status),
    INDEX idx_room_time (room_id, start_time, end_time),
    
    -- Constraints
    CHECK (end_time > start_time),
    CHECK (TIMESTAMPDIFF(MINUTE, start_time, end_time) >= 30)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Room reservations linking users to rooms with time slots';

-- ============================================================================
-- STEP 3: INSERT SAMPLE DATA
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Insert Sample Users
-- ----------------------------------------------------------------------------
-- Note: Passwords are hashed using SHA-256 with Base64 encoding
-- Admin password: "admin123" -> hash: "JAviGq93yTdvBO6x2ilRI1+gxwlyPqCKAn3T..."
-- User password: "user123" -> hash: "6ZyNa6nq9Jkr1JHMhOCuRcCL1q6Aod1UKCjKa62..."

INSERT INTO users (name, email, password, role) VALUES
-- Admin Account (Email: admin@workspace.com, Password: admin123)
('Admin User', 'admin@workspace.com', 'JAviGq93yTdvBO6x2ilRI1+gxwlyPqCKAn3TvhCe91M=', 'ADMIN'),

-- Regular User Account (Email: mohamedkrouf@gmail.com, Password: user123)
('Mohamed Krouf', 'mohamedkrouf@gmail.com', '6ZyNa6nq9JkrUJHMhOCuRcCL1q6Aod1UKCjKa62BDtw=', 'USER');

-- ----------------------------------------------------------------------------
-- Insert Sample Rooms
-- ----------------------------------------------------------------------------
INSERT INTO rooms (name, capacity, location, available) VALUES
('Focus Pod A', 2, 'Floor 1', 1),
('Focus Pod B', 2, 'Floor 1', 1),
('Meeting Room 101', 6, 'Floor 1', 1),
('Meeting Room 202', 10, 'Floor 2', 1),
('Executive Suite', 15, 'Floor 2', 1),
('Creative Studio', 8, 'Floor 2', 1),
('Meeting Room 102', 10, 'Floor 3', 1);

-- ----------------------------------------------------------------------------
-- Insert Sample Reservations (Optional - for testing)
-- ----------------------------------------------------------------------------
-- These are example reservations - adjust dates as needed for testing

INSERT INTO reservations (user_id, room_id, start_time, end_time, status) VALUES
-- Active reservation by user Mohamed Krouf (user_id=2)
(2, 1, '2025-12-20 14:00:00', '2025-12-20 16:00:00', 'ACTIVE'),

-- Completed reservation
(2, 3, '2025-12-18 10:00:00', '2025-12-18 12:00:00', 'COMPLETED'),

-- Cancelled reservation
(2, 6, '2025-12-18 18:40:00', '2025-12-18 19:40:00', 'CANCELLED');

-- ============================================================================
-- STEP 4: VERIFICATION QUERIES
-- ============================================================================
-- Run these queries to verify the setup was successful

-- Check users table
SELECT 'Users Table' AS verification;
SELECT id, name, email, role, created_at FROM users;

-- Check rooms table
SELECT 'Rooms Table' AS verification;
SELECT id, name, capacity, location, available, created_at FROM rooms;

-- Check reservations table
SELECT 'Reservations Table' AS verification;
SELECT id, user_id, room_id, start_time, end_time, status, created_at FROM reservations;

-- Display statistics
SELECT 'Database Statistics' AS verification;
SELECT 
    (SELECT COUNT(*) FROM users) AS total_users,
    (SELECT COUNT(*) FROM users WHERE role = 'ADMIN') AS admin_users,
    (SELECT COUNT(*) FROM users WHERE role = 'USER') AS regular_users,
    (SELECT COUNT(*) FROM rooms) AS total_rooms,
    (SELECT COUNT(*) FROM rooms WHERE available = 1) AS available_rooms,
    (SELECT COUNT(*) FROM reservations) AS total_reservations,
    (SELECT COUNT(*) FROM reservations WHERE status = 'ACTIVE') AS active_reservations;

-- ============================================================================
-- SETUP COMPLETE!
-- ============================================================================

SELECT '============================================' AS message;
SELECT 'DATABASE SETUP COMPLETED SUCCESSFULLY!' AS message;
SELECT '============================================' AS message;
SELECT '' AS message;
SELECT 'Default Login Credentials:' AS message;
SELECT '' AS message;
SELECT '  ADMIN ACCOUNT' AS message;
SELECT '  Email: admin@workspace.com' AS message;
SELECT '  Password: admin123' AS message;
SELECT '' AS message;
SELECT '  USER ACCOUNT' AS message;
SELECT '  Email: mohamedkrouf@gmail.com' AS message;
SELECT '  Password: user123' AS message;
SELECT '' AS message;
SELECT '⚠️  IMPORTANT: Change these passwords immediately after first login!' AS message;
SELECT '============================================' AS message;

-- ============================================================================
-- NOTES:
-- ============================================================================
-- 1. The sample passwords in this script use placeholder hashes
--    In production, generate proper SHA-256 hashes using your application
-- 2. Adjust sample reservation dates in INSERT statements as needed
-- 3. Always backup your database before running this script on existing data
-- 4. All tables use InnoDB engine for transaction support and foreign keys
-- 5. Character set is utf8mb4 for full Unicode support including emojis
-- ============================================================================
