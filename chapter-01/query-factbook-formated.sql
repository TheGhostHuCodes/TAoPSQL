\set start '2017-02-01'
SELECT
    cast(calendar.entry AS date) AS date,
    coalesce(shares, 0) AS shares,
    coalesce(trades, 0) AS trades,
    to_char(coalesce(dollars, 0), 'L99G999G999G999') AS dollars
FROM
    /*
     * Generate the target month's calendar then LEFT JOIN each day against the
     * factbook dataset, so as to have every day in the result set, whether or
     * not we have a book entry for the day.
     */
    generate_series(date :'start', date :'start' + interval '1 month' - interval '1 day', interval '1 day') AS calendar (entry)
    LEFT JOIN factbook ON factbook.date = calendar.entry
ORDER BY
    date;

