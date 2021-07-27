SELECT
    track.name AS track,
    genre.name AS genre
FROM
    track
    JOIN genre USING (genreid)
WHERE
    albumid = 193
ORDER BY
    trackid;

