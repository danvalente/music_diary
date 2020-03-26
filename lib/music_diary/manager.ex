defmodule MusicDiary.DiaryManager do
  use DynamicSupervisor

  def start_link(_args) do
    DynamicSupervisor.start_link(
      __MODULE__,
      nil,
      name: __MODULE__)
  end

  defp start_child(diary_name) do
    DynamicSupervisor.start_child(
      __MODULE__,
      {MusicDiary.DiaryServer, diary_name}
    )
  end

  @impl true
  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def get(diary_name) do
    case start_child(diary_name) do
      {:ok, pid} -> pid
      {:error, {:already_started, pid}} -> pid
      _ -> :error
    end
  end

end
