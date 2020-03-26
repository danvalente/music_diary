defmodule MusicDiary.Current do
  @moduledoc """
  This module simplifies a call to the the currently-playing endpoint in the
  Spotify Web API. There is also a call to the profile endpoint to retrieve
  the username. All of the relevant data is packaged and simplifed into a Map
  that looks like the following.

  %{
    album_artists: ["The Beatles"],
    album_release_date: "1969-09-26",
    album_title: "Abbey Road (Remastered)",
    album_uri: "spotify:album:0ETFjACtuP2ADo6LFhL6HN",
    image_url: "https://i.scdn.co/image/af1dfd2eec8b69b50fdc5a06bd773f5e78379589",
    track_artists: ["The Beatles"],
    track_title: "Golden Slumbers - Remastered 2009",
    track_uri: "spotify:track:01SfTM5nfCou5gQL70r6gs",
    user_id: "danvalente"
  }

  """

  @currently_playing_url "https://api.spotify.com/v1/me/player/currently-playing"

  def get(username) do
    MusicDiary.CredStore.get_creds(username)
    |> Spotify.Client.get(@currently_playing_url)
    |> handle_response(&clean_response/1)
    |> Map.put(:user_id, username)
  end

  def clean_response(resp) do
    {:ok, decoded_resp} = Jason.decode(resp.body)
    get_metadata(decoded_resp)
  end

  def get_metadata(data) do
    Map.merge(
      get_track_data(data),
      get_album_data(data)
    )
  end

  def get_track_data(data) do
    track_data = Map.get(data, "item")
    artists = Map.get(track_data, "artists")
    %{
      track_title: Map.get(track_data, "name"),
      track_artists: Enum.map(artists, &(&1["name"])),
      track_uri: Map.get(track_data, "uri")
    }
  end

  def get_album_data(data) do
    album = get_in(data, ["item", "album"])
    artists = Map.get(album, "artists")
    images = Map.get(album, "images")
    %{
      album_artists: Enum.map(artists, &(&1["name"])),
      album_release_date: Map.get(album, "release_date"),
      album_title: Map.get(album, "name"),
      image_url: Enum.find(images, &match?(%{"height" => 300}, &1))
        |> Map.get("url"),
      album_uri: Map.get(album, "uri")
    }
  end

  defp handle_response({_, data}, fnc) do
    case data.status_code do
      200 -> fnc.(data)
      204 -> %{}
      429 -> Enum.find(data.headers, &match?({"Retry-After", _}, &1))
      _ -> {:error, [status_code: data.status_code, message: data.body]}
    end
  end



end
