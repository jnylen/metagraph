require Logger

Logger.debug("Inserting core schema")

"""
<type>: uid @reverse .
<common.label>: string @index(fulltext) @lang .
<common.description>: string @index(fulltext) @lang .
<common.website>: string .
"""
|> Database.alter()
|> IO.inspect()
