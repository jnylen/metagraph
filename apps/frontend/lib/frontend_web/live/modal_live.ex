defmodule FrontendWeb.ModalLive do
  use FrontendWeb, :live_component

  def types(domain) do
    FrontendWeb.ItemHelpers.get_predicate_types(
      domain.depends_on,
      domain.depends_on.__schema__(:alter),
      domain.depends_on.__schema__(:field_config)
    )
  end

  def domain_label(domain),
    do: Keyword.get(domain.depends_on.__schema__(:node_config), :label)
end
