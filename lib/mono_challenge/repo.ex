defmodule MonoChallenge.Repo do
  use Ecto.Repo,
    otp_app: :mono_challenge,
    adapter: Ecto.Adapters.Postgres
end
