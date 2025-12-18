<%@ page import="java.util.List" %>
<%@ page import="model.Reservation" %>

<h2>All Reservations</h2>

<%
    List<Reservation> res =
        (List<Reservation>) request.getAttribute("reservations");
%>

<table border="1" cellpadding="10">
    <tr>
        <th>User ID</th>
        <th>Room ID</th>
        <th>Start</th>
        <th>End</th>
        <th>Status</th>
    </tr>

<% for (Reservation r : res) { %>
    <tr>
        <td><%= r.getUserId() %></td>
        <td><%= r.getRoomId() %></td>
        <td><%= r.getStartTime() %></td>
        <td><%= r.getEndTime() %></td>
        <td><%= r.getStatus() %></td>
    </tr>
<% } %>

</table>
