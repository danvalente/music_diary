defmodule MusicDiary.Database do
  use GenServer

  @table :danvalente_diary

  def start_link() do
    GenServer.start_link(
      __MODULE__,
      nil,
      name: __MODULE__)
  end

  def put(key, data) do
    GenServer.cast(__MODULE__, {:put, key, data})
  end

  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  @impl GenServer
  def init(_) do
    :dets.open_file(@table, [type: :set])
  end

  @impl GenServer
  def handle_cast({:put, key, data}, _) do
    {:noreply,
     :dets.insert_new(@table, {key, data})}
  end

  @impl GenServer
  def handle_call({:get, key}, _, _) do
    {:reply,
     :dets.lookup(@table, key),
     nil}
  end
end
