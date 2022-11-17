<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=
    , initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Document</title>
</head>
<body>
    <?php $rata=null ?>
     @foreach($kampus as $data)
        nama dosen = {{$data['nama_dosen']}} <br>
        mata kuliah= {{$data['matkul']}} <br>
        <hr>
        @foreach ($data['mhs_bim'] as $mhs)
            nama mahasiswa = {{$mhs['nama_mhs']}} <br>
            {{-- nilai = {{$mhs['nilai']}} <br> --}}
            @endforeach
            <hr>
         @endforeach
            <?php
                
                $rata+=$mhs['nilai'];
                $totl=$rata/2;
                echo $totl;
            ?>
    
</body>
</html>