<link rel="stylesheet" href="css/style.css">

<div class="container">
  <h2>Reserve Room</h2>

  <form method="post" action="reserve" class="card">
    <input type="hidden" name="roomId" value="${roomId}">

    <label>Start</label><br>
    <input type="datetime-local" name="start"><br><br>

    <label>End</label><br>
    <input type="datetime-local" name="end"><br><br>

    <button class="btn">Confirm Reservation</button>
  </form>

  <p style="color:red">${error}</p>
  <p style="color:green">${success}</p>
</div>
