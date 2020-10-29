defmodule FrontendWeb.FeedView do
  @moduledoc false

  use FrontendWeb, :view
  use Scrivener.HTML

  import FrontendWeb.ItemHelpers
  import FrontendWeb.ChangeHelpers
end
