defmodule MusicDiaryTest do
  use ExUnit.Case
  doctest MusicDiary

  test "greets the world" do
    assert MusicDiary.hello() == :world
  end
end
