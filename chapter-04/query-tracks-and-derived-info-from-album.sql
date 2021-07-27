SELECT
    name,
    milliseconds * interval '1 ms' AS duration,
    pg_size_pretty(bytes) AS bytes
FROM
    track
WHERE
    albumid = 193
ORDER BY
    trackid;

