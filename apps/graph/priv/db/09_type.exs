require Logger

Logger.debug("Inserting type schema")

"""
<type.main>: bool @index(bool) .
<type.root_type>: uid @reverse .
<type.subtype_of>: uid @reverse .
<type.schema_org>: string .
<type.icon>: string .
<type.can_create>: bool @index(bool) .
"""
|> Database.alter()
