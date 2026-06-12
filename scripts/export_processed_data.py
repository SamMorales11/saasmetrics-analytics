import pandas as pd
from sqlalchemy import create_engine
import os

# 1. Gunakan Connection String Neon milikmu
NEON_CONN_STRING = "postgresql://USER:PASSWORD@HOST/neondb?sslmode=require"

# 2. Ambil Query SQL Cohort Matrix yang sudah kita buat di Fase 2
cohort_query = """
WITH user_activities AS (
    SELECT DISTINCT
        user_id,
        DATE_TRUNC('month', transaction_date)::DATE AS activity_month
    FROM
        transactions
),
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
cohort_sizes AS (
    SELECT
        cohort_month,
        COUNT(DISTINCT user_id) AS total_users
    FROM
        cohort_definition
    GROUP BY
        1
),
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
"""

try:
    print("Menghubungkan ke Neon.tech untuk mengekstrak data mart...")
    engine = create_engine(NEON_CONN_STRING)
    
    # Menjalankan query dan langsung mengubahnya menjadi Pandas DataFrame
    df_cohort_final = pd.read_sql(cohort_query, engine)
    
    # Memastikan folder data/processed sudah terbuat
    os.makedirs('data/processed', exist_ok=True)
    
    # Menyimpan hasil akhir ke folder processed
    output_path = 'data/processed/final_cohort_matrix.csv'
    df_cohort_final.to_csv(output_path, index=False)
    
    print(f"✅ Sukses! Hasil pemrosesan data disimpan di: {output_path}")

except Exception as e:
    print(f"Terjadi kesalahan saat mengekstrak data: {e}")