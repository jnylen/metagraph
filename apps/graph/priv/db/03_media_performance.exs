require Logger

Logger.debug("Inserting media performance schema")

"""
<performance.order>: int .
<performance.film>: uid @reverse .
<performance.version>: uid @reverse .
<performance.tv_episode>: uid @reverse .
<performance.spoken_language>: uid @reverse .
<performance.person>: uid @reverse .
<performance.role>: uid @reverse .
<performance.note>: string @lang .
"""
|> Database.alter()
|> IO.inspect