<?php

	$id = filter_input(INPUT_GET, 'id', FILTER_VALIDATE_INT);
	if (!$id) {
		echo "<script>alert('Invalid report ID.'); window.location.href='reports.php';</script>";
		exit();
	}

	require("assets/includes/config.php"); 

	$con = getConnectionDB() or die ("Could not connect to database.");
	$sql = $con->prepare("DELETE FROM reports WHERE id = :report_id");

	if ($sql->execute([':report_id' => $id])) {
		echo "<script> alert('Report removed successfully.');</script>";
	} else {
		echo "<script> alert('Error removing report. Please try again.');</script>";
	}

	echo "<script>window.location.href = 'reports.php'</script>";
?>