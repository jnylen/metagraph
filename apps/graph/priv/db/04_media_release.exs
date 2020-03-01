require Logger

Logger.debug("Inserting media release schema")

"""
<release.certification>: uid @reverse .
<release.country>: uid @reverse .
<release.date>: datetime @index(day) .
<release.note>: string @lang .
"""
|> Database.alter()
|> IO.inspect