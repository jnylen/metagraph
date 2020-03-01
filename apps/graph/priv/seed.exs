require Logger

# Runs the seeds
# Types
type_data = Jason.decode!(File.read!("./priv/data/type.json"))

Logger.debug("Starts the type creation")

for type <- type_data do
  %{
    "common.label@en_GB" => type["common.label@en"],
    "common.description@en_GB" => type["common.description@en"],
    "type.schema_org" => type["type.schema_org"],
    "type.icon" => type["type.icon"],
    "type.main" => type["type.main"],
    "type.can_create" => type["type.can_create"]
  }
  |> Database.Helper.Seed.add_predicate?("type", type["type"])
  |> Database.Helper.Seed.add_predicate?("type.root_type", type["type.root_type"])
  |> Database.Helper.Seed.add_predicate?("type.subtype_of", type["type.subtype_of"])
  |> Database.mutate()
end
