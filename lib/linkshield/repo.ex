defmodule LinkShield.Repo do
  use Ecto.Repo,
    otp_app: :linkshield,
    adapter: Ecto.Adapters.Postgres
end
