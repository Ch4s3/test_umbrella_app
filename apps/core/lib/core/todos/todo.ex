defmodule Core.Todos.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todos" do
    field :title, :string
    field :description, :string
    field :completed, :boolean, default: false
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    # Type error: validate_required expects a list of atoms, but we're passing a string
    # This will cause Dialyzer to report a type error
    todo
    |> cast(attrs, [:title, :description, :completed, :user_id])
    |> validate_required("title")
  end
end
