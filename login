<?php
// Start the session
session_start();

$servername = "localhost";
$username = "";
$password = "";
$database = "";

$con = mysqli_connect($servername, $username, $password, $database);

if (!$con) {
    die("Can't Connect to database" . mysqli_connect_error());
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $email = trim($_POST["email"]);
    $rawPassword = trim($_POST["password"]);

    $query = "SELECT * FROM table-name WHERE email = ? AND status = 'verified'";
    $stmt = mysqli_prepare($con, $query);
    mysqli_stmt_bind_param($stmt, "s", $email);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);

    if ($result) {
        $rows = mysqli_num_rows($result);

        if ($rows > 0) {
            $freelancerData = mysqli_fetch_assoc($result);
            // Verify the password using password_verify
            if (password_verify($rawPassword, $freelancerData['password'])) {
                // Set the session variable
                $_SESSION["email"] = $email;
            
                // Redirect to dashboard.php
                header("Location: update-form-data.php");
                exit();
            } else {
               echo '<script> alert("Your password has been Invalid. ' . $rawPassword . '");</script>';
            }
        } else {
            echo '<script> alert("You will be able to login to the after your status is verified.");</script>';
        }
    } else {
        $error_message = "Query failed: " . mysqli_error($con);
    }
}

mysqli_close($con);
?>

                      <form action="freelancer-apply" method="post">
                        <p>Login</p> 
                        <input type="email" placeholder="Enter Email" name="email" required> 
                        <input type="password" placeholder="Enter Password" name="password" id="password" required> 
                        <span id="toggleBtn" onclick="togglePassword()">🙈️</span>
                        <div class="popup-btn">
                            <button type="submit" class="outer-shadow hover-in-shadow">Login</button> 
                            <button type="button" onclick="closeForm()" class="outer-shadow hover-in-shadow">Close</button>
                        </div>
                      </form> 

<script>
function togglePassword() {
    var passwordField = document.getElementById("password");
    var toggleButton = document.getElementById("toggleBtn");

    if (passwordField.type === "password") {
      passwordField.type = "text";
      toggleButton.textContent = "🙊️"; // Show password icon
    } else {
      passwordField.type = "password";
      toggleButton.textContent = "🙈️"; // Hide password icon
    }
  }


function openForm() {
  document.getElementById("myForm").style.display = "block";
}

function closeForm() {
  document.getElementById("myForm").style.display = "none";
}
</script>
