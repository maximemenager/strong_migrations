defmodule Mix.Tasks.StrongMigrations.Check do
  @moduledoc """
  Task which is an additional layer between the Ecto and StrongMigrations.
  Thanks to that we could run analyze of migrations and if it's fine - just run `ecto.migrate` task
  """

  use Mix.Task
  require Logger

  alias StrongMigrations

  def run(_args) do
    case StrongMigrations.analyze() do
      :safe ->
        exit({:shutdown, 0})

      {:unsafe, reasons} ->
        reasons
        |> Enum.each(&Logger.warn/1)

        handle_reasons(reasons)
    end
  end

  defp handle_reasons(reasons) do
    Logger.error("Found #{length(reasons)} unsafe migrations!")
    exit({:shutdown, 1})
  end
end
