defmodule Core.Repo.Migrations.CreateTodos do
  use Ecto.Migration

  def change do
    create table(:todos) do
      add :title, :string, null: false
      add :description, :string
      add :completed, :boolean, default: false, null: false
      add :user_id, :integer

      timestamps()
    end

    create index(:todos, [:user_id])
  end
end
