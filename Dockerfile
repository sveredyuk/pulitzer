FROM elixir:1.11.1-alpine

RUN mix local.rebar --force
RUN mix local.hex --force
RUN mix archive.install hex phx_new 1.5.6 --force

WORKDIR /app

COPY mix.exs .
COPY mix.lock .

CMD mix do deps.get, ecto.create, ecto.migrate, phx.server
