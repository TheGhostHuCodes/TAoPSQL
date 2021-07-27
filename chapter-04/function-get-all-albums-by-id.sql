CREATE OR REPLACE FUNCTION get_all_albums (IN artistid bigint, out album text, out duration interval)
    RETURNS SETOF record
    LANGUAGE sql
    AS $$
    SELECT
        album.title AS album,
        sum(milliseconds) * interval '1 ms' AS duration
    FROM
        album
        JOIN artist USING (artistid)
        LEFT JOIN track USING (albumid)
    WHERE
        artist.artistid = get_all_albums.artistid
    GROUP BY
        album
    ORDER BY
        album;

$$;

