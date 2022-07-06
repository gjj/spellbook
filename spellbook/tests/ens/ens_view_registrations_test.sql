-- Bootstrapped correctness test against legacy Postgres values.

-- Also manually check etherscan info for the first 5 rows
WITH unit_tests AS (
    SELECT 
        CASE WHEN test_date.label = ens_vr.label
            AND test_date.evt_block_number = ens_vr.evt_block_number THEN TRUE 
        ELSE False 
        END AS evt_block_number_test
    FROM {{ ref('ens_view_registrations') }} AS ens_vr
    JOIN {{ ref('ens_view_registrations_postgres') }} AS test_date 
        ON test_date.label = ens_vr.label
)
SELECT
    COUNT(*) AS count_rows,
    COUNT(CASE WHEN evt_block_number_test = FALSE THEN 1 ELSE NULL END)/COUNT(*) AS pct_mismatch
FROM unit_tests 
HAVING COUNT(CASE WHEN evt_block_number_test = FALSE THEN 1 ELSE NULL END) > COUNT(*)*0.05