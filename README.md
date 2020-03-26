# MusicDiary

MusicDiary provides a service that allows a user to attach a note to the song they are currently listening to on Spotify.
Notes are saved in memory as well as persisted to disk using Erlangs built-in DETS tables (for now).

The user must OAuth in to Spotify by visiting `http://localhost:4000` (4000 is the hard-coded port behind which the authorization server sits)

The diary server sits behind port 4545 and the endpoint of interest (literally, the only one) is `/take-note`, which accepts POST requests.

For example, the request:

`curl --header "Content-Type: application/json" --data '{"username": "danvalente", "note": "This is an amazing performance."}' http://localhost:4545/take-note`

... would result in the following entry into the Diary
```
%{
  ~U[2020-02-07 19:55:10.281691Z] => %{
    created: ~U[2020-02-07 19:55:10.281691Z],
    last_updated: ~U[2020-02-07 19:55:10.281691Z],
    metadata: %{
      album_artists: ["Pink Floyd"],
      album_release_date: "1995",
      album_title: "Pulse (Live)",
      album_uri: "spotify:album:3FDsXI2HlnNtVifZFyoTcf",
      image_url: "https://i.scdn.co/image/ab67616d00001e02ce7b7f5abc9968bd93458cd4",
      track_artists: ["Pink Floyd"],
      track_title: "Shine On You Crazy Diamond (Pts. 1-5, 7) - Live",
      track_uri: "spotify:track:6YdueMw0uSDFj62Ly4Oegp",
      user_id: "danvalente"
    },
    note: "This is an amazing performance."
  }
```
