defmodule MusicDiary.UserUtils do

  def get_user_id(creds) do
    creds
    |> Spotify.Profile.me
    |> extract_id
  end

  defp extract_id(me_resp) do
    case me_resp do
      {:ok, resp} -> Map.get(resp, :id)
      _ -> :error
    end
  end

end
