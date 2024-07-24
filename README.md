# ScheduleSchool-Project
&emsp;&emsp;Pada aplikasi ini berfungsi untuk mempermudah dalam pembuatan penjadwalan mata pelajaran sekolah berbasis Android dan hasilnya dapat dicetak dalam format PDF. Berikut menu-menu utama dan fiturnya yang bisa digunakan dalam aplikasi ini sebagai berikut:<br/>
1.	Menu Model Jadwal<br/>
<ol>Menu ini berfungsi untuk menampilkan, menambahkan, mengatur, dan menghapus data model jadwal. Dan pada model jadwal akan digunakan sebagai template jadwal pelajaran pada setiap kelas dan di menu ini dapat mengatur jenis kegiatan seperti Belajar Mengajar, Istirahat, Pembiasaan Diri, Senam, Sholat Dhuha, Dhuha+Istirahat, dan Upacara, serta dapat mengganti tahun ajaran pada model jadwal.</ol>

2.	Menu Jadwal Kelas<br/>
<ol>Menu ini berfungsi untuk menampilkan, mengatur, dan mencetak jadwal kelas pada model jadwal, serta dapat melihat jumlah jam guru pada model jadwal tersebut. Dan juga pada jadwal kelas yang telah dibuat dapat memasukkan data guru dan data mata pelajaran yang telah dibuat.</ol>

3.	Menu Guru<br/>
<ol>Menu ini berfungsi untuk menampilkan, menambahkan, dan menghapus data guru.</ol>

4.	Menu Mata Pelajaran<br/>
<ol>Menu ini berfungsi untuk menampilkan, menambahkan, dan menghapus data mata pelajaran pada masing-masing kelas.</ol><br/>

***Environment***<br/>
Program ini dijalankan menggunakan bahasa Dart (Flutter), dengan library:<br/>
* flutter_riverpod<br/>
* sqflite<br/>
* path<br/>
* quickalert<br/>
* flutter_slidable<br/>
* dropdown_button2<br/>
* grouped_list<br/>
* pdf<br/>
* path_provider<br/>
* flutter_pdfview<br/>
* lottie<br/>

**<h2 align="center">Rancangan Basis Data</h2>**
<div align="center"><img src="/Image/BasisData.PNG" width="450" height="450"/></div>
&emsp;&emsp;Pada Rancangan Basis Data diatas menjelaskan bahwa terdapat 10 tabel yang ada dalam aplikasi ScheduleSchool, diantaranya tabel model jadwal, jadwal, kelas, jenis kegiatan, guru, kode guru, mapel, hari, hari libur, dan data sekolah.<br/>

**<h2 align="center">Implementasi Aplikasi</h2>**

1.	Halaman Awal<br/>
<div align="center"><img src="/Image/Halaman_Awal.gif" width="100"/></div>
<ol>Pada halaman awal sistem ini memiliki 4 menu awal yaitu Model Jadwal, Jadwal Kelas, Guru, dan Mata Pelajaran.</ol><br/>

2.	Menu Model Jadwal<br/>
<div align="center"><img src="/Image/Menu_Model_Jadwal.gif" width="100"/></div>
<ol>Pada menu ini menampilkan model-model jadwal yang sudah dibuat dan juga dapat menambahkan model jadwal, serta pada model jadwal yang sudah dibuat dapat diatur model jadwalnya atau juga dapat dihapus.</ol><br/>

<ol>2.1.	Tambah Data Model Jadwal</ol>
<div align="center"><img src="/Image/Tambah_Data_Model_Jadwal.gif" width="100"/></div>
<ol><ol>Pada fitur ini akan memasukkan nama model jadwal, waktu mulai, jumlah jam per hari, durasi per jam, tahun ajaran, dan hari libur. Dan ada pengecekan nama model jadwal yang tidak boleh sama dengan nama model jadwal yang ada di daftar model jadwal.
</ol></ol><br/>

<ol>2.2.	Pengaturan atau Pengeditan pada Model Jadwal</ol>
<div align="center"><img src="/Image/Pengaturan_atau_Pengeditan_pada_Model_Jadwal.gif" width="100"/></div>
<ol><ol>Pada fitur ini pada jam yang telah dibuat dapat diedit jenis kegiatan dan durasi jam yang nantinya akan dibuat sebagai template di jadwal kelas.</ol></ol><br/>

<ol><ol>2.2.1.	Ganti Tahun Ajaran</ol></ol>
<div align="center"><img src="/Image/Ganti_Tahun_Ajaran.gif" width="100"/></div>
<ol><ol><ol>Pada fitur ini dapat mengedit tahun ajaran pada model jadwal.</ol></ol></ol><br/>

<ol>2.3.	Hapus Data Model Jadwal</ol>
<div align="center"><img src="/Image/Hapus_Data_Model_Jadwal.gif" width="100"/></div>
<ol><ol>Pada fitur ini dapat menghapus data model jadwal yang mengakibatkan semua data yang berkaitan dengan model jadwal tersebut juga dihapus.</ol></ol><br/>

