defmodule MusicDiary.AuthServer do
  #Note: have to figure out token refreshing!"
  use Plug.Router

  plug Plug.Logger, log: :debug
  plug :match
  plug :dispatch

  def child_spec(_arg) do
    Plug.Cowboy.child_spec(scheme: :http,
      plug: __MODULE__,
      options: [port: Application.fetch_env!(:music_diary, :auth_port)])
  end

  get "/" do
    url = Spotify.Authorization.url
    body = "<html><body>Click <a href=\"#{url}\">here</a> to authorize.</body></html>"

    conn
    |> Plug.Conn.put_resp_content_type("text/html")
    |> Plug.Conn.send_resp(200, body)
  end

  get "/authorize" do
    authenticate(conn)

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Success")
  end

  get "/favicon.ico" do
    # what is this crap. browser flow needs this route or things will fail.
    conn
    |> Plug.Conn.send_resp(200, "OK")
  end

  match _ do
    conn
    |> send_resp(404, "Sorry. Nothing to see here.")
  end

  defp authenticate(conn) do
    conn = Plug.Conn.fetch_query_params(conn)
    {:ok, creds} = Spotify.Authentication.authenticate(conn, conn.params)
    username = MusicDiary.UserUtils.get_user_id(creds)
    # make sure to persist the credentials for later!
    MusicDiary.CredStore.put_creds(username, creds)
  end
end
