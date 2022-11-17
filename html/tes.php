<?php

    $hobi=['bernyanyi','bermain','ngepet']

?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <form action="" method="post">
        <label for="">jumlah soal</label>
        <input type="number" name="jumlah" id="">
        <button type="submit" name="kirim" >Kirim</button>
    </form>

    <?php

        foreach ($hobi as $key) {
        ?>
            <ul>
                <li><?php echo $key?></li>
            </ul>
        <?php
        }

    ?>
</body>
</html>

<?php

if (isset($_POST['kirim'])) {
    $jumlah=$_POST['jumlah'];
}

?>