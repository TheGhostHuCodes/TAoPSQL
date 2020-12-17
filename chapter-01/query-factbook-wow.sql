\set start '2017-02-01'
WITH computed_data AS (
    SELECT
        cast(date AS date) AS date,
        to_char(date, 'Dy') AS day,
        coalesce(dollars, 0) AS dollars,
        lag(dollars, 1) OVER (PARTITION BY extract('isodow' FROM date) ORDER BY date) AS last_week_dollars
    FROM
        /*
         * Generate the target month's calendar then LEFT JOIN each day against the
         * factbook dataset, so as to have every day in the result set, whether or
         * not we have a book entry for the day.
         */
        generate_series(date :'start' - interval '1 week', date :'start' + interval '1 month' - interval '1 day', interval '1 day') AS calendar (date)
        LEFT JOIN factbook USING (date))
SELECT
    date,
    day,
    to_char(coalesce(dollars, 0), 'L99G999G999G999') AS dollars,
    CASE WHEN dollars IS NOT NULL
        AND dollars <> 0 THEN
        round(100.0 * (dollars - last_week_dollars) / dollars, 2)
    END AS "WoW %"
FROM
    computed_data
WHERE
    date >= date :'start'
ORDER BY
    date;

