-- =============================================================
-- Kali Linux Tools Interface - Database Schema
-- Compatible with MariaDB 10.x+ (default on modern Kali Linux)
-- =============================================================
--
-- Quick Setup:
--   sudo systemctl start mariadb
--   sudo mysql_secure_installation
--   sudo mysql -u root -e "CREATE DATABASE kali_tools CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
--   sudo mysql -u root kali_tools < assets/database.sql
--

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

-- --------------------------------------------------------
-- Table: commands
-- Stores individual command flags/options for each tool
-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `commands` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `examples` text DEFAULT NULL,
  `tool` int(11) DEFAULT NULL,
  `type` varchar(30) DEFAULT NULL COMMENT 'input, checkbox, show, target',
  `command` text DEFAULT NULL,
  `example` varchar(150) DEFAULT NULL,
  `sudo` tinyint(1) DEFAULT NULL,
  `category` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_tool` (`tool`),
  KEY `idx_type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table: reports
-- Stores saved scan results and remediation data
-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `tools` varchar(100) DEFAULT NULL,
  `command` varchar(500) DEFAULT NULL,
  `output` longtext DEFAULT NULL,
  `solution` text DEFAULT NULL,
  `dataHour` datetime DEFAULT CURRENT_TIMESTAMP,
  `severity` enum('info','low','medium','high','critical') DEFAULT 'info',
  PRIMARY KEY (`id`),
  KEY `idx_datahour` (`dataHour`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table: tools
-- Master list of security tools available in the interface
-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `tools` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `fullname` varchar(150) DEFAULT NULL,
  `categories` varchar(300) DEFAULT NULL,
  `description` varchar(500) DEFAULT NULL,
  `site` varchar(100) DEFAULT NULL,
  `github` varchar(500) DEFAULT NULL,
  `released` tinytext DEFAULT NULL COMMENT 'Yes = available in UI',
  `avatar` varchar(100) DEFAULT NULL,
  `cmd` varchar(100) DEFAULT NULL COMMENT 'CLI command to execute',
  `target` varchar(50) DEFAULT NULL COMMENT 'Target flag e.g. -h, --url',
  `resume` text DEFAULT NULL,
  `category` varchar(100) DEFAULT NULL,
  `category2` varchar(100) DEFAULT NULL,
  `solution` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_released` (`released`(3)),
  KEY `idx_category` (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ========================================================
-- DATA: Nmap Commands
-- ========================================================

INSERT INTO `commands` (`id`, `name`, `description`, `examples`, `tool`, `type`, `command`, `example`, `sudo`, `category`) VALUES
(1, 'Scan specific ports', NULL, 'nmap -p 80,443 8.8.8.8', 1, 'input', '-p', 'Specific: 80,443 OR Range: 1-65536', NULL, 'PORT SPECIFICATION'),
(2, 'Ping Scan - disable port scan', NULL, NULL, 1, 'checkbox', '-sL', NULL, NULL, 'HOST DISCOVERY'),
(3, 'Skip host discovery', NULL, NULL, 1, 'checkbox', '-Pn', NULL, NULL, 'HOST DISCOVERY'),
(4, 'Trace hop path to each host', NULL, NULL, 1, 'checkbox', '--traceroute', NULL, NULL, 'HOST DISCOVERY'),
(5, 'Use OS DNS resolver', NULL, NULL, 1, 'checkbox', '--system-dns', NULL, NULL, 'HOST DISCOVERY'),
(6, 'Exclude hosts/networks', NULL, NULL, 1, 'input', '--exclude', 'Example: 192.168.0.1', NULL, 'TARGET SPECIFICATION'),
(7, 'Enable OS detection', NULL, NULL, 1, 'checkbox', '-O', NULL, NULL, 'OS DETECTION'),
(8, 'IP protocol scan', NULL, NULL, 1, 'checkbox', '-sO', NULL, NULL, 'SCAN TECHNIQUES'),
(9, 'FTP bounce scan', NULL, NULL, 1, 'checkbox', '-b', NULL, NULL, 'SCAN TECHNIQUES'),
(10, 'Exclude ports from scanning', NULL, NULL, 1, 'input', '--exclude-ports', 'Specific: 80,443 OR Range: 1-65536', NULL, 'PORT SPECIFICATION'),
(11, 'Scan 100 most common ports', NULL, NULL, 1, 'checkbox', '-F', NULL, NULL, 'PORT SPECIFICATION'),
(12, 'Service detection (Standard)', NULL, NULL, 1, 'checkbox', '-sV', NULL, NULL, 'SERVICE/VERSION DETECTION'),
(13, 'OS detection + version + scripts + traceroute', NULL, NULL, 1, 'checkbox', '-A', NULL, NULL, 'COMPREHENSIVE'),
(14, 'Print version number', NULL, NULL, 1, 'show', '-V', NULL, NULL, 'MISC'),
(15, 'Print help summary', NULL, NULL, 1, 'show', '-h', NULL, NULL, 'MISC'),
(16, 'Enable IPv6 scanning', NULL, NULL, 1, 'checkbox', '-6', NULL, NULL, 'MISC'),
(17, 'UDP Scan', NULL, NULL, 1, 'checkbox', '-sU', NULL, NULL, 'SCAN TECHNIQUES'),
(18, 'Scan for vulnerabilities', NULL, NULL, 1, 'checkbox', '-sS -sC -Pn --script vuln', NULL, NULL, 'VULNERABILITY SCANNING'),
(19, 'Scan for exploits', NULL, NULL, 1, 'checkbox', '-Pn -sS -sC --script exploit', NULL, NULL, 'VULNERABILITY SCANNING'),
(20, 'Test DoS vulnerability', NULL, NULL, 1, 'checkbox', '-Pn -sS -sC --script dos', NULL, NULL, 'VULNERABILITY SCANNING'),
(21, 'Find subdomains via DNS brute', NULL, NULL, 1, 'checkbox', '-p 80 --script dns-brute.nse', NULL, NULL, 'DNS ENUMERATION'),
(22, 'Scan all 65535 ports', NULL, NULL, 1, 'checkbox', '-p-', NULL, NULL, 'PORT SPECIFICATION'),
(23, 'TCP connect scan', NULL, NULL, 1, 'checkbox', '-sT', NULL, NULL, 'SCAN TECHNIQUES'),
(24, 'Scan common UDP ports', NULL, NULL, 1, 'checkbox', '-sU -p 123,161,162', NULL, NULL, 'SCAN TECHNIQUES'),
(25, 'Service detection (Aggressive)', NULL, NULL, 1, 'checkbox', '--version-intensity 5', NULL, NULL, 'SERVICE/VERSION DETECTION'),
(26, 'Service detection (Light)', NULL, NULL, 1, 'checkbox', '-sV --version-intensity 0', NULL, NULL, 'SERVICE/VERSION DETECTION'),
(27, 'Default safe scripts', NULL, NULL, 1, 'checkbox', '-sV -sC', NULL, NULL, 'NSE SCRIPTS'),
(28, 'Gather HTTP page titles', NULL, NULL, 1, 'checkbox', '--script=http-title', NULL, NULL, 'HTTP ENUMERATION'),
(29, 'Get HTTP headers', NULL, NULL, 1, 'checkbox', '--script=http-headers', NULL, NULL, 'HTTP ENUMERATION'),
(30, 'Find web apps from known paths', NULL, NULL, 1, 'checkbox', '--script=http-enum', NULL, NULL, 'HTTP ENUMERATION'),
(31, 'Only show open ports', NULL, NULL, 1, 'checkbox', '--open', NULL, NULL, 'OUTPUT'),
(32, 'Show host interfaces and routes', NULL, NULL, 1, 'checkbox', '--iflist', NULL, NULL, 'MISC'),
(33, 'IP protocol ping', NULL, NULL, 1, 'checkbox', '-PO', NULL, NULL, 'HOST DISCOVERY'),
(34, 'UDP ping', NULL, NULL, 1, 'checkbox', '-PU', NULL, NULL, 'HOST DISCOVERY'),
(35, 'TCP Fin scan (firewall evasion)', NULL, NULL, 1, 'checkbox', '-sF', NULL, NULL, 'FIREWALL EVASION'),
(36, 'TCP Xmas scan (firewall evasion)', NULL, NULL, 1, 'checkbox', '-sX', NULL, NULL, 'FIREWALL EVASION'),
(37, 'TCP Null scan (firewall evasion)', NULL, NULL, 1, 'checkbox', '-sN', NULL, NULL, 'FIREWALL EVASION'),
(38, 'Output to XML', NULL, NULL, 1, 'input', '-oX', 'output.xml', NULL, 'OUTPUT'),
(39, 'Output to all formats', NULL, NULL, 1, 'input', '-oA', 'scan_results', NULL, 'OUTPUT'),
(40, 'Timing template (0-5)', NULL, NULL, 1, 'input', '-T', '4 (aggressive)', NULL, 'TIMING'),
(41, 'Min rate packets/sec', NULL, NULL, 1, 'input', '--min-rate', '1000', NULL, 'TIMING');

-- ========================================================
-- DATA: theHarvester Commands
-- ========================================================

INSERT INTO `commands` (`id`, `name`, `description`, `examples`, `tool`, `type`, `command`, `example`, `sudo`, `category`) VALUES
(50, 'DNS TLD expansion', NULL, NULL, 3, 'checkbox', '-t', NULL, NULL, 'DNS'),
(51, 'DNS brute force', NULL, NULL, 3, 'checkbox', '-c', NULL, NULL, 'DNS'),
(52, 'DNS reverse query', NULL, NULL, 3, 'checkbox', '-n', NULL, NULL, 'DNS'),
(53, 'Use specific DNS server', NULL, NULL, 3, 'input', '-e', 'Set a DNS server', NULL, 'DNS'),
(54, 'Limit results count', NULL, NULL, 3, 'input', '-l', 'Default: 500', NULL, 'SEARCH'),
(55, 'Start at result number', NULL, NULL, 3, 'input', '-s', 'Default: 0', NULL, 'SEARCH'),
(56, 'Data source', NULL, NULL, 3, 'input', '-b', 'google, bing, linkedin, crtsh, dnsdumpster', NULL, 'SEARCH'),
(57, 'Verify host / find virtual hosts', NULL, NULL, 3, 'checkbox', '-v', NULL, NULL, 'VERIFICATION');

-- ========================================================
-- DATA: Dnstracer Commands
-- ========================================================

INSERT INTO `commands` (`id`, `name`, `description`, `examples`, `tool`, `type`, `command`, `example`, `sudo`, `category`) VALUES
(60, 'Source address', NULL, NULL, 8, 'input', '-S', 'IP address', NULL, 'QUERY'),
(61, 'Timeout per try', NULL, NULL, 8, 'input', '-t', 'Seconds', NULL, 'QUERY'),
(62, 'Disable IPv6', NULL, NULL, 8, 'checkbox', '-4', NULL, NULL, 'QUERY'),
(63, 'Verbose output', NULL, NULL, 8, 'checkbox', '-v', NULL, NULL, 'OUTPUT'),
(64, 'Retry limit', NULL, NULL, 8, 'input', '-r', 'Ex: 1', NULL, 'QUERY'),
(65, 'Record type', NULL, NULL, 8, 'input', '-q', 'A, AAAA, MX, NS, TXT', NULL, 'QUERY'),
(66, 'Overview of answers', NULL, NULL, 8, 'checkbox', '-o', NULL, NULL, 'OUTPUT'),
(67, 'Enable negative cache', NULL, NULL, 8, 'checkbox', '-C', NULL, NULL, 'CACHE'),
(68, 'Disable local caching', NULL, NULL, 8, 'checkbox', '-c', NULL, NULL, 'CACHE');

-- ========================================================
-- DATA: Gobuster Commands
-- ========================================================

INSERT INTO `commands` (`id`, `name`, `description`, `examples`, `tool`, `type`, `command`, `example`, `sudo`, `category`) VALUES
(70, 'Wordlist', NULL, NULL, 16, 'input', '-w', '/usr/share/wordlists/dirb/common.txt', NULL, 'CORE'),
(71, 'Threads', NULL, NULL, 16, 'input', '-t', '50', NULL, 'PERFORMANCE'),
(72, 'File extensions', NULL, NULL, 16, 'input', '-x', '.php,.html,.txt,.bak', NULL, 'FILTERING'),
(73, 'Status codes to show', NULL, NULL, 16, 'input', '-s', '200,204,301,302,307,401,403', NULL, 'FILTERING'),
(74, 'Follow redirects', NULL, NULL, 16, 'checkbox', '-r', NULL, NULL, 'BEHAVIOR'),
(75, 'Verbose', NULL, NULL, 16, 'checkbox', '-v', NULL, NULL, 'OUTPUT'),
(76, 'No TLS verification', NULL, NULL, 16, 'checkbox', '-k', NULL, NULL, 'TLS');

-- ========================================================
-- DATA: SQLMap Commands
-- ========================================================

INSERT INTO `commands` (`id`, `name`, `description`, `examples`, `tool`, `type`, `command`, `example`, `sudo`, `category`) VALUES
(80, 'Test forms', NULL, NULL, 17, 'checkbox', '--forms', NULL, NULL, 'TARGET'),
(81, 'Batch mode (no prompts)', NULL, NULL, 17, 'checkbox', '--batch', NULL, NULL, 'GENERAL'),
(82, 'Dump database', NULL, NULL, 17, 'checkbox', '--dump', NULL, NULL, 'ENUMERATION'),
(83, 'List databases', NULL, NULL, 17, 'checkbox', '--dbs', NULL, NULL, 'ENUMERATION'),
(84, 'Risk level', NULL, NULL, 17, 'input', '--risk', '1-3', NULL, 'DETECTION'),
(85, 'Level', NULL, NULL, 17, 'input', '--level', '1-5', NULL, 'DETECTION'),
(86, 'Specific database', NULL, NULL, 17, 'input', '-D', 'database_name', NULL, 'ENUMERATION'),
(87, 'Specific table', NULL, NULL, 17, 'input', '-T', 'table_name', NULL, 'ENUMERATION'),
(88, 'List tables', NULL, NULL, 17, 'checkbox', '--tables', NULL, NULL, 'ENUMERATION'),
(89, 'List columns', NULL, NULL, 17, 'checkbox', '--columns', NULL, NULL, 'ENUMERATION');

-- ========================================================
-- DATA: Hashcat Commands
-- ========================================================

INSERT INTO `commands` (`id`, `name`, `description`, `examples`, `tool`, `type`, `command`, `example`, `sudo`, `category`) VALUES
(90, 'Hash type', NULL, NULL, 18, 'input', '-m', '0=MD5, 100=SHA1, 1000=NTLM, 1800=sha512crypt', NULL, 'HASH MODE'),
(91, 'Attack mode', NULL, NULL, 18, 'input', '-a', '0=Dict, 1=Combo, 3=Brute, 6=Hybrid', NULL, 'ATTACK MODE'),
(92, 'Show cracked', NULL, NULL, 18, 'checkbox', '--show', NULL, NULL, 'OUTPUT'),
(93, 'Force (ignore warnings)', NULL, NULL, 18, 'checkbox', '--force', NULL, NULL, 'GENERAL');

-- ========================================================
-- DATA: John the Ripper Commands
-- ========================================================

INSERT INTO `commands` (`id`, `name`, `description`, `examples`, `tool`, `type`, `command`, `example`, `sudo`, `category`) VALUES
(95, 'Wordlist', NULL, NULL, 19, 'input', '--wordlist=', '/usr/share/wordlists/rockyou.txt', NULL, 'ATTACK'),
(96, 'Hash format', NULL, NULL, 19, 'input', '--format=', 'raw-md5, raw-sha1, bcrypt, NT', NULL, 'FORMAT'),
(97, 'Show cracked', NULL, NULL, 19, 'checkbox', '--show', NULL, NULL, 'OUTPUT'),
(98, 'Incremental mode', NULL, NULL, 19, 'checkbox', '--incremental', NULL, NULL, 'ATTACK');

-- ========================================================
-- DATA: Nikto Commands
-- ========================================================

INSERT INTO `commands` (`id`, `name`, `description`, `examples`, `tool`, `type`, `command`, `example`, `sudo`, `category`) VALUES
(100, 'SSL mode', NULL, NULL, 4, 'checkbox', '-ssl', NULL, NULL, 'CONNECTION'),
(101, 'Output file', NULL, NULL, 4, 'input', '-o', 'report.html', NULL, 'OUTPUT'),
(102, 'Output format', NULL, NULL, 4, 'input', '-Format', 'htm, csv, txt, xml', NULL, 'OUTPUT'),
(103, 'Specific port', NULL, NULL, 4, 'input', '-p', '80,443,8080', NULL, 'TARGET'),
(104, 'Tuning options', NULL, NULL, 4, 'input', '-Tuning', '1-9 (see nikto docs)', NULL, 'SCAN'),
(105, 'Verbose output', NULL, NULL, 4, 'checkbox', '-Display V', NULL, NULL, 'OUTPUT');

-- ========================================================
-- DATA: WPScan Commands
-- ========================================================

INSERT INTO `commands` (`id`, `name`, `description`, `examples`, `tool`, `type`, `command`, `example`, `sudo`, `category`) VALUES
(110, 'Enumerate plugins', NULL, NULL, 7, 'checkbox', '-e ap', NULL, NULL, 'ENUMERATION'),
(111, 'Enumerate users', NULL, NULL, 7, 'checkbox', '-e u', NULL, NULL, 'ENUMERATION'),
(112, 'Enumerate themes', NULL, NULL, 7, 'checkbox', '-e at', NULL, NULL, 'ENUMERATION'),
(113, 'API token', NULL, NULL, 7, 'input', '--api-token', 'Your WPVulnDB API token', NULL, 'AUTH'),
(114, 'Aggressive detection', NULL, NULL, 7, 'checkbox', '--detection-mode aggressive', NULL, NULL, 'DETECTION'),
(115, 'Password attack wordlist', NULL, NULL, 7, 'input', '-P', '/usr/share/wordlists/rockyou.txt', NULL, 'BRUTE FORCE');

-- ========================================================
-- DATA: Subfinder Commands
-- ========================================================

INSERT INTO `commands` (`id`, `name`, `description`, `examples`, `tool`, `type`, `command`, `example`, `sudo`, `category`) VALUES
(120, 'Output file', NULL, NULL, 27, 'input', '-o', 'subdomains.txt', NULL, 'OUTPUT'),
(121, 'Silent mode', NULL, NULL, 27, 'checkbox', '-silent', NULL, NULL, 'OUTPUT'),
(122, 'All sources', NULL, NULL, 27, 'checkbox', '-all', NULL, NULL, 'SOURCES'),
(123, 'Recursive', NULL, NULL, 27, 'checkbox', '-recursive', NULL, NULL, 'BEHAVIOR');

-- ========================================================
-- DATA: Nuclei Commands
-- ========================================================

INSERT INTO `commands` (`id`, `name`, `description`, `examples`, `tool`, `type`, `command`, `example`, `sudo`, `category`) VALUES
(130, 'Template tags', NULL, NULL, 28, 'input', '-tags', 'cve,rce,sqli,xss', NULL, 'TEMPLATES'),
(131, 'Severity filter', NULL, NULL, 28, 'input', '-severity', 'critical,high,medium', NULL, 'FILTERING'),
(132, 'Output file', NULL, NULL, 28, 'input', '-o', 'results.txt', NULL, 'OUTPUT'),
(133, 'Rate limit', NULL, NULL, 28, 'input', '-rate-limit', '150', NULL, 'PERFORMANCE'),
(134, 'Headless mode', NULL, NULL, 28, 'checkbox', '-headless', NULL, NULL, 'BROWSER'),
(135, 'New templates only', NULL, NULL, 28, 'checkbox', '-new-templates', NULL, NULL, 'TEMPLATES');

-- ========================================================
-- DATA: Enum4linux-ng Commands
-- ========================================================

INSERT INTO `commands` (`id`, `name`, `description`, `examples`, `tool`, `type`, `command`, `example`, `sudo`, `category`) VALUES
(140, 'All enumeration', NULL, NULL, 26, 'checkbox', '-A', NULL, NULL, 'ENUMERATION'),
(141, 'Output file', NULL, NULL, 26, 'input', '-oJ', 'output.json', NULL, 'OUTPUT'),
(142, 'Username', NULL, NULL, 26, 'input', '-u', 'username', NULL, 'AUTH'),
(143, 'Password', NULL, NULL, 26, 'input', '-p', 'password', NULL, 'AUTH');


-- ========================================================
-- DATA: Tools (expanded for modern Kali 2024+)
-- ========================================================

INSERT INTO `tools` (`id`, `name`, `fullname`, `categories`, `description`, `site`, `github`, `released`, `avatar`, `cmd`, `target`, `resume`, `category`, `category2`, `solution`) VALUES
(1, 'Nmap', 'Nmap: the Network Mapper', 'information-gathering vulnerability-analysis', 'https://nmap.org/book/man.html', 'https://nmap.org/', 'https://github.com/nmap/nmap', 'Yes', 'assets/img/nmap.jpg', 'nmap', NULL, 'Nmap is a free and open source utility for network discovery and security auditing. It uses raw IP packets to determine available hosts, services, OS versions, packet filters/firewalls, and more.', 'Information Gathering', 'Vulnerability Analysis', '<b>Nmap</b> discovers hosts and services on a network.\n\n<h2 style=\"color: white\">REMEDIATION</h2>\n<p>Close unnecessary ports, update services, and configure firewall rules to restrict access.</p>\n\n<h2 style=\"color: white\">HARDENING</h2>\n<p>Use iptables/nftables to filter traffic. Disable unused services. Keep all services patched.</p>'),

(3, 'theHarvester', 'theHarvester', 'information-gathering', 'https://github.com/laramies/theHarvester', NULL, 'https://github.com/laramies/theHarvester', 'Yes', NULL, 'theHarvester', '-d', 'Gathers emails, subdomains, hosts, employee names, open ports and banners from public sources like search engines, PGP key servers, and SHODAN.', 'Information Gathering', NULL, '<b>theHarvester</b> collects OSINT data from public sources.\n\n<h2 style=\"color: white\">REMEDIATION</h2>\n<p>Audit your public-facing information. Use robots.txt to control indexing. Remove sensitive data from social media and public repos.</p>'),

(4, 'Nikto', 'Nikto Web Scanner', 'information-gathering web-applications', 'https://github.com/sullo/nikto', 'https://www.cirt.net/Nikto2', 'https://github.com/sullo/nikto', 'Yes', 'assets/img/nikto.png', 'nikto', '-h', 'Nikto is an open source web server scanner that tests for dangerous files, outdated server versions, and version-specific problems.', 'Information Gathering', 'Web Applications', '<b>Nikto</b> identifies web server misconfigurations.\n\n<h2 style=\"color: white\">REMEDIATION</h2>\n<p>Update server software, remove default files, configure security headers, and disable unnecessary modules.</p>'),

(7, 'WPScan', 'WordPress Vulnerability Scanner', 'web-applications', 'https://wpscan.com/', 'https://wpscan.com/', 'https://github.com/wpscanteam/wpscan', 'Yes', 'assets/img/wpscan.png', 'wpscan', '--url', 'WPScan is a black box WordPress vulnerability scanner for finding security issues in WordPress installations.', 'Web Applications', NULL, '<b>WPScan</b> finds WordPress vulnerabilities.\n\n<h2 style=\"color: white\">REMEDIATION</h2>\n<p>Keep WordPress core, themes, and plugins updated. Remove unused plugins. Use strong passwords and 2FA.</p>'),

(8, 'Dnstracer', 'dnstracer', 'information-gathering', 'https://www.kali.org/tools/dnstracer/', 'https://www.mavetju.org/unix/dnstracer.php', NULL, 'Yes', NULL, 'dnstracer', NULL, 'dnstracer determines where a DNS server gets its information from and follows the chain back to the authoritative answer.', 'Information Gathering', NULL, NULL),

(16, 'Gobuster', 'Gobuster', 'web-applications information-gathering', 'https://www.kali.org/tools/gobuster/', NULL, 'https://github.com/OJ/gobuster', 'Yes', NULL, 'gobuster dir', '-u', 'Gobuster brute-forces URIs (directories and files), DNS subdomains, virtual host names, and S3 buckets.', 'Web Applications', 'Information Gathering', '<b>Gobuster</b> brute-forces directories on web servers.\n\n<h2 style=\"color: white\">REMEDIATION</h2>\n<p>Restrict directory listings, implement rate-limiting, use WAF rules, and remove unnecessary files from web root.</p>'),

(17, 'SQLMap', 'SQLMap', 'web-applications vulnerability-analysis', 'https://www.kali.org/tools/sqlmap/', 'https://sqlmap.org/', 'https://github.com/sqlmapproject/sqlmap', 'Yes', NULL, 'sqlmap', '-u', 'SQLMap automates detection and exploitation of SQL injection flaws and database server takeover.', 'Web Applications', 'Vulnerability Analysis', '<b>SQLMap</b> tests for SQL injection vulnerabilities.\n\n<h2 style=\"color: white\">REMEDIATION</h2>\n<p>Use parameterized queries (prepared statements). Implement input validation and output encoding. Deploy a WAF.</p>'),

(18, 'Hashcat', 'Hashcat', 'password-attacks', 'https://www.kali.org/tools/hashcat/', 'https://hashcat.net/hashcat/', 'https://github.com/hashcat/hashcat', 'Yes', NULL, 'hashcat', NULL, 'Hashcat is the world''s fastest password recovery utility, supporting 300+ hash types with GPU acceleration.', 'Password Attacks', NULL, '<b>Hashcat</b> cracks password hashes.\n\n<h2 style=\"color: white\">HARDENING</h2>\n<p>Use strong hashing algorithms (bcrypt, Argon2). Enforce password complexity policies. Implement account lockout.</p>'),

(19, 'John the Ripper', 'John the Ripper', 'password-attacks', 'https://www.kali.org/tools/john/', 'https://www.openwall.com/john/', 'https://github.com/openwall/john', 'Yes', NULL, 'john', NULL, 'John the Ripper is a fast password cracker available for many operating systems.', 'Password Attacks', NULL, NULL),

(20, 'Hydra', 'THC-Hydra', 'password-attacks', 'https://www.kali.org/tools/hydra/', 'https://github.com/vanhauser-thc/thc-hydra', 'https://github.com/vanhauser-thc/thc-hydra', 'Yes', 'assets/img/hydrathc.jpg', 'hydra', NULL, 'Hydra is a fast online password cracking tool supporting SSH, FTP, HTTP, SMB, and 50+ protocols.', 'Password Attacks', NULL, NULL),

(21, 'Aircrack-ng', 'Aircrack-ng', 'wireless-attacks', 'https://www.kali.org/tools/aircrack-ng/', 'https://www.aircrack-ng.org/', 'https://github.com/aircrack-ng/aircrack-ng', NULL, NULL, NULL, NULL, 'Complete suite for WiFi security assessment: monitoring, attacking, testing, and cracking.', 'Wireless Attacks', NULL, NULL),

(22, 'Metasploit', 'Metasploit Framework', 'exploitation-tools', 'https://www.kali.org/tools/metasploit-framework/', 'https://www.metasploit.com/', 'https://github.com/rapid7/metasploit-framework', NULL, NULL, 'msfconsole', NULL, 'Advanced open-source platform for developing, testing, and using exploit code against remote targets.', 'Exploitation Tools', NULL, NULL),

(23, 'Burp Suite', 'Burp Suite Community', 'web-applications', 'https://www.kali.org/tools/burpsuite/', 'https://portswigger.net/burp', NULL, NULL, NULL, 'burpsuite', NULL, 'Integrated platform for web application security testing with proxy, scanner, and intruder tools.', 'Web Applications', NULL, NULL),

(24, 'Wireshark', 'Wireshark', 'sniffing-spoofing', 'https://www.kali.org/tools/wireshark/', 'https://www.wireshark.org/', 'https://gitlab.com/wireshark/wireshark', NULL, NULL, 'wireshark', NULL, 'World''s foremost network protocol analyzer for deep inspection of hundreds of protocols.', 'Sniffing & Spoofing', NULL, NULL),

(25, 'Responder', 'Responder', 'sniffing-spoofing', 'https://www.kali.org/tools/responder/', NULL, 'https://github.com/lgandx/Responder', NULL, NULL, 'responder', '-I', 'LLMNR, NBT-NS and MDNS poisoner with built-in HTTP/SMB/MSSQL/FTP/LDAP rogue authentication server.', 'Sniffing & Spoofing', NULL, NULL),

(26, 'Enum4linux-ng', 'enum4linux-ng', 'information-gathering', 'https://www.kali.org/tools/enum4linux/', NULL, 'https://github.com/cddmp/enum4linux-ng', 'Yes', NULL, 'enum4linux-ng', NULL, 'Next-generation enum4linux for enumerating Windows and Samba systems, shares, users, and policies.', 'Information Gathering', NULL, NULL),

(27, 'Subfinder', 'Subfinder', 'information-gathering', 'https://www.kali.org/tools/subfinder/', NULL, 'https://github.com/projectdiscovery/subfinder', 'Yes', NULL, 'subfinder', '-d', 'Passive subdomain discovery tool using online sources to find valid subdomains for websites.', 'Information Gathering', NULL, NULL),

(28, 'Nuclei', 'Nuclei Scanner', 'vulnerability-analysis web-applications', 'https://www.kali.org/tools/nuclei/', NULL, 'https://github.com/projectdiscovery/nuclei', 'Yes', NULL, 'nuclei', '-u', 'Fast, customizable vulnerability scanner based on YAML templates for sending requests across targets.', 'Vulnerability Analysis', 'Web Applications', NULL),

(29, 'Feroxbuster', 'Feroxbuster', 'web-applications information-gathering', 'https://www.kali.org/tools/feroxbuster/', NULL, 'https://github.com/epi052/feroxbuster', 'Yes', NULL, 'feroxbuster', '-u', 'Fast, simple, recursive content discovery tool written in Rust. Modern gobuster/dirbuster alternative.', 'Web Applications', 'Information Gathering', NULL),

(30, 'CrackMapExec', 'CrackMapExec', 'exploitation-tools password-attacks', 'https://www.kali.org/tools/crackmapexec/', NULL, 'https://github.com/byt3bl33d3r/CrackMapExec', NULL, NULL, 'crackmapexec', NULL, 'Swiss army knife for pentesting networks. Abuses built-in AD/Windows features for lateral movement.', 'Exploitation Tools', 'Password Attacks', NULL);


-- ========================================================
-- Auto Increment settings
-- ========================================================

ALTER TABLE `commands`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=200;

ALTER TABLE `reports`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

ALTER TABLE `tools`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=100;

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
