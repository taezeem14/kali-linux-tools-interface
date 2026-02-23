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
	              <h2 class="mb-0"><i class="fas fa-user-circle"></i> System Information</h2>
	            </div>
            	
            	<div class="card-body">
                <div class="row">
                  <!-- Session Info -->
                  <div class="col-md-6 mb-4">
                    <div class="card bg-gradient-dark text-white">
                      <div class="card-body">
                        <h5 class="text-white mb-3"><i class="fas fa-plug"></i> SSH Connection</h5>
                        <table class="table table-borderless text-white mb-0" style="font-size: 0.9rem;">
                          <tr>
                            <td class="py-1"><strong>Host:</strong></td>
                            <td class="py-1"><?php echo htmlspecialchars($host_session ?? 'N/A'); ?></td>
                          </tr>
                          <tr>
                            <td class="py-1"><strong>User:</strong></td>
                            <td class="py-1"><?php echo htmlspecialchars($name ?? 'N/A'); ?></td>
                          </tr>
                          <tr>
                            <td class="py-1"><strong>Port:</strong></td>
                            <td class="py-1"><?php echo htmlspecialchars($_SESSION['port'] ?? '22'); ?></td>
                          </tr>
                          <tr>
                            <td class="py-1"><strong>Login Time:</strong></td>
                            <td class="py-1"><?php echo isset($_SESSION['login_time']) ? date('d M Y H:i:s', $_SESSION['login_time']) : 'N/A'; ?></td>
                          </tr>
                        </table>
                      </div>
                    </div>
                  </div>

                  <!-- Server Info -->
                  <div class="col-md-6 mb-4">
                    <div class="card bg-gradient-dark text-white">
                      <div class="card-body">
                        <h5 class="text-white mb-3"><i class="fas fa-server"></i> Server Environment</h5>
                        <table class="table table-borderless text-white mb-0" style="font-size: 0.9rem;">
                          <tr>
                            <td class="py-1"><strong>PHP Version:</strong></td>
                            <td class="py-1"><?php echo PHP_VERSION; ?></td>
                          </tr>
                          <tr>
                            <td class="py-1"><strong>Web Server:</strong></td>
                            <td class="py-1"><?php echo htmlspecialchars($_SERVER['SERVER_SOFTWARE'] ?? 'Unknown'); ?></td>
                          </tr>
                          <tr>
                            <td class="py-1"><strong>App Version:</strong></td>
                            <td class="py-1"><?php echo APP_VERSION; ?></td>
                          </tr>
                          <tr>
                            <td class="py-1"><strong>Database:</strong></td>
                            <td class="py-1">MariaDB (<?php echo DB_NAME; ?>)</td>
                          </tr>
                        </table>
                      </div>
                    </div>
                  </div>
                </div>

                <!-- Remote System Info -->
                <div class="row">
                  <div class="col-12">
                    <div class="card bg-gradient-dark text-white">
                      <div class="card-body">
                        <h5 class="text-white mb-3"><i class="fas fa-terminal"></i> Remote System</h5>
                        <?php
                          $ssh = getConnectionSSH();
                          if ($ssh) {
                            $uname = htmlspecialchars(trim($ssh->exec('uname -a')));
                            $uptime = htmlspecialchars(trim($ssh->exec('uptime -p')));
                            $hostname = htmlspecialchars(trim($ssh->exec('hostname')));
                            $ip = htmlspecialchars(trim($ssh->exec("hostname -I | awk '{print \$1}'")));
                        ?>
                        <table class="table table-borderless text-white mb-0" style="font-size: 0.9rem;">
                          <tr>
                            <td class="py-1" style="width:150px;"><strong>Hostname:</strong></td>
                            <td class="py-1"><code class="text-white"><?php echo $hostname; ?></code></td>
                          </tr>
                          <tr>
                            <td class="py-1"><strong>IP Address:</strong></td>
                            <td class="py-1"><code class="text-white"><?php echo $ip; ?></code></td>
                          </tr>
                          <tr>
                            <td class="py-1"><strong>Uptime:</strong></td>
                            <td class="py-1"><?php echo $uptime; ?></td>
                          </tr>
                          <tr>
                            <td class="py-1"><strong>Kernel:</strong></td>
                            <td class="py-1"><code class="text-white"><?php echo $uname; ?></code></td>
                          </tr>
                        </table>
                        <?php } else { ?>
                          <p class="text-warning mb-0"><i class="fas fa-exclamation-triangle"></i> Could not establish SSH connection to retrieve system info.</p>
                        <?php } ?>
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