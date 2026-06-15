# SaaSMetrics: B2B SaaS User Cohort Retention & Churn Analysis for Revenue Optimization

## 📌 Project Overview
SaaSMetrics adalah proyek portofolio tingkat industri (*enterprise-grade*) yang berfokus penuh pada **Pure Data Analytics & Analytics Engineering**. Proyek ini mensimulasikan peran sebagai Senior Data Analyst dalam menganalisis data transaksi dari 1,000 pelanggan B2B SaaS sepanjang tahun 2025 untuk mengidentifikasi pola retensi pengguna menggunakan metode **Time-Based Cohort Analysis**, menghitung metrik finansial utama (MRR, Churn Rate, & CLV), serta merumuskan rekomendasi bisnis strategis untuk menekan angka kehilangan pelanggan (*revenue leakage*).

## 🛠️ Tech Stack & Architecture
* **Data Generation:** Python (Pandas & NumPy) untuk membuat mock-dataset transaksi SaaS relasional yang memiliki pola *decay* realistis.
* **Database & Cloud Infrastructure:** Neon.tech (Cloud Serverless PostgreSQL) untuk pengelolaan skema DDL, indeksasi, dan visualisasi *live-connection*.
* **Analytics Engine:** SQL (Advanced CTEs, Window Functions `FIRST_VALUE` & `LAG()`, serta *Conditional Aggregation* untuk pivot matriks).
* **Business Intelligence Tool:** Google Looker Studio untuk perancangan dasbor interaktif bergaya *Sanctuary Modern*.

---

## 📁 Repository Structure
```text
saasmetrics-analytics/
├── data/
│   ├── raw/                      # File CSV transaksi mentah (1,000 Users)
│   └── processed/                # Data bersih hasil ekstraksi data mart (.csv)
├── sql/
│   ├── 01_schema_setup.sql       # DDL Skema Relasional & Optimasi Indeks
│   ├── 02_cohort_matrix.sql      # Core Engine Perhitungan Matriks Kohort
│   └── 03_financial_metrics.sql  # Query SaaS Unit Economics MoM
├── scripts/
│   ├── generate_mock_data.py     # Generator data berbasis perilaku churn
│   ├── upload_to_neon.py         # Pipeline migrasi data lokal ke Cloud
│   └── export_processed_data.py  # Ekstraktor hasil query dari cloud ke lokal
└── README.md                     # Dokumentasi utama proyek
```

## 📊 Relational Data Schema
Proyek ini meninggalkan pendekatan tabel tunggal datar (flat table) dan menggunakan skema relasional yang mencerminkan arsitektur data industri nyata:

* **Users:** Menyimpan master data pelanggan (user_id, signup_date, segment [Startup, Growth, Enterprise]).
* **Transactions:** Menyimpan histori pembayaran bulanan fixed-rate (transaction_id, user_id, transaction_date, amount).
* **Optimasi Performa:** Ditambahkan komposit INDEX pada transactions(user_id, transaction_date) untuk mempercepat eksekusi query analitik beruntun waktu.

## 📈 Executive Dashboard Preview
<img width="1198" height="410" alt="Screenshot 2026-06-14 212912" src="https://github.com/user-attachments/assets/08760d20-6fb3-4a7d-b15b-f3882f1e440c" />

## 🎯 Deep-Dive Business Insights
## 1. Sindrom Ember Bocor (The Leaky Bucket Syndrome)
Meskipun data finansial bulanan menunjukkan pertumbuhan Monthly Recurring Revenue (MRR) yang sangat agresif (melonjak dari $16,537 pada Januari menjadi $81,335 pada Juni, dengan pertumbuhan tertinggi 61.56% di bulan April), analisis kohort mikro membongkar adanya masalah besar. Perusahaan mengalami kehilangan rata-rata 15% hingga 24% pelanggan baru hanya dalam 30 hari pertama (M0 ke M1). Pertumbuhan makro yang masif selama ini mendominasi dan menutupi tingkat gross churn yang mengkhawatirkan tersebut.

## 2. Anomali Sukses Kohort April
Kohort April 2025 menonjol sebagai performa terbaik sepanjang tahun. Selain mencatatkan volume akuisisi tertinggi (95 perusahaan baru), kohort ini mencatatkan tingkat retensi bulan pertama (M1) tertinggi, yaitu 87.4%.

## 3. Kerentanan Segmen Pelanggan
Melalui filter interaktif pada dasbor, ditemukan bahwa pelanggan dengan skala paket 'Startup' mengalami penurunan retensi tercepat di 90 hari pertama, sementara segmen 'Enterprise' menunjukkan tingkat loyalitas yang sangat tinggi dengan retensi stabil di atas 90%.

## 💡 Actionable Strategic Recommendations
* **Re-onboarding Strategy untuk Segmen Startup:** Tim Produk harus merombak alur 30 hari pertama pengguna baru. Diperlukan implementasi panduan interaktif (in-app interactive guidelines) untuk mempercepat Time-to-Value agar pelanggan dari skala Startup dapat segera merasakan manfaat produk sebelum siklus tagihan bulan kedua berjalan.

* **Audit Kanal Pemasaran April:** Tim Pemasaran wajib melakukan audit mendalam terhadap kampanye yang berjalan di bulan April. Karakteristik audiens dan kanal yang digunakan pada bulan tersebut harus diduplikasi karena terbukti berhasil menjaring pelanggan dengan tingkat loyalitas tinggi (High-Value Customers).

* **Early Warning System (EWS) untuk Customer Success:** Tim Data Analytics merekomendasikan pembuatan metrik pemicu (trigger metric) jika aktivitas transaksi pengguna melambat pada minggu ketiga, sehingga tim Customer Success dapat melakukan intervensi sebelum terjadi pembatalan otomatis (churn).

## 🏁 Langkah Terakhir di Terminal (Push Perubahan)

Setelah menyimpan file `README.md` di atas, buka terminal VS Code dan ketik perintah berikut untuk mengirimkan hasil final dashboard dan dokumentasi lengkap ini ke GitHub:

```bash
git add .
git commit -m "docs: finalize professional README with complete business insights"
git push origin main
```
