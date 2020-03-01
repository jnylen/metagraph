schemas =
  (File.ls!("./priv/db/") -- ["00_all.exs"])
  |> Enum.sort()

Enum.each(schemas, fn file ->
  Code.eval_file("./priv/db/#{file}")
end)
