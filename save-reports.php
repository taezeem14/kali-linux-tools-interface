<?php
  if (session_status() === PHP_SESSION_NONE) session_start();
  
  $tool = htmlspecialchars($_POST["tool_selected"] ?? '', ENT_QUOTES, 'UTF-8');
  $command_executed = htmlspecialchars($_POST["command_executed"] ?? '', ENT_QUOTES, 'UTF-8');
  $report_name = htmlspecialchars($_POST["report_name"] ?? '', ENT_QUOTES, 'UTF-8');
  $output_data = htmlspecialchars($_POST["output_data"] ?? '', ENT_QUOTES, 'UTF-8');

  include('assets/includes/config.php');
  $con = getConnectionDB() or die ("Could not connect to database.");

  $sql = $con->prepare("SELECT solution FROM tools WHERE name = :tool_name");
  $sql->execute([':tool_name' => $tool]);
  
  if ($sql->rowCount() > 0) {
      $resultado = $sql->fetch(PDO::FETCH_ASSOC);
      $solution = $resultado["solution"];
      $sql2 = $con->prepare("INSERT INTO reports (name, command, tools, output, solution, dataHour) VALUES (:name, :command, :tools, :output, :solution, CURRENT_TIMESTAMP)");

      if ($sql2->execute([':name' => $tool, ':command' => $command_executed, ':tools' => $report_name, ':output' => $output_data, ':solution' => $solution])) {
        echo "<div class='card card-stats'><div class='card-body'>
          <div class='row'><div class='col'>
            <h5 class='card-title text-uppercase text-muted mb-0'>Report Saved</h5>
            <span class='h3 font-weight-bold mb-0 text-success'><i class='ni ni-check-bold'></i> Saved successfully!</span>
          </div><div class='col-auto'>
            <div class='icon icon-shape bg-success text-white rounded-circle shadow'><i class='ni ni-single-copy-04'></i></div>
          </div></div></div></div>";
      }
  } else {
    echo "<div class='card card-stats'><div class='card-body'>
      <div class='row'><div class='col'>
        <h5 class='card-title text-uppercase text-muted mb-0'>Error</h5>
        <span class='h3 font-weight-bold mb-0 text-danger'><i class='ni ni-fat-remove'></i> Failed to save. Try again.</span>
      </div></div></div></div>";
  }
?>