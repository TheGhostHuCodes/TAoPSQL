WITH four_albums AS (
    SELECT
        artistid
    FROM
        album
    GROUP BY
        artistid
    HAVING
        count(*) = 4
)
SELECT
    artist.name,
    album,
    duration
FROM
    four_albums
    JOIN artist USING (artistid),
    LATERAL get_all_albums (artistid)
ORDER BY
    artistid,
    duration DESC;

