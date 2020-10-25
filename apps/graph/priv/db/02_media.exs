require Logger

Logger.debug("Inserting media schema")

"""
<media.budget>: int .
<media.revenue>: int .
<media.status>: uid .
<media.video>: bool .
<media.keyword>: uid @reverse .
<media.genre>: uid @reverse .
<media.origin_country>: uid @reverse .
<media.production_company>: uid @reverse .
<media.spinoff_from>: uid @reverse .
<media.franchise>: uid @reverse .
<media.franchise.after>: uid @reverse .
<media.franchise.prequel_to>: uid @reverse .
<media.imdb_id>: string @index(exact) .
<media.wikidata_id>: string @index(exact) .
<media.freebase_id>: string @index(exact) .
<media.themoviedb_id>: int @index(int) .
"""
|> Database.alter()
