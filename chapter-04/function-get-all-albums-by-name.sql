CREATE OR REPLACE FUNCTION get_all_albums (IN name text, out album text, out duration interval)
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
        artist.name = get_all_albums.name
    GROUP BY
        album
    ORDER BY
        album;

$$;

