# SaaSMetrics: B2B SaaS User Cohort Retention & Churn Analysis for Revenue Optimization

## 📌 Project Overview
SaaSMetrics is an enterprise-grade portfolio project dedicated to Pure Data Analytics & Analytics Engineering. Simulating the responsibilities of a Senior Data Analyst, this project analyzes transactional data from 1,000 B2B SaaS customers across 2025 to uncover user retention trends through Time-Based Cohort Analysis. Furthermore, it evaluates critical SaaS unit economics—specifically MRR, Churn Rate, and CLV—to deliver data-driven, strategic business recommendations aimed at minimizing revenue leakage.

## 🛠️ Tech Stack & Architecture
* **Data Generation:** Python (Pandas & NumPy) utilized to synthesize a relational SaaS transactional mock-dataset embedded with realistic decay patterns.
* **Database & Cloud Infrastructure:** Neon.tech (Serverless Cloud PostgreSQL) deployed for DDL schema management, indexing optimization, and enabling real-time live-connection analytics.
* **Analytics Engine:** SQL (leveraging Advanced CTEs, Window Functions such as `FIRST_VALUE` and `LAG()`, and Conditional Aggregation to dynamically pivot the cohort matrix).
* **Business Intelligence Tool:** Google Looker Studio used to architect an interactive executive dashboard styled with a clean and professional *Sanctuary Modern* aesthetic.

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

* **Users:** Stores customer master data, capturing critical attributes including `user_id`, `signup_date`, and business `segment` (Startup, Growth, Enterprise).
* **Transactions:** Maintains chronological monthly fixed-rate payment history logs, recording `transaction_id`, `user_id`, `transaction_date`, and billing `amount`.
* **Optimasi Performa:** Engineered a composite `INDEX` on `transactions(user_id, transaction_date)` to significantly accelerate the execution speed of sequential, time-series analytical queries.

## 📈 Executive Dashboard Preview
<img width="1198" height="410" alt="Screenshot 2026-06-14 212912" src="https://github.com/user-attachments/assets/08760d20-6fb3-4a7d-b15b-f3882f1e440c" />

## 🎯 Deep-Dive Business Insights
## 1. The Leaky Bucket Syndrome
While monthly financial metrics indicate aggressive Monthly Recurring Revenue (MRR) growth—surging from $16,537 in January to $81,335 in June, peaking with a 61.56% MoM growth rate in April—micro-cohort analysis exposes a critical underlying vulnerability. The company suffers an average drop-off of 15% to 24% of new users within their first 30 days (`M0` to `M1`). This massive macro-level revenue growth has heavily masked an alarming underlying gross churn rate.

## 2. The April Cohort Anomaly
The April 2025 cohort stands out as the top performer of the year. In addition to driving the highest acquisition volume with 95 new company registrations, this specific cohort achieved the highest month-one (`M1`) retention rate at 87.4%.

## 3. Customer Segment Vulnerabilities
Utilizing the interactive dashboard filters reveals that customer retention decays fastest within the first 90 days among users in the 'Startup' tier. Conversely, the 'Enterprise' segment demonstrates exceptional long-term loyalty, maintaining a highly stable retention rate consistently above 90%.

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
