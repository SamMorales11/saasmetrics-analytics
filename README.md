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
