# Deteksi Anomali Berdasarkan Kolom decoy_noise

Analisis terhadap kolom `decoy_noise` menunjukkan dua pola anomali signifikan. Pertama, terdapat nilai sangat tinggi (hingga 1468.46) yang bahkan melebihi nilai `payment_value` pada beberapa transaksi. Anomali ini umumnya muncul bersama flag `A`, `B`, dan `C`, yang kemungkinan besar merupakan bentuk noise injection atau data dummy berisiko tinggi.

Kedua, ditemukan banyak nilai `decoy_noise` yang negatif atau sangat rendah (hingga -48.34), seringkali disertai nilai transaksi kecil. Pola ini muncul dominan pada flag `C` dan `D`, yang dapat mengindikasikan input error atau potensi fraud mikro.

Kedua kelompok ini sebaiknya dikeluarkan dari proses analisis dan modeling lanjutan karena dapat mempengaruhi akurasi segmentasi dan prediksi.
