import sys
from datetime import timedelta

import psycopg2
import psycopg2.extras

DEBUGSQL = False
PG_CONNECTION_STRING = (
    "postgresql://postgres:password@localhost:6543/taop?application_name=cdstore"
)


class Model:
    tablename = None
    columns = None

    @classmethod
    def build_sql(cls, pgconn, **kwargs):
        if cls.tablename and kwargs:
            cols = ", ".join(
                ['"%s"' % c for c in cls.columns]  # pylint: disable=not-an-iterable
            )
            qtab = '"%s"' % cls.tablename
            sql = "SELECT %s FrOM %s WHERE " % (cols, qtab)
            for key in kwargs.keys():
                sql += "\"%s\" = '%s'" % (key, kwargs[key])
            if DEBUGSQL:
                print(sql)
            return sql

    @classmethod
    def fetch_one(cls, pgconn, **kwargs):
        if cls.tablename and kwargs:
            sql = cls.build_sql(pgconn, **kwargs)
            curs = pgconn.cursor(cursor_factory=psycopg2.extras.DictCursor)
            curs.execute(sql)
            result = curs.fetchone()
            if result is not None:
                return cls(*result)

    @classmethod
    def fetch_all(cls, pgconn, **kwargs):
        if cls.tablename and kwargs:
            sql = cls.build_sql(pgconn, **kwargs)
            curs = pgconn.cursor(cursor_factory=psycopg2.extras.DictCursor)
            curs.execute(sql)
            result_set = curs.fetchall()
            if result_set:
                return [cls(*result) for result in result_set]


class Artist(Model):
    tablename = "artist"
    columns = ["artistid", "name"]

    def __init__(self, id, name):
        self.id = id
        self.name = name


class Album(Model):
    tablename = "album"
    columns = ["albumid", "title"]

    def __init__(self, id, title):
        self.id = id
        self.title = title
        self.duration = None


class Track(Model):
    tablename = "track"
    columns = ["trackid", "name", "milliseconds", "bytes", "unitprice"]

    def __init__(self, id, name, milliseconds, bytes, unitprice):
        self.id = id
        self.name = name
        self.duration = milliseconds
        self.bytes = bytes
        self.unitprice = unitprice


if __name__ == "__main__":
    if len(sys.argv) > 1:
        pgconn = psycopg2.connect(PG_CONNECTION_STRING)
        artist = Artist.fetch_one(pgconn, name=sys.argv[1])

        for album in Album.fetch_all(pgconn, artistid=artist.id):
            ms = 0
            for track in Track.fetch_all(pgconn, albumid=album.id):
                ms += track.duration

            duration = timedelta(milliseconds=ms)
            print("%25s: %s" % (album.title, duration))
    else:
        print("albums.py <artist name>")
