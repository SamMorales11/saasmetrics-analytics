-- =========================================================================
-- PROYEK    : SaaSMetrics - B2B SaaS User Cohort Retention & Churn Analysis
-- FILE      : 03_financial_metrics.sql
-- DESKRIPSI : Perhitungan Unit Ekonomi Finansial (MRR, Growth, ARPU, Churn, CLV).
-- TEKNIK    : Window Function LAG(), Penanganan Pembagian Nol (NULLIF).
-- =========================================================================

-- TAHAP 1: Menghitung Metrik Finansial Agregat Dasar per Bulan Kalender
WITH monthly_metrics AS (
    SELECT
        DATE_TRUNC('month', transaction_date)::DATE AS calendar_month,
        COUNT(DISTINCT user_id) AS active_users,
        SUM(amount) AS total_mrr,
        AVG(amount) AS arpu
    FROM
        transactions
    GROUP BY
        1
),

-- TAHAP 2: Mengambil data bulan sebelumnya menggunakan Window Function LAG() untuk analisis MoM
metrics_with_lag AS (
    SELECT
        calendar_month,
        active_users,
        total_mrr,
        arpu,
        LAG(active_users) OVER (ORDER BY calendar_month) AS previous_month_users,
        LAG(total_mrr) OVER (ORDER BY calendar_month) AS previous_mrr
    FROM
        monthly_metrics
),

-- TAHAP 3: Menghitung Churn Rate Makro dan Laju Pertumbuhan MRR
calculated_business_metrics AS (
    SELECT
        calendar_month,
        active_users,
        total_mrr,
        arpu,
        -- Menghitung MoM MRR Growth Rate dengan proteksi NULLIF agar aman dari error division by zero
        ROUND(
            ((total_mrr - previous_mrr) / NULLIF(previous_mrr, 0)) * 100, 2
        ) AS mrr_growth_percent,
        
        -- Formula Net Macro Churn Rate (Melihat tren fluktuasi net user bulanan secara makro)
        ROUND(
            CASE 
                WHEN previous_month_users IS NULL THEN 0
                WHEN previous_month_users > active_users THEN 
                    ((previous_month_users - active_users)::NUMERIC / previous_month_users) * 100
                ELSE 0 
            END, 2
        ) AS net_macro_churn_percent
    FROM
        metrics_with_lag
)

-- TAHAP 4: Presentasi Data Akhir dengan Format Finansial dan Estimasi Customer Lifetime Value (CLV)
SELECT
    calendar_month,
    active_users,
    '$' || TO_CHAR(total_mrr, 'FM999,999,999') AS monthly_recurring_revenue,
    COALESCE(mrr_growth_percent || '%', '0.00%') AS mrr_growth_mom,
    '$' || ROUND(arpu, 2) AS average_revenue_per_user,
    net_macro_churn_percent || '%' AS net_macro_churn_rate,
    
    -- Formula Estimasi CLV: ARPU / Churn Rate
    CASE 
        WHEN net_macro_churn_percent > 0 THEN 
            '$' || ROUND((arpu / (net_macro_churn_percent / 100))::NUMERIC, 2)
        ELSE 'Highly Stable / Growing Month'
    END AS estimated_clv
FROM
    calculated_business_metrics
ORDER BY
    calendar_month;