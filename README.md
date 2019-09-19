# Phoenix Auth API

JWT based authentication API on Elixir/Phoenix.

## Deps

* Joken [github](https://github.com/joken-elixir/joken)
* Bcrypt_elixir [github](https://github.com/riverrun/bcrypt_elixir)
* Postgrex [github](https://github.com/elixir-ecto/postgrex)

To start your Phoenix server:

* Install dependencies with `mix deps.get`
* Create and migrate your database with `mix ecto.setup`
* Start Phoenix endpoint with `mix phx.server`

Endpoints:

* POST http://localhost:4000/api/registration
* POST http://localhost:4000/api/session
* GET http://localhost:4000/

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).
