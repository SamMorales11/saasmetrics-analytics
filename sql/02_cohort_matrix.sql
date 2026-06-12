-- =========================================================================
-- PROYEK    : SaaSMetrics - B2B SaaS User Cohort Retention & Churn Analysis
-- FILE      : 02_cohort_matrix.sql
-- DESKRIPSI : Transformasi data transaksi menjadi Matriks Retensi Kohort Waktu.
-- TEKNIK    : Common Table Expressions (CTEs), FIRST_VALUE Window Function, Pivot.
-- =========================================================================

-- TAHAP 1: Mengambil aktivitas unik per pengguna di setiap bulan (menghilangkan duplikasi transaksi di bulan yang sama)
WITH user_activities AS (
    SELECT DISTINCT
        user_id,
        DATE_TRUNC('month', transaction_date)::DATE AS activity_month
    FROM
        transactions
),

-- TAHAP 2: Menentukan Cohort Month secara dinamis menggunakan Window Function (FIRST_VALUE)
cohort_definition AS (
    SELECT
        user_id,
        activity_month,
        FIRST_VALUE(activity_month) OVER (
            PARTITION BY user_id 
            ORDER BY activity_month ASC
        ) AS cohort_month
    FROM
        user_activities
),

-- TAHAP 3: Menghitung selisih bulan (Cohort Index) untuk setiap aktivitas transaksi pelanggan
cohort_index_calc AS (
    SELECT
        user_id,
        cohort_month,
        activity_month,
        ((EXTRACT(YEAR FROM activity_month) - EXTRACT(YEAR FROM cohort_month)) * 12 +
         (EXTRACT(MONTH FROM activity_month) - EXTRACT(MONTH FROM cohort_month))) AS cohort_index
    FROM
        cohort_definition
),

-- TAHAP 4: Menghitung total ukuran unik pengguna dari setiap kelompok kohort pendaftaran (Denominator)
cohort_sizes AS (
    SELECT
        cohort_month,
        COUNT(DISTINCT user_id) AS total_users
    FROM
        cohort_definition
    GROUP BY
        1
),

-- TAHAP 5: Menggabungkan data untuk menghitung jumlah user aktif di setiap Index (M0 hingga M11)
retention_counts AS (
    SELECT
        c.cohort_month,
        s.total_users,
        c.cohort_index,
        COUNT(DISTINCT c.user_id) AS active_users
    FROM
        cohort_index_calc c
    JOIN
        cohort_sizes s ON c.cohort_month = s.cohort_month
    GROUP BY
        1, 2, 3
)

-- TAHAP 6: Melakukan Pivot horizontal menggunakan conditional aggregation untuk menghasilkan bentuk matriks final
SELECT
    cohort_month,
    total_users,
    MAX(CASE WHEN cohort_index = 0 THEN active_users END) AS m0,
    MAX(CASE WHEN cohort_index = 1 THEN active_users END) AS m1,
    MAX(CASE WHEN cohort_index = 2 THEN active_users END) AS m2,
    MAX(CASE WHEN cohort_index = 3 THEN active_users END) AS m3,
    MAX(CASE WHEN cohort_index = 4 THEN active_users END) AS m4,
    MAX(CASE WHEN cohort_index = 5 THEN active_users END) AS m5,
    MAX(CASE WHEN cohort_index = 6 THEN active_users END) AS m6,
    MAX(CASE WHEN cohort_index = 7 THEN active_users END) AS m7,
    MAX(CASE WHEN cohort_index = 8 THEN active_users END) AS m8,
    MAX(CASE WHEN cohort_index = 9 THEN active_users END) AS m9,
    MAX(CASE WHEN cohort_index = 10 THEN active_users END) AS m10,
    MAX(CASE WHEN cohort_index = 11 THEN active_users END) AS m11
FROM
    retention_counts
GROUP BY
    1, 2
ORDER BY
    cohort_month;