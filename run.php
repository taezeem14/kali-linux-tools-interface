<?php
	/**
	 * Tool Execution Engine
	 * Connects via SSH and executes security tool commands
	 * Compatible with modern Kali Linux (2024+)
	 */

	if (session_status() === PHP_SESSION_NONE) session_start();
	
	if (!isset($_SESSION["host"]) || !isset($_SESSION["user"]) || !isset($_SESSION["password"])) {
		http_response_code(401);
		echo "<div class='alert alert-danger'>Session expired. Please log in again.</div>";
		exit();
	}

	$host = $_SESSION["host"];
	$user = $_SESSION["user"];
	$password = $_SESSION["password"];
	$port = $_SESSION["port"] ?? 22;

	// Set time limit for long-running scans
	set_time_limit(0);

	// Sanitize inputs
	$command = isset($_POST['command']) ? trim($_POST['command']) : '';
	$target = isset($_POST['target']) ? trim($_POST['target']) : '';
	$arrayInputs = isset($_POST['arrayInputs']) ? $_POST['arrayInputs'] : [];
	$arrayCheckbox = isset($_POST['arrayCheckbox']) ? $_POST['arrayCheckbox'] : [];

	// Validate command is not empty
	if (empty($command)) {
		echo "<div class='alert alert-danger'>No command specified.</div>";
		exit();
	}
	
	$cmd = "";

	set_include_path('assets/libraries/phpseclib/');
	include('Net/SSH2.php');

	$ssh = new Net_SSH2($host, $port);
	
	if (!$ssh->login($user, $password)) {
		echo "<div class='alert alert-danger alert-dismissible fade show' role='alert'>
			<span class='alert-inner--icon'><i class='ni ni-fat-remove'></i></span>
			<span class='alert-inner--text'><strong>Error!</strong> SSH connection to <code>" . htmlspecialchars($host) . "</code> failed. Check credentials and SSH service.</span>
			<button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button>
		</div>";
		exit();
	}

	// Build command arguments
	for ($i = 0; isset($arrayInputs[$i]); $i++) {
		$cmd .= " " . escapeshellarg($arrayInputs[$i][0]) . " " . escapeshellarg($arrayInputs[$i][1]);
	}

	for ($i = 0; isset($arrayCheckbox[$i]); $i++) {
		$cmd .= " " . $arrayCheckbox[$i];
	}

	$run = $command . " " . $cmd . " " . $target;

	// UI: Action cards
	echo "<div class='row align-items-center mb-3'>
		<div class='col-xl-6'>
			<div class='card card-stats'>
				<div class='card-body'>
					<div class='row'>
						<div class='col'>
							<h5 class='card-title text-uppercase text-muted mb-0'>Remediation Tips</h5>
							<span class='h4 font-weight-bold mb-0'>View suggested fixes for findings</span>
						</div>
						<div class='col-auto'>
							<div class='icon icon-shape bg-info text-white rounded-circle shadow'>
								<i class='ni ni-settings-gear-65'></i>
							</div>
						</div>
					</div>
					<div class='mt-3'>
						<a href='#solution' data-toggle='collapse' class='btn btn-sm btn-danger'><i class='ni ni-check-bold'></i> Show Remediation</a>
					</div>
				</div>
			</div>
		</div>
		<div class='col-xl-6' id='reports-card'>
			<div class='card card-stats'>
				<div class='card-body'>
					<div class='row'>
						<div class='col'>
							<h5 class='card-title text-uppercase text-muted mb-0'>Save Report</h5>
							<input id='report-name' type='text' class='form-control form-control-alternative mt-2' name='report-name' required placeholder='Report name...'>
						</div>
						<div class='col-auto'>
							<div class='icon icon-shape bg-warning text-white rounded-circle shadow'>
								<i class='ni ni-single-copy-04'></i>
							</div>
						</div>
					</div>
					<div class='mt-3'>
						<input id='command-executed' hidden value='" . htmlspecialchars($run) . "'>
						<button class='btn btn-sm btn-success' onclick='save()'><i class='ni ni-single-copy-04'></i> Save to Reports</button>
					</div>
				</div>
			</div>
		</div>
	</div>";

	echo "<div class='mb-3'><span class='text-muted'>Command:</span> <code>" . htmlspecialchars($run) . "</code></div>";

	// Execute command via SSH
	$ssh->setTimeout(0);
	echo "<textarea id='test' class='form-control' style='width:100%; height:500px; background:#1a1a2e; color:#0f0; font-family:monospace; font-size:13px; border:2px solid #333; border-radius:8px; padding:15px;' readonly>";
	$ssh->exec("echo " . escapeshellarg($password) . " | sudo -S " . $run, 'packet_handler');
	echo "</textarea>";

	echo "<div class='alert alert-success alert-dismissible fade show mt-3' role='alert'>
		<span class='alert-inner--icon'><i class='ni ni-check-bold'></i></span>
		<span class='alert-inner--text'><strong>Complete!</strong> Command executed successfully.</span>
		<button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button>
	</div>";

	function packet_handler($str) {
		echo htmlspecialchars($str);
		flush();
		ob_flush();
	}
?>
