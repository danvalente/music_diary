defmodule MusicDiary.CredStore do
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

  def start_link(_args) do
    GenServer.start_link(
      __MODULE__,
      %{},
      name: __MODULE__
    )
  end

  def get_creds(username) do
    GenServer.call(__MODULE__, {:get, username})
  end

  def put_creds(username, tokens) do
    IO.puts("Storing tokens")
    GenServer.cast(__MODULE__, {:put, username, tokens})
  end

  @impl GenServer
  def init(_) do
   {:ok, %{}}
  end

  @impl GenServer
  def handle_cast({:put, username, tokens}, creds) do
    {:noreply, Map.put(creds, username, tokens)}
  end

  @impl GenServer
  def handle_call({:get, username}, _, creds) do
    if Map.has_key?(creds, username) do
      tokens = Map.get(creds, username)
      {:reply, tokens, creds}
    else
      new_creds = Map.put(creds, username, %Spotify.Credentials{})
      {:reply, Map.get(new_creds, username), new_creds}
    end
  end

end
