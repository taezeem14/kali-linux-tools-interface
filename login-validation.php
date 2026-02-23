<?php
	/**
	 * Login Validation - SSH Authentication
	 * Compatible with modern Kali Linux (2024+)
	 */

	if (session_status() === PHP_SESSION_NONE) {
		session_start();
	}
	session_regenerate_id(true);

	if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
		header('Location: login.php');
		exit();
	}

	$host = filter_input(INPUT_POST, 'host', FILTER_SANITIZE_FULL_SPECIAL_CHARS);
	$user = filter_input(INPUT_POST, 'user', FILTER_SANITIZE_FULL_SPECIAL_CHARS);
	$password = $_POST['password'] ?? '';
	$port = filter_input(INPUT_POST, 'port', FILTER_VALIDATE_INT) ?: 22;

	if (empty($host) || empty($user) || empty($password)) {
		echo "<script>alert('All fields are required.'); window.location.href='login.php';</script>";
		exit();
	}

	set_include_path('assets/libraries/phpseclib/');
	include('Net/SSH2.php');

	$ssh = new Net_SSH2($host, $port);

	if (!$ssh->login($user, $password)) {
		echo "<script>alert('SSH connection failed! Check your credentials and ensure SSH is running on the target.'); window.location.href='login.php';</script>";
		exit();
	}

	// Store session data
	$_SESSION['host'] = $host;
	$_SESSION['user'] = $user;
	$_SESSION['password'] = $password;
	$_SESSION['port'] = $port;
	$_SESSION['login_time'] = time();

	header('Location: index.php');
	exit();
?>
