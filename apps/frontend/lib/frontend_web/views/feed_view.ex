defmodule FrontendWeb.FeedView do
  @moduledoc false

  use FrontendWeb, :view

  import Phoenix.HTML.SimplifiedHelpers.TimeAgoInWords
  import FrontendWeb.ItemHelpers
  import FrontendWeb.ChangeHelpers
end
