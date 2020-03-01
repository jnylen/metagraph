require Logger

Logger.debug("Inserting media version schema")

"""
<media.runtime>: int .
<version.film>: uid @reverse .
<version.release>: uid @reverse .
"""
|> Database.alter()
|> IO.inspect