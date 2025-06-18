# Data Scientist Technical Test – Talentport

Repositori ini berisi jawaban dari technical test untuk posisi Data Scientist.


## ▶️ Cara Menjalankan Proyek

### 🔹 Bagian A – SQL Analytics
- Buka `analysis.sql` menggunakan MySQL Workbench.
- Jalankan setiap query sesuai urutan.
- File `A_findings.md` berisi ringkasan hasil segmentasi & anomali.

### 🔹 Bagian B – Python Modeling
- Buka `notebooks/B_Modeling.ipynb` menggunakan Jupyter Notebook atau Google Colab.
- Jalankan semua sel dari awal hingga akhir.
- Model menghasilkan file `model_output.csv` sebagai input untuk bagian C.
- Ringkasan insight model disajikan di `B_findings.md`.
- decision slide terlampir di link (https://drive.google.com/file/d/1sFOlUHLri4nuan8-DFo9b6Jpt5h93Zw2/view?usp=sharing)

### 🔹 Bagian C – R Validation
- Buka `validation.R` menggunakan RStudio.
- Jalankan seluruh script untuk menghasilkan:
  - Hosmer–Lemeshow Test
  - Calibration Curve (`calibration_curve.png`)
  - Cut-off Score
- Ringkasan hasil terdapat di `C_summary.md`

## 📝 Catatan
- Semua dataset disimpan dalam folder `data/`
- File hasil visualisasi seperti `calibration_curve.png` disimpan otomatis ketika melakukan running

---

Terima kasih.
