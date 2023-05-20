defmodule Zuck.Request do

  alias Zuck.Config
  alias __MODULE__

  defstruct [
    :version, :method, :path, :params, :http_opts, :opts
  ]

  def get(path, params, opts \\ []) do
    new(:get, path, params, opts)
  end

  def post(path, params, opts \\ []) do
    new(:get, path, params, opts)
  end

  def new(method, path, params, opts \\ []) do
    version = Keyword.get(opts, :version, Config.version)
    http_opts = Keyword.get(opts, :http_opts, Config.http)

    %__MODULE__{
      version: version,
      method: method,
      path: path,
      params: params,
      opts: opts,
      http_opts: http_opts
    }
  end

  defp encode_param({k,v}) when is_map(v) do
    [ {k, Poison.encode!(v)} ]
  end

  defp encode_param({k,values}) when is_list(values) do
    key = Atom.to_string(k) <> "[]"
    values
    |> Enum.flat_map(fn(v) ->
      encode_param({key, v})
    end)
  end

  defp encode_param({k,v}) do
    [ {k, to_string v} ]
  end

  def encode_params(%Request{} = req) do
    Enum.flat_map(req.params, &encode_param/1)
  end

  def body(%Request{method: :get}) do
    []
  end
  def body(%Request{} = req) do
    encode_params(req)
  end

  def query_string(%Request{method: :get} = req) do
    encode_params(req)
  end
  def query_string(%Request{}) do
    []
  end

  def put_params(%Request{} = req, params) do
    %Request{ req | params: Map.merge(req.params, params)}
  end

end
