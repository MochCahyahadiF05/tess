<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
//use DB;

class PostSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $sample = [
            ['title' => 'Belajar Laravel',
                'content' => 'Laravel is Awesome'],
            ['title' => 'Belajar PHP',
                'content' => 'PHP is Great'],
        ];
        // jika error Class '"Database\Seeders\DB" not found' maka tambah garis (\) di belakang DB
        \DB::table('post')->insert($sample);
    }
}
