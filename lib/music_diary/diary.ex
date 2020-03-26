defmodule MusicDiary.Diary do
  @moduledoc """
  The fundamental data structure for MusicDiary. Very lightweight.
  Just a map keyed on timestamp of the entry. The Diary is persisted
  by the DiaryServer
  """

  def new() do
    %{}
  end

  def create_diary_entry(now, note, metadata) do
    %{
      note: note,
      metadata: metadata,
      last_updated: now,
      created: now
    }
  end

  def add_diary_entry(diary, entry) do
    Map.put(diary, entry.created, entry)
  end

  def get_entries_by_timestamp(diary, timestamp) do
    Map.get(diary, timestamp)
  end

  # Because album_artists is a list, we need a different filter
  # function. I wonder if there's a way to simplify the following
  # two functions, other than relying on pattern matching the param list
  def get_entries_by_metadata(diary, :album_artists, value) do
    diary
    |> Stream.filter(
         fn {_, entry} ->
           Enum.any?(
	     get_in(entry, [:metadata, :album_artists]),
	     fn x -> x == value end
	   ) end
       )
    |> Enum.map(fn {_, entry} -> entry end)
  end

  def get_entries_by_metadata(diary, key, value) do
    diary
    |> Stream.filter(
      fn {_, entry} ->
        get_in(entry, [:metadata, key]) == value
      end)
    |> Enum.map(fn {_, entry} -> entry end)
  end

end
