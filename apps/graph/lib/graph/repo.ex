defmodule Graph.Repo do
  use Dlex.Repo,
    otp_app: :graph,
    modules: [
      Graph.Film,
      Graph.Tv,
      Graph.Media.Genre,
      Graph.Person,
      Graph.Bloodtype,
      Graph.Mediator.Performance
    ]
end
