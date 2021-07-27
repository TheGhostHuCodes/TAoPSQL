SELECT
    *
FROM
    get_all_albums ((
        SELECT
            artistid FROM artist
        WHERE
            name = 'Red Hot Chili Peppers'));

