defmodule FrontendWeb.ModalLive do
  use Phoenix.Component
  use Phoenix.HTML

  def render(assigns) do
    ~H"""
    <div :class="{ 'fixed z-10 inset-0 overflow-y-auto': show_modal}" x-show="show_modal" @keydown.escape="show_modal = false" x-cloak id="modal">
      <%#= render_block(@inner_block) %>
    </div>
    """
  end

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
