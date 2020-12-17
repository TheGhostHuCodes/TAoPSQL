PREPARE my_query AS
SELECT
    date,
    shares,
    trades,
    dollars
FROM
    factbook
WHERE
    date >= $1::date
    AND date < $1::date + interval '1 month'
ORDER BY
    date;

