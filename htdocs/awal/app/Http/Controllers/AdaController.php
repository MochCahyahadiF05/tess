<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class AdaController extends Controller
{
    public function kampus()
    {
        $dosen=[
            ['nama_dosen'=>'Yusuf bachtiar','matkul'=>'programer mobile','mhs_bim'=>[
                ['nama_mhs'=>'muhammad sholeh','nilai'=>75],
                ['nama_mhs'=>'jujun junaedi','nilai'=>85],
                ['nama_mhs'=>'mamat alkatiri','nilai'=>90]
            ]],
            ['nama_dosen'=>'yaris riyadi','matkul'=>'programer web','mhs_bim'=>[
                ['nama_mhs'=>'alfred mctommilay','nilai'=>67],
                ['nama_mhs'=>'brun kasmir','nilai'=>90],
            ]]
        ];
        return view('pages.kampus',['kampus'=>$dosen]);
    }
}
