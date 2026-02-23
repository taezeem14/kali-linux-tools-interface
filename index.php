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
      <div class="row">
        <div class="col">
          	<div class="card shadow">
	            <div class="card-header bg-transparent">
	              <h2 class="mb-0"><i class="fas fa-tachometer-alt"></i> Dashboard</h2>
	            </div>

                <div class="card-body">
                	<div class="row">

                  <!-- Available Tools Card -->
                  <div class="col-xl-4 col-lg-6 mb-4">
                    <div class="card card-stats zoom-effect border-left border-success" style="border-left-width: 4px !important;">
                      <div class="card-body">
                        <div class="row">
                          <div class="col">
                            <h5 class="card-title text-uppercase text-muted mb-0">Available Tools</h5>
                            <span class="h2 font-weight-bold mb-0">
                            	<?php
                            		$con = getConnectionDB();
      					            $sql = $con->prepare("SELECT COUNT(*) as cnt FROM tools WHERE released = 'Yes'");
      					            $sql->execute();
      					            $row = $sql->fetch();
                            		echo $row['cnt'];
                            	?>
                            </span>
                          </div>
                          <div class="col-auto">
                            <div class="icon icon-shape bg-success text-white rounded-circle shadow">
                              <i class="ni ni-bullet-list-67"></i>
                            </div>
                          </div>
                        </div>
                        <div class="mt-3">
                          <a href="tools-list.php" class="btn btn-sm btn-success"><i class="fas fa-arrow-right"></i> View Tools</a>
                        </div>
                      </div>
                    </div>
                  </div>

                  <!-- Reports Card -->
                  <div class="col-xl-4 col-lg-6 mb-4">
                    <div class="card card-stats zoom-effect border-left border-warning" style="border-left-width: 4px !important;">
                      <div class="card-body">
                        <div class="row">
                          <div class="col">
                            <h5 class="card-title text-uppercase text-muted mb-0">Saved Reports</h5>
                            <span class="h2 font-weight-bold mb-0">
                              <?php
                                $sql = $con->prepare("SELECT COUNT(*) as cnt FROM reports");
                                $sql->execute();
                                $row = $sql->fetch();
                                echo $row['cnt'];
                              ?>
                            </span>
                          </div>
                          <div class="col-auto">
                            <div class="icon icon-shape bg-warning text-white rounded-circle shadow">
                              <i class="ni ni-single-copy-04"></i>
                            </div>
                          </div>
                        </div>
                        <div class="mt-3">
                          <a href="reports.php" class="btn btn-sm btn-warning"><i class="fas fa-arrow-right"></i> View Reports</a>
                        </div>
                      </div>
                    </div>
                  </div>

                  <!-- Total Tools Card -->
                  <div class="col-xl-4 col-lg-6 mb-4">
                    <div class="card card-stats zoom-effect border-left border-info" style="border-left-width: 4px !important;">
                      <div class="card-body">
                        <div class="row">
                          <div class="col">
                            <h5 class="card-title text-uppercase text-muted mb-0">All Tools</h5>
                            <span class="h2 font-weight-bold mb-0">
                              <?php
                                $sql = $con->prepare("SELECT COUNT(*) as cnt FROM tools");
                                $sql->execute();
                                $row = $sql->fetch();
                                echo $row['cnt'];
                              ?>
                            </span>
                          </div>
                          <div class="col-auto">
                            <div class="icon icon-shape bg-info text-white rounded-circle shadow">
                              <i class="fas fa-toolbox"></i>
                            </div>
                          </div>
                        </div>
                        <div class="mt-3">
                          <span class="text-muted text-sm">Includes unreleased tools</span>
                        </div>
                      </div>
                    </div>
                  </div>

                  </div>

                  <!-- Quick Info -->
                  <div class="row mt-3">
                    <div class="col-12">
                      <div class="card bg-dark text-white">
                        <div class="card-body">
                          <h5 class="text-white mb-3"><i class="fas fa-info-circle"></i> Quick Start</h5>
                          <div class="row">
                            <div class="col-md-4">
                              <p class="mb-1"><strong>Connected to:</strong> <?php echo htmlspecialchars($host_session ?? 'N/A'); ?></p>
                              <p class="mb-1"><strong>User:</strong> <?php echo htmlspecialchars($name ?? 'N/A'); ?></p>
                            </div>
                            <div class="col-md-4">
                              <p class="mb-1"><strong>Database:</strong> MariaDB (<?php echo DB_NAME; ?>)</p>
                              <p class="mb-1"><strong>PHP:</strong> <?php echo PHP_VERSION; ?></p>
                            </div>
                            <div class="col-md-4">
                              <p class="mb-1"><strong>Version:</strong> <?php echo APP_VERSION; ?></p>
                              <p class="mb-1"><strong>Session:</strong> Active</p>
                            </div>
                          </div>
                        </div>
                      </div>
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