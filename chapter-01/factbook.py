#!/usr/bin/env python

import sys
from calendar import Calendar

import psycopg2
import psycopg2.extras

CONNECTIONSTRING = "dbname=postgres host=localhost port=6543 user=postgres password=password application_name=factbook"


def fetch_month_data(year: int, month: int):
    """Fetch a month of data from the database."""
    date = "%d-%02d-01" % (year, month)
    sql = """
    SELECT date, shares, trades, dollars
    FROM factbook
    WHERE date >= date %s
    AND date < date %s + interval '1 month'
    ORDER BY date;
    """
    pgconn = psycopg2.connect(CONNECTIONSTRING)
    curs = pgconn.cursor()
    curs.execute(sql, (date, date))
    res = {}
    for (date, shares, trades, dollars) in curs.fetchall():
        res[date] = (shares, trades, dollars)
    return res


def list_book_for_month(year: int, month: int):
    """List all days for given month, and for each day list factbook
    entry.
    """
    data = fetch_month_data(year, month)
    cal = Calendar()
    print("%12s | %12s | %12s | %12s" % ("day", "shares", "trades", "dollars"))
    print("%12s-+-%12s-+-%12s-+-%12s" % ("-" * 12, "-" * 12, "-" * 12, "-" * 12))

    for day in cal.itermonthdates(year, month):
        if day.month != month:
            continue
        if day in data:
            shares, trades, dollars = data[day]
        else:
            shares, trades, dollars = 0, 0, 0
        print("%12s | %12s | %12s | %12s" % (day, shares, trades, dollars))


if __name__ == "__main__":
    year = int(sys.argv[1])
    month = int(sys.argv[2])

    list_book_for_month(year, month)
