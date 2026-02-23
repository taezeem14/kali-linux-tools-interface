<p align="center">
  <img src="assets/img/logo.png" alt="Logo" width="80" height="80">
  <h3 align="center">Kali Linux Tools Interface v3.0</h3>
  <p align="center">
    A modern web-based GUI for running Kali Linux security tools directly from your browser.
    <br />
    <strong>MariaDB · PHP 8+ · Dark Theme · ttyd Terminal</strong>
    <br /><br />
    Maintained by <strong>Muhammad Taezeem</strong>
  </p>
</p>

---

## Overview

Kali Linux Tools Interface is a web application that provides a graphical interface for information security tools. Connect to your Kali Linux system via SSH and execute security tools through an intuitive browser-based dashboard — no CLI memorization needed.

> **Fork Note:** This is a modernized fork of the [original project](https://github.com/lucasfrag/Kali-Linux-Tools-Interface) by Lucas Fraga, rewritten by **Muhammad Taezeem** for compatibility with modern Kali Linux builds (2024+). Migrated from MySQL to MariaDB, security hardened, dark themed, and expanded with 20+ tools.

## Features

- **20+ Security Tools** — Nmap, Nikto, SQLMap, Hashcat, Hydra, Gobuster, Nuclei, Metasploit, and more
- **Web Terminal** — Integrated terminal via [ttyd](https://github.com/tsl0922/ttyd) (recommended) or Shell In A Box
- **Report System** — Save, view, and manage scan reports with remediation notes
- **Dark Theme** — Modern dark UI with CSS variables and smooth transitions
- **MariaDB Backend** — Full compatibility with Kali's default database engine
- **Security Hardened** — CSRF protection, prepared statements, input sanitization, secure sessions
- **Tool Categories** — Filter by Information Gathering, Vulnerability Analysis, Web Apps, Exploitation, Wireless, Password Attacks, and more
- **One-Command Setup** — Automated `setup.sh` script handles everything

## Prerequisites

| Requirement | Version | Notes |
|---|---|---|
| [Kali Linux](https://www.kali.org/) | 2024.x+ | Any Debian-based distro also works |
| PHP | 7.4+ (8.x recommended) | With `php-mysql`, `php-mbstring`, `php-xml` |
| MariaDB | 10.5+ | Default on Kali since 2020 |
| Apache or Nginx | Any recent | Apache recommended for beginners |
| SSH Server | OpenSSH | The app connects to tools via SSH |
| ttyd | 1.7+ | *Optional* — for the web terminal feature |

> **Note:** On a fresh Kali install, most of these are already available or one `apt install` away. The setup script handles all of it.

---

## Installation (Full Guide)

### Method 1: Automated Setup (Recommended)

This is the fastest way. The `setup.sh` script installs all dependencies, creates the database, deploys the app, and sets permissions.

```bash
# 1. Download / clone the repository
git clone https://github.com/taezeem14/kali-linux-tools-interface.git
cd kali-linux-tools-interface

# 2. Run the installer as root
sudo bash setup.sh
```

That's it. Open `http://localhost/kali-tools/` in your browser and log in with your SSH credentials (the same username/password you use to SSH into the machine).

---

### Method 2: Manual Step-by-Step Install

Follow these steps if you prefer full control or are troubleshooting.

#### Step 1 — Install Required Packages

```bash
sudo apt update
sudo apt install -y apache2 mariadb-server php php-mysql php-mbstring php-xml openssh-server
```

#### Step 2 — Start and Enable Services

```bash
# Start all services and make them persist across reboots
sudo systemctl enable --now mariadb
sudo systemctl enable --now apache2
sudo systemctl enable --now ssh
```

#### Step 3 — Verify MariaDB is Running

```bash
sudo systemctl status mariadb
```

You should see `active (running)`. If not:

```bash
sudo systemctl start mariadb
```

*(Optional but recommended)* Secure your MariaDB installation:

```bash
sudo mysql_secure_installation
```

#### Step 4 — Create the Database and Import Schema

```bash
# This creates the 'kali_tools' database and all tables + seed data
sudo mysql < assets/database.sql
```

To verify it worked:

```bash
sudo mysql -e "USE kali_tools; SHOW TABLES;"
```

You should see three tables: `commands`, `reports`, `tools`.

#### Step 5 — Deploy to the Web Server

```bash
# Copy the project to Apache's web root
sudo mkdir -p /var/www/html/kali-tools
sudo cp -r . /var/www/html/kali-tools/
```

Or if you cloned directly into the web root:

```bash
cd /var/www/html
sudo git clone https://github.com/taezeem14/kali-linux-tools-interface.git kali-tools
```

#### Step 6 — Configure Database Credentials

Edit the config file:

```bash
sudo nano /var/www/html/kali-tools/assets/includes/config.php
```

Set these values (defaults work for most Kali installs):

```php
define('DB_HOST', 'localhost');   // Database host
define('DB_NAME', 'kali_tools'); // Database name (must match the SQL import)
define('DB_USER', 'root');       // MariaDB username
define('DB_PASS', '');           // MariaDB password (empty by default on Kali)
```

> **Tip:** On Kali, MariaDB root uses Unix socket auth by default, so an empty password works when the web server runs as root. For production, create a dedicated DB user:
>
> ```sql
> sudo mysql -e "CREATE USER 'kalitools'@'localhost' IDENTIFIED BY 'YourSecurePassword';"
> sudo mysql -e "GRANT ALL ON kali_tools.* TO 'kalitools'@'localhost';"
> sudo mysql -e "FLUSH PRIVILEGES;"
> ```
> Then update `DB_USER` and `DB_PASS` in `config.php`.

#### Step 7 — Set File Permissions

```bash
sudo chown -R www-data:www-data /var/www/html/kali-tools
sudo chmod -R 755 /var/www/html/kali-tools
```

#### Step 8 — Enable Apache mod_rewrite (Optional)

```bash
sudo a2enmod rewrite
sudo systemctl restart apache2
```

#### Step 9 — Access the Application

Open your browser and navigate to:

```
http://localhost/kali-tools/
```

Or from another machine on the same network:

```
http://<YOUR_KALI_IP>/kali-tools/
```

Log in with your **SSH credentials** — the same username and password you use to SSH into the Kali machine.

---

### Optional: Web Terminal Setup

The terminal page supports two backends. Choose one:

#### Option A: ttyd (Recommended)

```bash
# Install
sudo apt install -y ttyd

# Start on port 7681
ttyd -p 7681 bash &

# To auto-start on boot, create a systemd service:
sudo tee /etc/systemd/system/ttyd.service > /dev/null <<EOF
[Unit]
Description=ttyd - Web Terminal
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/ttyd -p 7681 bash
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable --now ttyd
```

#### Option B: Shell In A Box (Legacy)

```bash
sudo apt install -y shellinabox

# It auto-starts on port 4200
sudo systemctl enable --now shellinabox
```

The terminal page auto-detects which backend is available.

---

## Usage

1. **Login** → Enter your SSH host, username, password, and port (default: 22)
2. **Dashboard** → See tool counts, reports, and quick system info
3. **Tools List** → Browse 20+ tools filtered by category
4. **Select a Tool** → Pick commands/flags via checkboxes, enter a target
5. **Run** → Execute the tool and view real-time output
6. **Save Report** → Store results with remediation notes for later review
7. **Terminal** → Drop into a full web terminal if you need raw CLI access
8. **System Admin** → Manage services, users, and system info

## Default Login

The login uses your **SSH credentials** — the same username and password you use to SSH into the machine. No separate account or registration is needed.

## Database

The application uses a MariaDB database called `kali_tools` with three tables:

| Table | Purpose |
|---|---|
| `tools` | Security tools catalog — name, category, description, release status, avatar |
| `commands` | Available commands/flags for each tool — name, description, type (input/checkbox) |
| `reports` | Saved scan reports — tool name, command, output, remediation notes, timestamp |

## Built With

- [PHP 8](https://php.net) — Server-side logic
- [MariaDB](https://mariadb.org/) — Database engine (Kali default)
- [Argon Dashboard](https://demos.creative-tim.com/argon-dashboard/) — UI framework
- [Bootstrap 4](https://getbootstrap.com) — Responsive layout
- [phpseclib](https://github.com/phpseclib/phpseclib) — PHP SSH connections
- [jQuery](https://jquery.com) — DOM manipulation & AJAX
- [ttyd](https://github.com/tsl0922/ttyd) — Web terminal emulator
- [Font Awesome](https://fontawesome.com) — Icons

## Project Structure

```
├── index.php              # Dashboard with stats and system info
├── login.php              # SSH login page (host, user, pass, port)
├── login-validation.php   # Validates SSH credentials
├── logout.php             # Secure session destruction
├── tools-list.php         # Browse tools with category filters
├── selected-tool.php      # Configure tool commands and target
├── run.php                # Execute tool via SSH and display output
├── terminal.php           # Web terminal (ttyd / shellinabox)
├── reports.php            # View saved reports
├── save-reports.php       # Save a new report
├── selected-report.php    # View report details
├── delete-reports.php     # Delete a report
├── debian.php             # System administration dashboard
├── profile.php            # System information page
├── setup.sh               # Automated installer
├── assets/
│   ├── database.sql       # MariaDB schema + seed data (20+ tools)
│   ├── includes/
│   │   ├── config.php     # Database, session, CSRF configuration
│   │   ├── header.php     # Sidebar navigation
│   │   ├── footer.php     # Page footer
│   │   ├── head.php       # HTML head (meta, CSS, fonts)
│   │   ├── tools-categories.php  # Category filter buttons
│   │   └── list-commands.php     # Load commands for a tool
│   ├── css/               # Stylesheets (dark theme, Argon, Bootstrap)
│   ├── js/                # JavaScript (Argon, Bootstrap, jQuery)
│   └── libraries/
│       └── phpseclib/     # SSH/SFTP library
```

## Screenshots

*Screenshots will be added after deployment. The interface features a modern dark theme with gradient accents.*

## Troubleshooting

| Problem | Solution |
|---|---|
| "Database connection failed" | Run `sudo systemctl start mariadb` and verify credentials in `config.php` |
| Blank page / 500 error | Check `sudo tail -f /var/log/apache2/error.log` for PHP errors |
| Login fails | Verify SSH is running: `sudo systemctl start ssh`. Test with `ssh user@localhost` first |
| Tools not showing | Import the database: `sudo mysql < assets/database.sql` |
| Terminal page empty | Install ttyd (`sudo apt install ttyd`) and start it (`ttyd -p 7681 bash &`) |
| Permission denied errors | Run `sudo chown -R www-data:www-data /var/www/html/kali-tools` |

## Changes from Original

- **MySQL → MariaDB** — Full migration including schema, queries, and configuration
- **SQL Injection Fixes** — All queries now use PDO prepared statements
- **CSRF Protection** — Token-based protection on all forms
- **Session Security** — Secure cookie flags, session regeneration, proper destruction
- **Dark Theme** — Complete CSS overhaul with CSS custom properties
- **Expanded Tools** — 20+ tools with 100+ command options
- **Web Terminal** — ttyd support alongside Shell In A Box
- **Modern PHP** — Compatible with PHP 7.4 through 8.3
- **Input Sanitization** — `filter_input()`, `htmlspecialchars()`, `escapeshellarg()`
- **Configurable SSH Port** — Login now supports custom SSH ports
- **Automated Installer** — `setup.sh` handles full deployment

## License

Distributed under the MIT License. See [LICENSE](LICENSE) for more information.

## Author

**Muhammad Taezeem** — Modernized fork maintainer

## Credits

Original project by [Lucas Fraga](https://github.com/lucasfrag). Modernized and rewritten by Muhammad Taezeem with security improvements, MariaDB migration, and Kali 2024+ compatibility.




