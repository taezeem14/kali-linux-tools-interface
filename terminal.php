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
	              <h2 class="mb-0"><i class="fas fa-terminal"></i> Web Terminal</h2>
	            </div>
            	
            	<div class="card-body">
            		<div class="alert alert-info">
            			<strong>Terminal Options:</strong> Choose your preferred web terminal below. 
            			You need one of these installed on the target host.
            		</div>

            		<div class="row mb-3">
            			<div class="col-md-6">
            				<div class="card bg-dark text-white">
            					<div class="card-body">
            						<h5 class="card-title text-white"><i class="fas fa-terminal"></i> ttyd (Recommended)</h5>
            						<p class="card-text">Modern web terminal with full xterm.js support. Install: <code class="text-warning">sudo apt install ttyd</code></p>
            						<p class="card-text">Start: <code class="text-warning">ttyd -p 7681 bash</code></p>
            						<button class="btn btn-success btn-sm" onclick="loadTerminal('ttyd')">Connect via ttyd</button>
            					</div>
            				</div>
            			</div>
            			<div class="col-md-6">
            				<div class="card bg-dark text-white">
            					<div class="card-body">
            						<h5 class="card-title text-white"><i class="fas fa-desktop"></i> Shell In A Box (Legacy)</h5>
            						<p class="card-text">Classic web terminal. Install: <code class="text-warning">sudo apt install shellinabox</code></p>
            						<p class="card-text">Runs on port 4200 by default.</p>
            						<button class="btn btn-outline-light btn-sm" onclick="loadTerminal('shellinabox')">Connect via Shell In A Box</button>
            					</div>
            				</div>
            			</div>
            		</div>

            		<div id="terminal-container">
            			<p class="text-center text-muted">Select a terminal option above to connect.</p>
            		</div>
					
				</div>
			</div>
	<?php
		include("assets/includes/footer.php")
	?>

	<script>
	function loadTerminal(type) {
		var host = '<?php echo htmlspecialchars($_SESSION["host"] ?? "localhost"); ?>';
		var container = document.getElementById('terminal-container');
		
		if (type === 'ttyd') {
			container.innerHTML = '<iframe class="iframe-terminal" src="http://' + host + ':7681/" style="width:100%;height:600px;border:2px solid #333;border-radius:8px;background:#000;"></iframe>';
		} else {
			container.innerHTML = '<iframe class="iframe-terminal" src="https://' + host + ':4200/" style="width:100%;height:600px;border:2px solid #333;border-radius:8px;background:#000;"></iframe>';
		}
	}
	</script>
</body>
</html>