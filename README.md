# ScheduleSchool Project
Pada aplikasi ini berfungsi untuk mempermudah dalam pembuatan penjadwalan mata pelajaran sekolah berbasis Android dan hasilnya dapat dicetak dalam format PDF. Berikut menu-menu utama dan fiturnya yang bisa digunakan dalam aplikasi ini sebagai berikut:
1.	Menu Model Jadwal
Menu ini berfungsi untuk menampilkan, menambahkan, mengatur, dan menghapus data model jadwal. Dan pada model jadwal akan digunakan sebagai template jadwal pelajaran pada setiap kelas dan di menu ini dapat mengatur jenis kegiatan seperti Belajar Mengajar, Istirahat, Pembiasaan Diri, Senam, Sholat Dhuha, Dhuha+Istirahat, dan Upacara, serta dapat mengganti tahun ajaran pada model jadwal.
2.	Menu Jadwal Kelas
Menu ini berfungsi untuk menampilkan, mengatur, dan mencetak jadwal kelas pada model jadwal, serta dapat melihat jumlah jam guru pada model jadwal tersebut. Dan juga pada jadwal kelas yang telah dibuat dapat memasukkan data guru dan data mata pelajaran yang telah dibuat.
3.	Menu Guru
Menu ini berfungsi untuk menampilkan, menambahkan, dan menghapus data guru.
4.	Menu Mata Pelajaran
Menu ini berfungsi untuk menampilkan, menambahkan, dan menghapus data mata pelajaran pada masing-masing kelas.

Environment
Program ini dijalankan menggunakan bahasa Dart (Flutter), dengan library:
•	  flutter_riverpod:
•	  sqflite:
•	  path:
•	  quickalert:
•	  flutter_slidable:
•	  dropdown_button2:
•	  grouped_list:
•	  pdf:
•	  path_provider:
•	  flutter_pdfview:
•	  lottie:



Rancangan Basis Data










Implementasi Sistem
1.	Halaman Awal

Pada halaman awal sistem ini memiliki 4 menu awal yaitu Model Jadwal, Jadwal Kelas, Guru, dan Mata Pelajaran.

2.	Menu Model Jadwal

Pada menu ini menampilkan model-model jadwal yang sudah dibuat dan juga dapat menambahkan model jadwal, serta pada model jadwal yang sudah dibuat dapat diatur model jadwalnya atau juga dapat dihapus.

2.1.	Tambah Data Model Jadwal

Pada fitur ini akan memasukkan nama model jadwal, waktu mulai, jumlah jam per hari, durasi per jam, tahun ajaran, dan hari libur. Dan ada pengecekan nama model jadwal yang tidak boleh sama dengan nama model jadwal yang ada di daftar model jadwal.

2.2.	Pengaturan atau Pengeditan pada Model Jadwal

Pada fitur ini pada jam yang telah dibuat dapat diedit jenis kegiatan dan durasi jam yang nantinya akan dibuat sebagai template di jadwal kelas.

2.2.1.	Ganti Tahun Ajaran
Pada fitur ini dapat mengedit tahun ajaran pada model jadwal.

2.3.	Hapus Data Model Jadwal

Pada fitur ini dapat menghapus data model jadwal yang mengakibatkan semua data yang berkaitan dengan model jadwal tersebut juga dihapus.



3.	Menu Jadwal Kelas

Pada menu ini menampilkan model-model jadwal yang sudah dibuat dan pada model jadwal ini dapat diedit atau dicetak PDF.

3.1.	Pengaturan atau Pengeditan Jadwal Kelas

Pada fitur ini dapat memasukkan data pada jam yang telah dibuat yaitu nama guru yang sudah dibuat, mata pelajaran yang sudah dibuat, dan durasi pelajaran. Pada fitur ini ada pengecekan nama guru jika nama guru tersebut berada pada jam yang sama tapi beda hari maka akan mengalami bentrok antar hari dan tidak bisa diupdate kecuali mendapatkan ijin dari Anda

3.2.	Lihat Jumlah Jam Guru Pada Model Jadwal Kelas

Pada fitur ini dapat menampilkan semua data guru dan kode guru, serta jumlah jam yang telah diambil pada model jadwal kelas tersebut.


3.3.	Cetak jadwal sekolah

Pada fitur ini akan menampilkan jadwal kelas yang telah dibuat dalam bentuk PDF, serta juga dapat disimpan dalam bentuk file PDF. Dan untuk baris yang semua cellnya tidak ada data, maka tidak akan ditampilkan.

4.	Menu Guru

Pada menu ini menampilkan semua data guru yang sudah dibuat dan juga dapat menambahkan data guru.

4.1.	Tambah Data Guru

Pada fitur ini memasukkan nama guru, kode guru, dan status kepala sekolah, serta untuk status kepala sekolah akan dimasukkan jika tidak ada kepala sekolah di daftar guru.

4.2.	Edit Data Guru

Pada fitur ini dapat mengedit nama guru, kode guru, dan status kepala sekolah, serta untuk status kepala sekolah tidak dapat diedit jika ada kepala sekolah di daftar guru dan tidak berstatus kepala sekolah.

4.3.	Hapus Data Guru

Pada fitur ini dapat menghapus data guru yang mengakibatkan semua data yang berkaitan dengan data guru tersebut juga dihapus.

5.	Menu Mata Pelajaran

Pada menu ini menampilkan daftar 6 kelas yaitu kelas 1 sampai kelas 6. Dan di setiap kelas akan menampilkan data mata pelajaran yang sudah dibuat pada kelas tersebut dan juga dapat menambahkan data mata pelajaran.

5.1.	Tambah Data Mata Pelajaran

Pada fitur ini hanya memasukkan nama mata pelajaran, serta ada pengecekan nama mata pelajaran yang tidak boleh sama dengan nama mata pelajaran yang ada di daftar mata pelajaran di kelas yang sama.

5.2.	Edit Data Mata Pelajaran

Pada fitur ini akan mengedit nama mata pelajaran, serta ada pengecekan nama mata pelajaran yang tidak boleh sama dengan nama mata pelajaran yang ada di daftar mata pelajaran di kelas yang sama.

5.3.	Hapus Data Mata Pelajaran

Pada fitur ini dapat menghapus data mata pelajaran yang mengakibatkan semua data yang berkaitan dengan data mata pelajaran tersebut juga dihapus.


