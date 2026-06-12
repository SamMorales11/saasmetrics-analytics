-- =========================================================================
-- PROYEK    : SaaSMetrics - B2B SaaS User Cohort Retention & Churn Analysis
-- FILE      : 01_schema_setup.sql
-- DESKRIPSI : Pembuatan skema database relasional (DDL) dan optimasi indeks.
-- ENGINE    : PostgreSQL (Neon.tech Cloud Serverless)
-- =========================================================================

-- 1. Membersihkan tabel lama jika sudah ada (Idempotent Script)
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS users;

-- 2. Membuat Tabel Master Pengguna (Data Perusahaan Pelanggan B2B)
CREATE TABLE users (
    user_id VARCHAR(20) PRIMARY KEY,
    signup_date DATE NOT NULL,
    segment VARCHAR(20) NOT NULL CHECK (segment IN ('Startup', 'Growth', 'Enterprise'))
);

-- 3. Membuat Tabel Transaksi Langganan Bulanan (Fakta Transaksi)
CREATE TABLE transactions (
    transaction_id VARCHAR(20) PRIMARY KEY,
    user_id VARCHAR(20) REFERENCES users(user_id) ON DELETE CASCADE,
    transaction_date DATE NOT NULL,
    amount NUMERIC(10, 2) NOT NULL
);

-- 4. Membuat Indeks Komposit untuk Optimasi Query Analitik (Performance Tuning)
-- Indeks ini mempercepat proses query WINDOW FUNCTIONS dan JOIN berbasis urutan waktu.
CREATE INDEX idx_transactions_user_date ON transactions(user_id, transaction_date);

-- Verifikasi Struktur Skema
-- SELECT * FROM users LIMIT 5;
-- SELECT * FROM transactions LIMIT 5;