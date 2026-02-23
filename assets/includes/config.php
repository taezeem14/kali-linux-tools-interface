<?php

	/**
	 * Kali Linux Tools Interface - Configuration
	 * Updated for modern Kali Linux (2024+) with MariaDB support
	 */

	// Database Configuration (MariaDB - default on modern Kali)
	define('DB_HOST', 'localhost');
	define('DB_NAME', 'kali_tools');
	define('DB_USER', 'root');
	define('DB_PASS', '');
	define('DB_CHARSET', 'utf8mb4');

	function getConnectionDB() {
		try {
			$dsn = 'mysql:host=' . DB_HOST . ';dbname=' . DB_NAME . ';charset=' . DB_CHARSET;
			$options = [
				PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
				PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
				PDO::ATTR_EMULATE_PREPARES   => false,
			];
			$con = new PDO($dsn, DB_USER, DB_PASS, $options);
			return $con;
		} catch (PDOException $e) {
			error_log("Database connection failed: " . $e->getMessage());
			die("Database connection failed. Ensure MariaDB is running: <code>sudo systemctl start mariadb</code>");
		}
	}

	// Start session securely if not already started
	if (session_status() === PHP_SESSION_NONE) {
		ini_set('session.cookie_httponly', 1);
		ini_set('session.use_strict_mode', 1);
		session_start();
	}

	// CSRF Token generation
	if (empty($_SESSION['csrf_token'])) {
		$_SESSION['csrf_token'] = bin2hex(random_bytes(32));
	}

	function csrf_token_field() {
		return '<input type="hidden" name="csrf_token" value="' . htmlspecialchars($_SESSION['csrf_token']) . '">';
	}

	function verify_csrf_token() {
		if (!isset($_POST['csrf_token']) || !hash_equals($_SESSION['csrf_token'], $_POST['csrf_token'])) {
			http_response_code(403);
			die('Invalid CSRF token.');
		}
	}

	// Sanitization helper
	function sanitize($input) {
		return htmlspecialchars(trim($input), ENT_QUOTES, 'UTF-8');
	}

	// Verify session authentication
	if (!isset($_SESSION["host"]) || !isset($_SESSION["user"]) || !isset($_SESSION["password"])) {
		$current_page = basename($_SERVER['PHP_SELF']);
		if (!in_array($current_page, ['login.php', 'login-validation.php'])) {
			header("Location: login.php");
			exit();
		}
	} else {
		$name = $_SESSION["user"];
		$host_session = $_SESSION["host"];
		$avatar = "assets/img/profile.jpg";
		$background = "assets/img/background.jpg";
	}

	// Application metadata
	define('APP_NAME', 'Kali Tools Interface');
	define('APP_VERSION', '3.0.0');
	define('APP_YEAR', '2026');

?>