SELECT
    album.title AS album,
    sum(milliseconds) * interval '1 ms' AS duration
FROM
    album
    JOIN artist USING (artistid)
    LEFT JOIN track USING (albumid)
WHERE
    artist.name = 'Red Hot Chili Peppers'
GROUP BY
    album
ORDER BY
    album;

