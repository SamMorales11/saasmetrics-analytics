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

