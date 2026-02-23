<!DOCTYPE html>
<html>
  <?php 
  	include("assets/includes/head.php"); 
  ?>
<body>
	<?php
		include("assets/includes/header.php")
	?>

	<!-- Page content -->
    <div class="container-fluid mt--7">
      <!-- Table -->
      <div class="row">
        <div class="col">
          	<div class="card shadow">
	            <div class="card-header bg-transparent">
	              <h2 class="mb-0"><i class="fas fa-server"></i> System Administration</h2>
	            </div>
            	
            	<div class="card-body">
            		<div class="row">

            		<div class="col-sm-12 col-md-6 col-lg-4">
						<div class='card zoom-effect border-primary mb-3'>
						  <div class="card-body">
						  	<h5 class="card-title text-primary"><i class="fas fa-users"></i> Users & Groups</h5>
						    <p class="card-text">Manage system users and groups on this Kali Linux host.</p>
						    <span class="badge badge-info">System</span>
						  </div>
						</div>
					</div>

					<div class="col-sm-12 col-md-6 col-lg-4">
						<div class='card zoom-effect border-success mb-3'>
						  <div class="card-body">
						  	<h5 class="card-title text-success"><i class="fas fa-database"></i> MariaDB Status</h5>
						    <p class="card-text">Check MariaDB service status and database connections.</p>
						    <span class="badge badge-success">Database</span>
						  </div>
						</div>
					</div>

					<div class="col-sm-12 col-md-6 col-lg-4">
						<div class='card zoom-effect border-warning mb-3'>
						  <div class="card-body">
						  	<h5 class="card-title text-warning"><i class="fas fa-shield-alt"></i> SSH Service</h5>
						    <p class="card-text">Monitor SSH service and active connections to the host.</p>
						    <span class="badge badge-warning">Network</span>
						  </div>
						</div>
					</div>

					</div>
				</div>
			</div>
	<?php
		include("assets/includes/footer.php")
	?>
</body>
</html>