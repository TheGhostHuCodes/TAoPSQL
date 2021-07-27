CREATE OR REPLACE FUNCTION get_all_albums (IN name text, out album text, out duration interval)
    RETURNS SETOF record
    LANGUAGE plpgsql
    AS $$
DECLARE
    rec record;
BEGIN
    FOR rec IN
    SELECT
        albumid
    FROM
        album
        JOIN artist USING (artistid)
    WHERE
        artist.name = get_all_albums.name LOOP
            SELECT
                title,
                sum(milliseconds) * interval '1ms' INTO album,
                duration
            FROM
                album
            LEFT JOIN track USING (albumid)
        WHERE
            albumid = rec.albumid
        GROUP BY
            title
        ORDER BY
            title;
            RETURN NEXT;
        END LOOP;
END;
$$;

