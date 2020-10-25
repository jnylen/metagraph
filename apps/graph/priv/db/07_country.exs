require Logger

Logger.debug("Inserting country schema")

"""
<country.iso_3166_code>: string @index(exact) .
<country.exist>: bool .
"""
|> Database.alter()
