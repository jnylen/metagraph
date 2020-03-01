require Logger

Logger.debug("Inserting media certification schema")

"""
<certification.country>: uid @reverse .
<certification.order>: int .
"""
|> Database.alter()
|> IO.inspect()
