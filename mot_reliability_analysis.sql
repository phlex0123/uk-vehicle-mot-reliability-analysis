CREATE TABLE mot_reliability (
    make VARCHAR(100),
    model VARCHAR(100),
    fuel_type VARCHAR(50),
    model_year INTEGER,
    mileage_band VARCHAR(30),
    tests INTEGER,
    passes INTEGER,
    final_failures INTEGER,
    prs INTEGER,
    initial_failure_rate NUMERIC(10,4),
    final_failure_rate NUMERIC(10,4),
    median_mileage INTEGER,
    data_year INTEGER,
    source_file VARCHAR(150)
);

SELECT COUNT(*)
FROM mot_reliability;

SELECT *
FROM mot_reliability
LIMIT 10;

SELECT
    COUNT(*) FILTER (WHERE make IS NULL) AS missing_make,
    COUNT(*) FILTER (WHERE model IS NULL) AS missing_model,
    COUNT(*) FILTER (WHERE fuel_type IS NULL) AS missing_fuel_type,
    COUNT(*) FILTER (WHERE model_year IS NULL) AS missing_model_year,
    COUNT(*) FILTER (WHERE tests IS NULL) AS missing_tests,
    COUNT(*) FILTER (WHERE passes IS NULL) AS missing_passes,
    COUNT(*) FILTER (WHERE final_failures IS NULL) AS missing_failures
FROM mot_reliability;

SELECT *
FROM mot_reliability
WHERE tests <> (passes + final_failures + prs);

SELECT
    make,
    model,
    fuel_type,
    model_year,
    mileage_band,
    COUNT(*) AS record_count
FROM mot_reliability
GROUP BY
    make,
    model,
    fuel_type,
    model_year,
    mileage_band
HAVING COUNT(*) > 1;

SELECT
    COUNT(*) AS total_cohorts,
    COUNT(DISTINCT make) AS total_manufacturers,
    COUNT(DISTINCT model) AS total_models,
    COUNT(DISTINCT fuel_type) AS fuel_types,
    MIN(model_year) AS oldest_model_year,
    MAX(model_year) AS newest_model_year,
    SUM(tests) AS total_tests,
    SUM(passes) AS total_passes,
    SUM(final_failures) AS total_failures,
    SUM(prs) AS total_prs,
    ROUND(
        SUM(final_failures)::NUMERIC /
        SUM(tests) * 100, 2
    ) AS overall_failure_rate
FROM mot_reliability;


SELECT
    make,
    SUM(tests) AS total_tests,
    SUM(final_failures) AS total_failures,

    ROUND(
        SUM(final_failures)::NUMERIC /
        SUM(tests) * 100, 2
    ) AS failure_rate,

    ROUND(
        SUM(prs)::NUMERIC /
        SUM(tests) * 100, 2
    ) AS prs_rate

FROM mot_reliability

GROUP BY make

ORDER BY failure_rate DESC


SELECT
    make,
    model,
    SUM(tests) AS total_tests,
    SUM(final_failures) AS total_failures,

    ROUND(
        SUM(final_failures)::NUMERIC /
        SUM(tests) * 100, 2
    ) AS failure_rate

FROM mot_reliability

GROUP BY
    make,
    model

HAVING SUM(tests) >= 1000

ORDER BY failure_rate DESC

LIMIT 15;

SELECT
    2025 - model_year AS vehicle_age,
    SUM(tests) AS total_tests,
    SUM(final_failures) AS total_failures,

    ROUND(
        SUM(final_failures)::NUMERIC /
        SUM(tests) * 100, 2
    ) AS failure_rate

FROM mot_reliability

GROUP BY model_year

ORDER BY vehicle_age DESC;

SELECT
    mileage_band,
    SUM(tests) AS total_tests,
    SUM(final_failures) AS total_failures,

    ROUND(
        SUM(final_failures)::NUMERIC /
        SUM(tests) * 100, 2
    ) AS failure_rate

FROM mot_reliability

GROUP BY mileage_band

ORDER BY
    CASE mileage_band
        WHEN '0-30k' THEN 1
        WHEN '30-60k' THEN 2
        WHEN '60-90k' THEN 3
        WHEN '90-120k' THEN 4
        WHEN '120k+' THEN 5
    END;


SELECT
    fuel_type,
    SUM(tests) AS total_tests,
    SUM(final_failures) AS total_failures,

    ROUND(
        SUM(final_failures)::NUMERIC /
        SUM(tests) * 100, 2
    ) AS failure_rate,

    ROUND(
        SUM(prs)::NUMERIC /
        SUM(tests) * 100, 2
    ) AS prs_rate

FROM mot_reliability

GROUP BY fuel_type

ORDER BY failure_rate DESC;


SELECT
    make,
    model,
    fuel_type,
    model_year,
    mileage_band,

    SUM(tests) AS total_tests,
    SUM(final_failures) AS total_failures,

    ROUND(
        SUM(final_failures)::NUMERIC /
        SUM(tests) * 100, 2
    ) AS failure_rate

FROM mot_reliability

GROUP BY
    make,
    model,
    fuel_type,
    model_year,
    mileage_band

HAVING SUM(tests) >= 1000

ORDER BY failure_rate DESC

LIMIT 20;
