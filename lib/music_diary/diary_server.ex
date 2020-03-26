defmodule MusicDiary.DiaryServer do
  use GenServer

 def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end

  #Public API
  def start_link(name) do
    GenServer.start_link(
      __MODULE__,
      nil,
      name: via_tuple(name)
    )
  end

  def add_entry(pid, note, metadata) do
    #Arguable that this should ba a cast vs. call
    GenServer.cast(pid, {:add, note, metadata})
  end

  def get_entries_by_metadata(pid, key, value) do
    GenServer.call(pid, {:get_entries_by_metadata, key, value})
  end

  def get_entries_by_metadata(pid, timestamp) do
    GenServer.call(pid, {:get_entries_by_timestamp, timestamp})
  end

  # required GenServer functions
  @impl GenServer
  def init(_) do
    MusicDiary.Database.start_link()
    {:ok, MusicDiary.Diary.new()}
  end

  @impl GenServer
  def handle_cast({:add, note, metadata},  diary) do
    now = DateTime.utc_now()
    entry = MusicDiary.Diary.create_diary_entry(now, note, metadata)
    data = MusicDiary.Diary.add_diary_entry(diary, entry)
    #persist in DB
    MusicDiary.Database.put(now, entry)
    {:noreply,
    data
    }
  end

  @impl GenServer
  def handle_call({:get_entries_by_metadata, key, value}, _, diary) do
    {:reply,
     MusicDiary.Diary.get_entries_by_metadata(diary, key, value),
     diary}
  end

  @impl GenServer
  def handle_call({:get_entries_by_timestamp, timestamp}, _, diary) do
    {:reply,
     MusicDiary.Diary.get_entries_by_timestamp(diary, timestamp),
     diary}
  end

  defp via_tuple(name) do
    MusicDiary.Registry.via_tuple(name)
  end

end
