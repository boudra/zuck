# Zuck

:warning: **WIP** :warning:

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `zuck` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:zuck, "~> 0.1.0"}]
end
```

## Usage

```elixir
{:ok, user} = Zuck.get("/me", %{
  access_token: "TOKEN",
  fields: "name,email"
})
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/zuck](https://hexdocs.pm/zuck).

