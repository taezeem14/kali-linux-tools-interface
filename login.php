<!DOCTYPE html>
<html lang="en">
<head>
  <title>Kali Tools Interface - Login</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="SSH Login - Kali Linux Tools Interface">
  
  <!-- Bootstrap CSS -->
  <link rel="stylesheet" href="assets/css/bootstrap.min.css">
  <link rel="icon" href="assets/img/logo.png" type="image/png">
  
  <!-- Fonts -->
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  
  <!-- Icons -->
  <link href="assets/vendor/nucleo/css/nucleo.css" rel="stylesheet">
  <link href="assets/vendor/@fortawesome/fontawesome-free/css/all.min.css" rel="stylesheet">
</head>
<body>

  <div class="container">
    <div class="row">
      <div class="col-sm-9 col-md-7 col-lg-5 mx-auto">
        <div class="card card-signin my-5">
          <div class="card-body">
            <h5 class="card-title text-center">Connect via SSH</h5>
            <p class="text-center text-muted small">Authenticate to your Kali Linux host</p>
            <p class="text-center">
            	<img src="assets/img/logo.png" width="80px" alt="Kali Tools">
            </p>
            
            <form class="form-signin" method="post" action="login-validation.php">
              <div class="form-label-group">
                <input type="text" name="host" id="host" class="form-control" placeholder="Hostname / IP" required autofocus>
                <label for="host">Hostname / IP Address</label>
              </div>

              <div class="form-label-group">
                <input type="number" name="port" id="port" class="form-control" placeholder="22" value="22" min="1" max="65535">
                <label for="port">SSH Port (default: 22)</label>
              </div>

			  <div class="form-label-group">
                <input type="text" name="user" id="user" class="form-control" placeholder="Username" required>
                <label for="user">Username</label>
              </div>

              <div class="form-label-group">
                <input type="password" name="password" id="password" class="form-control" placeholder="Password" required>
                <label for="password">Password</label>
              </div>


              <button class="btn btn-lg btn-danger btn-block text-uppercase" type="submit"><i class="fas fa-terminal"></i> Connect</button>
              <hr class="my-4">
              <p class="text-center text-muted small">
                Kali Tools Interface v3.0 &middot; Requires SSH service on target
              </p>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>

<!-- Core JS -->
<script src="assets/vendor/jquery/dist/jquery.min.js"></script>
<script src="assets/vendor/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>


<style type="text/css">
:root {
  --input-padding-x: 1.5rem;
  --input-padding-y: .75rem;
}

body {
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
  min-height: 100vh;
  font-family: 'Inter', sans-serif;
}

.card-signin {
  border: 0;
  border-radius: 1rem;
  box-shadow: 0 1rem 3rem rgba(0, 0, 0, 0.3);
  backdrop-filter: blur(10px);
  background: rgba(255,255,255,0.95);
}

.card-signin .card-title {
  margin-bottom: 1rem;
  font-weight: 600;
  font-size: 1.4rem;
  color: #1a1a2e;
}

.card-signin .card-body {
  padding: 2.5rem;
}

.form-signin {
  width: 100%;
}

.form-signin .btn {
  font-size: 80%;
  border-radius: 5rem;
  letter-spacing: .1rem;
  font-weight: bold;
  padding: 1rem;
  transition: all 0.3s;
  background: linear-gradient(135deg, #e94560, #c23152);
  border: none;
}

.form-signin .btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 5px 20px rgba(233, 69, 96, 0.4);
}

.form-label-group {
  position: relative;
  margin-bottom: 1rem;
}

.form-label-group input {
  height: auto;
  border-radius: 2rem;
}

.form-label-group>input,
.form-label-group>label {
  padding: var(--input-padding-y) var(--input-padding-x);
}

.form-label-group>label {
  position: absolute;
  top: 0;
  left: 0;
  display: block;
  width: 100%;
  margin-bottom: 0;
  line-height: 1.5;
  color: #495057;
  border: 1px solid transparent;
  border-radius: .25rem;
  transition: all .1s ease-in-out;
}

.form-label-group input::-webkit-input-placeholder { color: transparent; }
.form-label-group input:-ms-input-placeholder { color: transparent; }
.form-label-group input::-ms-input-placeholder { color: transparent; }
.form-label-group input::-moz-placeholder { color: transparent; }
.form-label-group input::placeholder { color: transparent; }

.form-label-group input:not(:placeholder-shown) {
  padding-top: calc(var(--input-padding-y) + var(--input-padding-y) * (2 / 3));
  padding-bottom: calc(var(--input-padding-y) / 3);
}

.form-label-group input:not(:placeholder-shown)~label {
  padding-top: calc(var(--input-padding-y) / 3);
  padding-bottom: calc(var(--input-padding-y) / 3);
  font-size: 12px;
  color: #777;
}
</style>