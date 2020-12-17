BEGIN;
DROP TABLE IF EXISTS factbook;
CREATE TABLE factbook (
    year int,
    date date,
    shares text,
    trades text,
    dollars text
);
\copy factbook from 'factbook.csv' with delimiter E'\t' null ''
ALTER TABLE factbook
    ALTER shares TYPE bigint
    USING replace(shares, ',', '')::bigint,
    ALTER trades TYPE bigint
    USING replace(trades, ',', '')::bigint,
    ALTER dollars TYPE bigint
    USING substring(replace(dollars, ',', '') FROM 2)::numeric;
COMMIT;

