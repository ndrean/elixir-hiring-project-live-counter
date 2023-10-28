# Additions

## DB

```bash
mix ecto.gen.repo -r Counter.Repo
mix ecto.gen.migration create_counters
```

```elixir
config :liveview_counter,
  ecto_repos: [Counter.Repo]

config :liveview_counter, Counter.Repo,
  database: "liveview_counter_repo",
  username: "user",
  password: "pass",
  hostname: "localhost"
```
