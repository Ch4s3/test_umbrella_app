defmodule Web.Live.TodoLive do
  use Web, :live_view

  alias Core.Todos
  alias Core.Todos.Todo

  @impl true
  def mount(_params, _session, socket) do
    todos = Todos.list_todos()
    changeset = Todo.changeset(%Todo{}, %{})

    {:ok,
     socket
     |> assign(:todos, todos)
     |> assign(:form, to_form(changeset))}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", %{"todo" => todo_params}, socket) do
    changeset =
      %Todo{}
      |> Todo.changeset(todo_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  @impl true
  def handle_event("save", %{"todo" => todo_params}, socket) do
    case Todos.create_todo(todo_params) do
      {:ok, _todo} ->
        todos = Todos.list_todos()
        changeset = Todo.changeset(%Todo{}, %{})

        {:noreply,
         socket
         |> put_flash(:info, "Todo created successfully")
         |> assign(:todos, todos)
         |> assign(:form, to_form(changeset))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  @impl true
  def handle_event("toggle", %{"id" => id}, socket) do
    todo = Todos.get_todo!(id)
    attrs = %{completed: !todo.completed}

    case Todos.update_todo(todo, attrs) do
      {:ok, _todo} ->
        todos = Todos.list_todos()
        {:noreply, assign(socket, :todos, todos)}

      {:error, _changeset} ->
        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    todo = Todos.get_todo!(id)
    {:ok, _todo} = Todos.delete_todo(todo)

    todos = Todos.list_todos()
    {:noreply, assign(socket, :todos, todos)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container mx-auto px-4 py-8">
      <h1 class="text-3xl font-bold mb-6">Todo List</h1>

      <.form
        for={@form}
        phx-submit="save"
        phx-change="validate"
        class="mb-8"
      >
        <.input field={@form[:title]} label="Title" />
        <.input field={@form[:description]} label="Description" type="textarea" />

        <div class="mt-4">
          <.button>Add Todo</.button>
        </div>
      </.form>

      <div class="space-y-2">
        <%= for todo <- @todos do %>
          <div class="flex items-center gap-4 p-4 border rounded">
            <input
              type="checkbox"
              checked={todo.completed}
              phx-click="toggle"
              phx-value-id={todo.id}
              class="w-4 h-4"
            />
            <div class="flex-1">
              <h3 class={if todo.completed, do: "line-through text-gray-500", else: "font-semibold"}>
                <%= todo.title %>
              </h3>
              <%= if todo.description do %>
                <p class="text-sm text-gray-600"><%= todo.description %></p>
              <% end %>
            </div>
            <button
              phx-click="delete"
              phx-value-id={todo.id}
              class="text-red-600 hover:text-red-800"
            >
              Delete
            </button>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
