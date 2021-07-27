SELECT
    album,
    duration
FROM
    artist,
    LATERAL get_all_albums (artistid)
WHERE
    artist.name = 'Red Hot Chili Peppers';