3.	Menu Jadwal Kelas<br/>
<div align="center"><img src="/Image/Menu_Jadwal_Kelas.gif" width="100"/></div>
<ol>Pada menu ini menampilkan model-model jadwal yang sudah dibuat dan pada model jadwal ini dapat diedit atau dicetak PDF.</ol><br/>

<ol>3.1.	Pengaturan atau Pengeditan Jadwal Kelas</ol>
<div align="center"><img src="/Image/Pengaturan_atau_Pengeditan_Jadwal_Kelas.gif" width="100"/></div>
<ol><ol>Pada fitur ini dapat memasukkan data pada jam yang telah dibuat yaitu nama guru yang sudah dibuat, mata pelajaran yang sudah dibuat, dan durasi pelajaran. Pada fitur ini ada pengecekan nama guru jika nama guru tersebut berada pada jam yang sama tapi beda hari maka akan mengalami bentrok antar hari dan tidak bisa diupdate kecuali mendapatkan ijin dari Anda.</ol></ol><br/>

<ol>3.2.	Lihat Jumlah Jam Guru Pada Model Jadwal Kelas</ol>
<div align="center"><img src="/Image/Lihat_Jumlah_Jam_Guru.gif" width="100"/></div>
<ol><ol>Pada fitur ini dapat menampilkan semua data guru dan kode guru, serta jumlah jam yang telah diambil pada model jadwal kelas tersebut.</ol></ol><br/>


<ol>3.3.	Cetak Jadwal Sekolah</ol>
<div align="center"><img src="/Image/Cetak_Jadwal_Sekolah.gif" width="100"/></div>
<ol><ol>Pada fitur ini akan menampilkan jadwal kelas yang telah dibuat dalam bentuk PDF, serta juga dapat disimpan dalam bentuk file PDF. Dan untuk baris yang semua cellnya tidak ada data, maka tidak akan ditampilkan.</ol></ol><br/>

4.	Menu Guru<br/>
<div align="center"><img src="/Image/Menu_Guru.gif" width="100"/></div>
<ol>Pada menu ini menampilkan semua data guru yang sudah dibuat dan juga dapat menambahkan data guru.</ol><br/>

<ol>4.1.	Tambah Data Guru</ol>
<div align="center"><img src="/Image/Tambah_Data_Guru.gif" width="100"/></div>
<ol><ol>Pada fitur ini memasukkan nama guru, kode guru, dan status kepala sekolah, serta untuk status kepala sekolah akan dimasukkan jika tidak ada kepala sekolah di daftar guru.</ol></ol><br/>

<ol>4.2.	Edit Data Guru</ol>
<div align="center"><img src="/Image/Edit_Data_Guru.gif" width="100"/></div>
<ol><ol>Pada fitur ini dapat mengedit nama guru, kode guru, dan status kepala sekolah, serta untuk status kepala sekolah tidak dapat diedit jika ada kepala sekolah di daftar guru dan tidak berstatus kepala sekolah.</ol></ol><br/>

<ol>4.3.	Hapus Data Guru</ol>
<div align="center"><img src="/Image/Edit_Data_Guru.gif" width="100"/></div>
<ol><ol>Pada fitur ini dapat menghapus data guru yang mengakibatkan semua data yang berkaitan dengan data guru tersebut juga dihapus.</ol></ol><br/>

5.	Menu Mata Pelajaran<br/>
<div align="center"><img src="/Image/Menu_Mata_Pelajaran.gif" width="100"/></div>
<ol>Pada menu ini menampilkan daftar 6 kelas yaitu kelas 1 sampai kelas 6. Dan di setiap kelas akan menampilkan data mata pelajaran yang sudah dibuat pada kelas tersebut dan juga dapat menambahkan data mata pelajaran.</ol><br/>

<ol>5.1.	Tambah Data Mata Pelajaran</ol>
<div align="center"><img src="/Image/Tambah_Data_Mata_Pelajaran.gif" width="100"/></div>
<ol><ol>Pada fitur ini hanya memasukkan nama mata pelajaran, serta ada pengecekan nama mata pelajaran yang tidak boleh sama dengan nama mata pelajaran yang ada di daftar mata pelajaran di kelas yang sama.</ol></ol><br/>

<ol>5.2.	Edit Data Mata Pelajaran</ol>
<div align="center"><img src="/Image/Edit_Data_Mata_Pelajaran.gif" width="100"/></div>
<ol><ol>Pada fitur ini akan mengedit nama mata pelajaran, serta ada pengecekan nama mata pelajaran yang tidak boleh sama dengan nama mata pelajaran yang ada di daftar mata pelajaran di kelas yang sama.</ol></ol><br/>

<ol>5.3.	Hapus Data Mata Pelajaran</ol>
<div align="center"><img src="/Image/Hapus_Data_Mata_Pelajaran.gif" width="100"/></div>
<ol><ol>Pada fitur ini dapat menghapus data mata pelajaran yang mengakibatkan semua data yang berkaitan dengan data mata pelajaran tersebut juga dihapus.</ol></ol><br/>


