defmodule MusicDiary.DiaryWeb do
  use Plug.Router

  plug Plug.Logger, log: :debug
  plug :match

  plug Plug.Parsers, parsers: [:json],
                     pass:  ["application/json"],
                     json_decoder: Jason
  plug :dispatch

  def child_spec(_arg) do
    Plug.Cowboy.child_spec(scheme: :http,
      plug: __MODULE__,
      options: [port: Application.fetch_env!(:music_diary, :diary_port)])
  end

  post "/take-note" do
    username = Map.fetch!(conn.params, "username")
    note = Map.fetch!(conn.params, "note")
    metadata = MusicDiary.Current.get(username)

    MusicDiary.DiaryManager.get(username)
    |> MusicDiary.DiaryServer.add_entry(
      note,
      metadata)

    conn
    |> Plug.Conn.put_resp_content_type("text/plain")
    |> Plug.Conn.send_resp(200, "OK")
  end

  get "/favicon.ico" do
    # in case someone hits this from a browser
    conn
    |> Plug.Conn.send_resp(200, "OK")
  end

  match _ do
    conn
    |> send_resp(404, "Sorry. Nothing to see here.")
  end



end
