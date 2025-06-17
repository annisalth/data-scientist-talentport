# [1] RFM Score Analysis + Segmentasi Pelanggan
WITH max_date_cte AS (
  SELECT MAX(STR_TO_DATE(order_date, '%Y-%m-%d')) AS max_order_date
  FROM ecommerce_transactions
),

rfm_raw AS (
  SELECT 
    customer_id,
    MAX(STR_TO_DATE(order_date, '%Y-%m-%d')) AS last_order_date,
    COUNT(order_id) AS frequency,
    SUM(payment_value) AS monetary
  FROM ecommerce_transactions
  GROUP BY customer_id
),

## Semakin kecil nilai recency semakin dinilai bahwa customer tersebut aktif / baru-baru ini melakukan transaksi
rfm_with_recency AS (
  SELECT 
    r.*,
    DATEDIFF(m.max_order_date, r.last_order_date) AS recency
  FROM rfm_raw r, max_date_cte m
),

rfm_score AS (
  SELECT 
    customer_id,
    recency,
    frequency,
    monetary,
    NTILE(4) OVER (ORDER BY recency DESC) AS r_score,
    NTILE(4) OVER (ORDER BY frequency ASC) AS f_score,
    NTILE(4) OVER (ORDER BY monetary ASC) AS m_score
  FROM rfm_with_recency
),

rfm_segmented AS (
  SELECT *,
         CONCAT(r_score, f_score, m_score) AS rfm_segment,
         CASE
		-- Best Customers (444): sangat baru transaksi (R=4), sangat sering transaksi (F=4), dan nilai transaksi tinggi (M=4)
		-- Segmen ini adalah pelanggan paling berharga.
           WHEN r_score = 4 AND f_score = 4 AND m_score = 4 THEN 'Best Customers'     -- 444
           
		-- Loyal Customers (≥333): sering & rutin belanja dengan nilai cukup besar
		-- Belum tentu transaksi baru-baru ini, tapi menunjukkan konsistensi & loyalitas
           WHEN r_score >= 3 AND f_score >= 3 AND m_score >= 3 THEN 'Loyal Customers' -- ≥333
           
		-- Big Spenders (M=4): nilai transaksi besar, tapi belum tentu sering atau baru melakukan transaksi
           WHEN m_score = 4 THEN 'Big Spenders'                                       -- M=4
           
		-- Recent Buyers (R=4, F≤2): baru belanja, tapi belum loyal atau belanja dengan nilai besar
		-- Berpeluang untuk jadi loyal customer
           WHEN r_score = 4 AND f_score <= 2 THEN 'Recent Buyers'                     -- R=4, F≤2
           
		-- At Risk (R≤2, F≤2): jarang belanja dan tidak aktif melakukan transaksi
		-- Customer berpotensi churn, perlu diaktifkan kembali
           WHEN r_score <= 2 AND f_score <= 2 THEN 'At Risk'                          -- R≤2, F≤2
           
		-- Lost Customers (111): tidak aktif, sangat jarang transaksi, dan nilai transaksi kecil
		-- Kemungkinan besar sudah churn
           WHEN r_score = 1 AND f_score = 1 AND m_score = 1 THEN 'Lost'               -- 111
           
		-- Others: tidak masuk kategori manapun
           ELSE 'Others'
         END AS rfm_group
  FROM rfm_score
)

# Tampilkan Jumlah Customer per Segmen
SELECT 
  rfm_group,
  COUNT(*) AS total_customers
FROM rfm_segmented
GROUP BY rfm_group
ORDER BY total_customers DESC;

# [2] Repeat Purchase Analysis per Bulan
WITH purchase_per_month AS (
  SELECT
    customer_id,
    DATE_FORMAT(STR_TO_DATE(order_date, '%Y-%m-%d'), '%Y-%m') AS order_month,
    COUNT(order_id) AS order_count
  FROM ecommerce_transactions
  GROUP BY customer_id, order_month
),
repeat_customers AS (
  SELECT
    order_month,
    COUNT(*) AS repeat_buyers
  FROM purchase_per_month
  WHERE order_count > 1
  GROUP BY order_month
)
SELECT *
FROM repeat_customers
ORDER BY order_month;

# [3] EXPLAIN : query repeat-purchase
EXPLAIN
SELECT
  order_month,
  COUNT(*) AS repeat_customer_count
FROM (
  SELECT
    customer_id,
    DATE_FORMAT(STR_TO_DATE(order_date, '%Y-%m-%d'), '%Y-%m') AS order_month,
    COUNT(order_id) AS order_count
  FROM ecommerce_transactions
  GROUP BY customer_id, order_month
) AS monthly_orders
WHERE order_count > 1
GROUP BY order_month;

# cek dataset
-- Cek tanggal maksimum
-- SELECT MAX(STR_TO_DATE(order_date, '%Y-%m-%d')) AS max_date
-- FROM ecommerce_transactions;
