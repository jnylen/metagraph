require Logger

Logger.debug("Inserting language schema")

"""
<language.country>: uid @reverse .
<language.code>: string @index(exact) .
"""
|> Database.alter()
