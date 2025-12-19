# 🏢 Workspace Reservation System

A professional workspace and meeting room reservation system built with **Jakarta EE (J2EE)** technology. This application enables users to book workspaces, meeting rooms, and focus pods while providing administrators with comprehensive room management and reservation oversight capabilities.

## 📺 Demo Video

[**Watch the Full Demo on YouTube**](YOUR_YOUTUBE_LINK_HERE)

---

## 📋 Table of Contents

- [Features](#-features)
- [Technology Stack](#-technology-stack)
- [Project Architecture](#-project-architecture)
- [Database Schema](#-database-schema)
- [Prerequisites](#-prerequisites)
- [Installation & Setup](#-installation--setup)
- [Configuration](#-configuration)
- [Running the Application](#-running-the-application)
- [Usage Guide](#-usage-guide)
- [API Endpoints](#-api-endpoints)
- [Security Features](#-security-features)
- [Project Structure](#-project-structure)
- [Contributing](#-contributing)
- [License](#-license)

---

## ✨ Features

### 👤 User Features
- **User Authentication**: Secure registration and login with SHA-256 password hashing
- **Browse Workspaces**: View all available rooms with real-time status
- **Smart Booking**: Reserve rooms with conflict detection and validation
- **My Reservations**: View and manage personal bookings
- **Availability Checks**: Prevent double-booking for both users and rooms
- **Responsive Design**: Seamless experience across all devices

### 🛡️ Admin Features
- **Dashboard Overview**: Real-time statistics on rooms, users, and reservations
- **Room Management**: Add, edit, enable/disable, and delete workspace rooms
- **Reservation Oversight**: Monitor all system reservations
- **User Management**: View registered users and their activities
- **Status Control**: Toggle room availability instantly
- **Bulk Operations**: Manage multiple resources efficiently

### 🎯 Core Capabilities
- **Conflict Prevention**: Automatic detection of booking overlaps
- **Time Validation**: Minimum 30-minute booking requirement
- **Status Tracking**: ACTIVE, CANCELLED, COMPLETED reservation states
- **Real-time Updates**: Instant reflection of changes across the system
- **Data Integrity**: Transaction-safe database operations

---

## 🛠 Technology Stack

### Backend
- **Platform**: Jakarta EE (J2EE) / Java EE
- **Server**: Apache Tomcat 10.1 (or any Jakarta EE 9+ compatible server)
- **Servlets**: Jakarta Servlet 5.0
- **JSP**: Jakarta Server Pages
- **JDBC**: Direct database connectivity with MySQL

### Frontend
- **View Layer**: JSP (JavaServer Pages)
- **Styling**: Custom CSS3
- **JavaScript**: Vanilla JS for dynamic interactions

### Database
- **RDBMS**: MySQL 8.0+
- **Driver**: MySQL Connector/J 8.0+

### Security
- **Password Hashing**: SHA-256 with Base64 encoding
- **Session Management**: HttpSession-based authentication
- **Access Control**: Custom servlet filters (AuthFilter, AdminFilter)
- **Role-Based Authorization**: USER and ADMIN roles

### Build & Deployment
- **IDE**: Eclipse IDE for Enterprise Java and Web Developers
- **Project Type**: Dynamic Web Project
- **Deployment Format**: WAR (Web Application Archive)

---

## 🏗 Project Architecture

The application follows the **MVC (Model-View-Controller)** architectural pattern with clear separation of concerns:

### Model Layer
- `User.java` - User entity with authentication details
- `Room.java` - Workspace room entity
- `Reservation.java` - Booking entity with time slots

### View Layer (JSP)
- `index.jsp` - Landing page with workspace showcase
- `login.jsp` / `register.jsp` - Authentication pages
- `dashboard.jsp` - User dashboard
- `rooms.jsp` - Room browsing and booking
- `my-reservations.jsp` - User's booking history
- `admin/dashboard.jsp` - Admin control panel

### Controller Layer (Servlets)
- `LoginServlet` - Handles user authentication
- `RegisterServlet` - Manages user registration
- `LogoutServlet` - Session termination
- `RoomServlet` - Room listing
- `ReservationServlet` - Booking creation
- `CancelReservationServlet` - Booking cancellation
- `AdminServlet` - Admin operations

### Data Access Layer (DAO)
- `UserDAO` - User CRUD operations
- `RoomDAO` - Room queries
- `ReservationDAO` - Booking management with conflict checking
- `AdminDAO` - Administrative operations and statistics

### Utility Layer
- `DBConnection` - Database connection management

### Security Layer (Filters)
- `AuthFilter` - Protects authenticated routes
- `AdminFilter` - Restricts admin-only resources

---

## 🗄 Database Schema

### Database: `workspace_reservation_db`

#### 📊 Tables Overview

| Table | Purpose | Key Relationships |
|-------|---------|-------------------|
| `users` | User accounts & authentication | Primary in reservations FK |
| `rooms` | Workspace definitions | Primary in reservations FK |
| `reservations` | Booking records | References users & rooms |

#### Table: `users`
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | INT | PRIMARY KEY, AUTO_INCREMENT | Unique user identifier |
| `name` | VARCHAR(100) | NOT NULL | User's full name |
| `email` | VARCHAR(255) | NOT NULL, UNIQUE | Login email (unique) |
| `password` | VARCHAR(255) | NOT NULL | SHA-256 hashed password |
| `role` | ENUM('USER','ADMIN') | NOT NULL, DEFAULT 'USER' | Access level |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Registration date |

#### Table: `rooms`
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | INT | PRIMARY KEY, AUTO_INCREMENT | Unique room identifier |
| `name` | VARCHAR(100) | NOT NULL | Room name/identifier |
| `capacity` | INT | NOT NULL | Maximum occupancy |
| `location` | VARCHAR(100) | NOT NULL | Physical location |
| `available` | TINYINT(1) | NOT NULL, DEFAULT 1 | 1=available, 0=disabled |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Creation timestamp |

#### Table: `reservations`
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | INT | PRIMARY KEY, AUTO_INCREMENT | Unique reservation ID |
| `user_id` | INT | NOT NULL, FK→users(id) | Booking user |
| `room_id` | INT | NOT NULL, FK→rooms(id) | Reserved room |
| `start_time` | DATETIME | NOT NULL | Reservation start |
| `end_time` | DATETIME | NOT NULL | Reservation end |
| `status` | ENUM('ACTIVE','CANCELLED','COMPLETED') | NOT NULL, DEFAULT 'ACTIVE' | Booking status |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Booking timestamp |

**Status Definitions:**
- `ACTIVE` - Current or upcoming reservation
- `CANCELLED` - User/admin cancelled
- `COMPLETED` - Past reservation

---

## 📥 Prerequisites

Before installation, ensure you have:

1. **Java Development Kit (JDK)**
   - Version: JDK 11 or higher
   - Download: [Oracle JDK](https://www.oracle.com/java/technologies/downloads/) or [OpenJDK](https://adoptium.net/)

2. **Apache Tomcat**
   - Version: 10.1 (Jakarta EE 9+)
   - Download: [Apache Tomcat](https://tomcat.apache.org/download-10.cgi)

3. **MySQL Server**
   - Version: 8.0 or higher
   - Download: [MySQL Community Server](https://dev.mysql.com/downloads/mysql/)

4. **Eclipse IDE** (Recommended)
   - Edition: Eclipse IDE for Enterprise Java and Web Developers
   - Download: [Eclipse IDE](https://www.eclipse.org/downloads/)

5. **MySQL Connector/J**
   - Version: 8.0.x
   - Download: [MySQL Connector](https://dev.mysql.com/downloads/connector/j/)
   - Add to project's `WEB-INF/lib` folder

---

## 🚀 Installation & Setup

### Step 1: Clone the Repository

```bash
git clone https://github.com/mohamedkrouf/Workspace_Reservation_System.git
cd Workspace_Reservation_System
```

### Step 2: Database Setup

1. **Start MySQL Server**
   ```bash
   # On Windows (if MySQL is in PATH)
   mysql -u root -p
   
   # Or use MySQL Workbench GUI
   ```

2. **Execute the Setup SQL**
   
   Locate the `database_setup.sql` file in the repository and execute it:
   
   ```sql
   -- In MySQL command line or Workbench
   source /path/to/database_setup.sql;
   
   -- Or copy-paste the contents directly
   ```

   This will:
   - Create the `workspace_reservation_db` database
   - Create all three tables (`users`, `rooms`, `reservations`)
   - Insert sample rooms
   - Create default admin and user accounts

### Step 3: Configure Database Connection

Edit `src/main/java/utils/DBConnection.java`:

```java
private static final String URL = 
    "jdbc:mysql://localhost:3306/workspace_reservation_db" +
    "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
private static final String USER = "root";
private static final String PASSWORD = "your_mysql_password";
```

**⚠️ Important**: Update `USER` and `PASSWORD` with your MySQL credentials.

### Step 4: Import Project to Eclipse

1. Open Eclipse IDE
2. Go to `File` → `Import` → `Existing Projects into Workspace`
3. Select the cloned repository folder
4. Click `Finish`

### Step 5: Add MySQL Connector Library

1. Download [MySQL Connector/J](https://dev.mysql.com/downloads/connector/j/)
2. Copy `mysql-connector-j-x.x.x.jar` to `WebContent/WEB-INF/lib/`
3. Right-click project → `Build Path` → `Configure Build Path`
4. Add the JAR to Libraries

### Step 6: Configure Tomcat Server

1. In Eclipse, go to `Window` → `Preferences` → `Server` → `Runtime Environments`
2. Click `Add` → Select `Apache Tomcat v10.x`
3. Browse to your Tomcat installation directory
4. Click `Finish`

---

## ⚙ Configuration

### Web Application Descriptor (`web.xml`)

The application uses a hybrid configuration approach:
- Servlets use `@WebServlet` annotations (Servlet 3.0+)
- Filters are configured in `web.xml`

```xml
<!-- AuthFilter protects authenticated pages -->
<filter-mapping>
    <filter-name>AuthFilter</filter-name>
    <url-pattern>/dashboard.jsp</url-pattern>
</filter-mapping>

<!-- AdminFilter restricts admin access -->
<filter-mapping>
    <filter-name>AdminFilter</filter-name>
    <url-pattern>/admin</url-pattern>
</filter-mapping>
```

### Default Credentials

**Admin Account:**
- Email: `admin@workspace.com`
- Password: `admin123`

**Regular User:**
- Email: `mohamedkrouf@gmail.com`
- Password: `user123`

**🔒 Security Note**: Change these passwords immediately after first login!

---

## 🎮 Running the Application

### Method 1: Eclipse (Recommended)

1. Right-click the project in Eclipse
2. Select `Run As` → `Run on Server`
3. Choose your configured Tomcat server
4. Click `Finish`

The application will open at: `http://localhost:8080/Workspace_Reservation_System/`

### Method 2: Manual Deployment

1. **Build WAR file**:
   - Right-click project → `Export` → `WAR file`
   - Save as `Workspace_Reservation_System.war`

2. **Deploy to Tomcat**:
   ```bash
   cp Workspace_Reservation_System.war /path/to/tomcat/webapps/
   ```

3. **Start Tomcat**:
   ```bash
   cd /path/to/tomcat/bin
   ./startup.sh   # Linux/Mac
   startup.bat    # Windows
   ```

4. **Access**: `http://localhost:8080/Workspace_Reservation_System/`

---

## 📖 Usage Guide

### For Regular Users

1. **Registration**
   - Navigate to the landing page
   - Click "Sign Up"
   - Fill in name, email, and password (min 6 characters)
   - Submit to create account

2. **Login**
   - Click "Sign In"
   - Enter email and password
   - Redirects to user dashboard upon success

3. **Browse Rooms**
   - Click "Rooms" in navigation
   - View available workspaces with capacity and location
   - See real-time availability status

4. **Make a Reservation**
   - Select desired room
   - Choose start and end time (min 30 minutes)
   - Click "Reserve"
   - System validates availability and prevents conflicts

5. **Manage Reservations**
   - Go to "My Reservations"
   - View all your bookings (ACTIVE, CANCELLED, COMPLETED)
   - Cancel upcoming reservations if needed

### For Administrators

1. **Access Admin Dashboard**
   - Login with admin credentials
   - Automatically redirected to `/admin`

2. **View Statistics**
   - Dashboard shows:
     - Total Rooms
     - Available Rooms
     - Active Reservations
     - Registered Users

3. **Manage Rooms**
   - **Add Room**: Fill form with name, capacity, location
   - **Toggle Status**: Enable/Disable room availability
   - **Delete Room**: Remove room (cancels active reservations)

4. **Monitor Reservations**
   - Switch to "Reservations" tab
   - View all system bookings
   - See user ID, room ID, times, and status

---

## 🔌 API Endpoints (Servlets)

### Authentication
| Endpoint | Method | Description | Access |
|----------|--------|-------------|--------|
| `/register` | POST | User registration | Public |
| `/login` | POST | User authentication | Public |
| `/logout` | GET | End session | Authenticated |

### Rooms
| Endpoint | Method | Description | Access |
|----------|--------|-------------|--------|
| `/rooms` | GET | List available rooms | Authenticated |

### Reservations
| Endpoint | Method | Description | Access |
|----------|--------|-------------|--------|
| `/reserve` | POST | Create reservation | Authenticated |
| `/cancel-reservation` | POST | Cancel booking | Authenticated |

### Admin Operations
| Endpoint | Method | Description | Access |
|----------|--------|-------------|--------|
| `/admin` | GET | Admin dashboard | Admin Only |
| `/admin` | POST | Room operations (add/toggle/delete) | Admin Only |

---

## 🔒 Security Features

### Authentication & Authorization
- **SHA-256 Password Hashing**: All passwords stored as hashed values
- **Base64 Encoding**: Hash representation for database storage
- **Session Management**: HttpSession tracks authenticated users
- **Role-Based Access**: USER vs ADMIN privileges

### Servlet Filters
- **AuthFilter**: Protects authenticated routes (dashboard, rooms, reservations)
- **AdminFilter**: Restricts admin routes to ADMIN role only

### Data Validation
- **Input Sanitization**: All user inputs trimmed and validated
- **Time Logic Checks**: Start < End, minimum duration enforcement
- **Conflict Detection**: Prevents double-booking for rooms and users
- **SQL Injection Prevention**: PreparedStatements throughout

### Session Security
- **Session Timeout**: Automatic session expiration
- **Session Invalidation**: Proper cleanup on logout
- **Attribute Protection**: Sensitive data in session attributes

---

## 📁 Project Structure

```
Workspace_Reservation_System/
├── src/
│   └── main/
│       └── java/
│           ├── controller/
│           │   ├── AdminServlet.java
│           │   ├── CancelReservationServlet.java
│           │   ├── LoginServlet.java
│           │   ├── LogoutServlet.java
│           │   ├── RegisterServlet.java
│           │   ├── ReservationServlet.java
│           │   └── RoomServlet.java
│           ├── dao/
│           │   ├── AdminDAO.java
│           │   ├── ReservationDAO.java
│           │   ├── RoomDAO.java
│           │   └── UserDAO.java
│           ├── filter/
│           │   ├── AdminFilter.java
│           │   └── AuthFilter.java
│           ├── model/
│           │   ├── Reservation.java
│           │   ├── Room.java
│           │   └── User.java
│           └── utils/
│               └── DBConnection.java
├── webapp/
│   ├── admin/
│   │   └── dashboard.jsp
│   ├── css/
│   │   └── style.css
│   ├── images/
│   │   ├── workspace.jpg
│   │   ├── science.jpg
│   │   ├── person1.jpg
│   │   └── person2.jpg
│   ├── WEB-INF/
│   │   ├── lib/
│   │   │   └── mysql-connector-j-x.x.x.jar
│   │   └── web.xml
│   ├── dashboard.jsp
│   ├── index.jsp
│   ├── login.jsp
│   ├── register.jsp
│   ├── rooms.jsp
│   └── my-reservations.jsp
├── database_setup.sql
└── README.md
```

---

## 🗺 Roadmap

- [ ] Email notifications for booking confirmations
- [ ] SMS reminders for upcoming reservations
- [ ] Calendar view for availability
- [ ] Export reservations to PDF/Excel
- [ ] Multi-language support (i18n)
- [ ] Mobile-responsive enhancements
- [ ] Room amenities and features
- [ ] Booking approval workflow
- [ ] Integration with Google Calendar
- [ ] Advanced analytics dashboard
- [ ] User profile management
- [ ] Room images gallery
- [ ] Recurring reservations
- [ ] Waitlist for fully booked rooms

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. **Fork** the repository
2. **Create** a feature branch
   ```bash
   git checkout -b feature/AmazingFeature
   ```
3. **Commit** your changes
   ```bash
   git commit -m 'Add some AmazingFeature'
   ```
4. **Push** to the branch
   ```bash
   git push origin feature/AmazingFeature
   ```
5. **Open** a Pull Request

### Code Style Guidelines
- Follow Java naming conventions
- Use meaningful variable names
- Comment complex logic
- Write Javadoc for public methods
- Keep methods focused and concise

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 📧 Contact

**Mohamed Krouf**

- **GitHub**: [@mohamedkrouf](https://github.com/mohamedkrouf)
- **Email**: mohamed.krouf@isimg.tn

---

## 🐛 Troubleshooting

### Common Issues

**Issue**: `ClassNotFoundException: com.mysql.cj.jdbc.Driver`
- **Solution**: Ensure MySQL Connector/J is in `WEB-INF/lib/`

**Issue**: `Access denied for user 'root'@'localhost'`
- **Solution**: Check MySQL credentials in `DBConnection.java`

**Issue**: `404 Error when accessing /admin`
- **Solution**: Ensure you're logged in with ADMIN role

**Issue**: Password doesn't work after registration
- **Solution**: Verify password hashing is consistent in `UserDAO` and `LoginServlet`

**Issue**: Session lost after restart
- **Solution**: This is normal - sessions are not persisted across server restarts

---

**Made with ❤️ by Krouf Mohamed**

*Last Updated: 19 December 2024*
