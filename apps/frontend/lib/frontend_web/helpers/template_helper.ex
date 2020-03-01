defmodule FrontendWeb.TemplateHelper do
  @website_name "Metagraph"
  def page_title(nil) do
    [@website_name, "Open Database"]
    |> Enum.join(" - ")
  end

  def page_title(title) do
    [title, @website_name]
    |> Enum.reject(&is_nil/1)
    |> Enum.join(" - ")
  end
end
