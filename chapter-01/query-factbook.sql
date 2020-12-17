\set start '2017-02-01'
SELECT
    date,
    to_char(shares, '99G999G999G999') AS shares,
    to_char(trades, '99G999G999') AS trades,
    to_char(dollars, 'L99G999G999G999') AS dollars
FROM
    factbook
WHERE
    date >= date :'start'
    AND date < date :'start' + interval '1 month'
ORDER BY
    date;

