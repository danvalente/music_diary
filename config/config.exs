import Config

config :music_diary,
  auth_port: 4000,
  diary_port: 4545

import_config "secret.exs"
import_config "spotify.exs"
