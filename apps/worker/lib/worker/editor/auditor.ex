defmodule Worker.Editor.Auditor do
  use Que.Worker

  def perform(%{action: action, actor: actor, subject: subject, changes: changes}) do
    %Database.Media.Change{}
    |> Database.Media.Change.changeset(%{
      action: action |> to_string(),
      actor: actor,
      subject: subject.uid,
      changes: changes
    })
    |> Database.Repo.insert()
  end
end
