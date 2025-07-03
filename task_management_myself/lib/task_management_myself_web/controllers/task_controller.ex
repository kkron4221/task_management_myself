defmodule TaskManagementMyselfWeb.TaskController do
  use TaskManagementMyselfWeb, :controller

  def index(conn, _params) do
    tasks = get_tasks()
    render(conn, :index, tasks: tasks)
  end

  def new(conn, _params) do
    render(conn, :new)
  end

  def create(conn, %{"task" => task_params}) do
    task = %{
      id: get_next_id(),
      title: task_params["title"]
    }

    tasks = get_tasks()
    updated_tasks = [task | tasks]
    save_tasks(updated_tasks)

    conn
    |> put_flash(:info, "Task created successfully.")
    |> redirect(to: ~p"/tasks")
  end

  def edit(conn, %{"id" => id}) do
    task = find_task(id)
    if task do
      render(conn, :edit, task: task)
    else
      conn
      |> put_flash(:error, "Task not found.")
      |> redirect(to: ~p"/tasks")
    end
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = find_task(id)
    if task do
      updated_task = %{task | title: task_params["title"]}
      tasks = get_tasks()
      updated_tasks = Enum.map(tasks, fn t -> if t.id == task.id, do: updated_task, else: t end)
      save_tasks(updated_tasks)

      conn
      |> put_flash(:info, "Task updated successfully.")
      |> redirect(to: ~p"/tasks")
    else
      conn
      |> put_flash(:error, "Task not found.")
      |> redirect(to: ~p"/tasks")
    end
  end

  def delete(conn, %{"id" => id}) do
    task = find_task(id)
    if task do
      tasks = get_tasks()
      updated_tasks = Enum.reject(tasks, fn t -> t.id == task.id end)
      save_tasks(updated_tasks)

      conn
      |> put_flash(:info, "Task deleted successfully.")
      |> redirect(to: ~p"/tasks")
    else
      conn
      |> put_flash(:error, "Task not found.")
      |> redirect(to: ~p"/tasks")
    end
  end

  defp get_tasks do
    case :ets.lookup(:tasks_table, :tasks) do
      [] ->
        default_tasks = [
          %{id: 1, title: "Sample1"},
          %{id: 2, title: "Sample2"},
          %{id: 3, title: "Sample3"}
        ]
        :ets.insert(:tasks_table, {:tasks, default_tasks})
        default_tasks
      [{:tasks, tasks}] -> tasks
    end
  end

  defp save_tasks(tasks) do
    :ets.insert(:tasks_table, {:tasks, tasks})
  end

  defp find_task(id) do
    id = String.to_integer(id)
    get_tasks() |> Enum.find(fn task -> task.id == id end)
  end

  defp get_next_id do
    tasks = get_tasks()
    case tasks do
      [] -> 1
      _ -> Enum.max_by(tasks, & &1.id).id + 1
    end
  end
end
