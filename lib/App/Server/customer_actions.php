<?php
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "CustomersDB";
    $table = "Customers";

    $action = $_POST['action'];

	// Obs.:
	// This file must be hosted on the server

    // Connection
    //Create
    $conn = new mysqli($servername, $username, $password, $dbname);

    //Check
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    //Actions
    //Create table
    if('CREATE_TABLE' == $action){
        $sql = "CREATE TABLE IF NOT EXISTS $table (
            id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
            first_name VARCHAR(30) NOT NULL,
            last_name VARCHAR(30) NOT NULL
            )";
        if ($conn->query($sql) === TRUE) {
            echo "success";
        } else {
            echo "error";
        }
        $conn->close();
        return;
    }

    //Get all records
    if('GET_ALL' == $action){
        $dbdata = array();
        $sql = "SELECT id, first_name, last_name FROM $table ORDER BY id DESC";
        $result = $conn->query($sql);
        if ($result->num_rows > 0) {
            while($row = $result->fetch_assoc()) {
                $dbdata[]=$row;
            }
            echo json_encode($dbdata);
        } else {
            echo "error";
        }
        $conn->close();
        return;
    }

    //Add a record
    if('ADD_REC' == $action){
        $first_name = $_POST['first_name'];
        $last_name = $_POST['last_name'];
        $sql = "INSERT INTO $table (first_name, last_name) VALUES('$first_name', '$last_name')";
        $result = $conn->query($sql);
        echo 'success';
        return;
    }

    //Update a record
    if('UPDATE_REC' == $action){
        $id = $_POST['id'];
        $first_name = $_POST['first_name'];
        $last_name = $_POST['last_name'];
        $sql = "UPDATE $table SET first_name = '$first_name', last_name = '$last_name' WHERE id = $id";
        if ($conn->query($sql) === TRUE) {
            echo "success";
        } else {
            echo "error";
        }
        $conn->close();
        return;
    }

    //Delete a record
    if('DELETE_REC' == $action){
        $id = $_POST['id'];
        $sql = "DELETE FROM $table WHERE id = $id";
        if ($conn->query($sql) === TRUE) {
            echo "success";
        } else {
            echo "error";
        }
        $conn->close();
        return;
    }
    
?>