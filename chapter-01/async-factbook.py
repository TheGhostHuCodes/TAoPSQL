import asyncio
import datetime
import sys
from calendar import Calendar

import asyncpg

CONNECTION_STRING = (
    "postgresql://postgres:password@localhost:6543/postgres?application_name=factbook"
)


async def fetch_month_data(year: int, month: int):
    """Fetch a month of data from the database."""
    date = datetime.date(year, month, 1)
    sql = """
    SELECT date, shares, trades, dollars
    FROM factbook
    WHERE date >= $1::date
    AND date < $1::date + interval '1 month'
    ORDER BY date;
    """
    pgconn = await asyncpg.connect(CONNECTION_STRING)
    stmt = await pgconn.prepare(sql)

    res = {}
    for (date, shares, trades, dollars) in await stmt.fetch(date):
        res[date] = (shares, trades, dollars)

    await pgconn.close()

    return res


def list_book_for_month(year: int, month: int):
    """List all days for given month, and for each day list factbook
    entry.
    """
    data = asyncio.run(fetch_month_data(year, month))
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
