defmodule Worker.Editor.Auditor do
  use Que.Worker

  def perform(%{action: action, actor: actor_id, subject: subject, changes: changes}) do
    actor = Database.Repo.get(Database.Account, actor_id)

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
