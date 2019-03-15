defmodule Zuck do

  alias Zuck.{Config, Request}

  require Logger

  def get!(path, params \\ %{}, opts \\ []) do
    case get(path, params, opts) do
      {:ok, res} -> res
      {:error, err} -> raise err
    end
  end

  def get(path, params \\ %{}, opts \\ []) do
    Request.new(:get, path, params, opts)
    |> call
  end

  def get_stream(path, params \\ %{}, opts \\ []) do
    Request.new(:get, path, params, opts)
    |> stream
  end

  def post(path, params \\ %{}, opts \\ []) do
    Request.new(:post, path, params, opts)
    |> call
  end

  def post_stream(path, params \\ %{}, opts \\ []) do
    Request.new(:get, path, params, opts)
    |> stream
  end

  def stream(%Request{} = req) do
    Stream.resource(fn -> "" end,
      fn
        nil ->
          {:halt, nil}
        cursor ->
          next_req = Request.put_params(req, %{ after: cursor })
          {:ok, res} = call(next_req)
          {res.data, get_in(res, [:paging, :cursors, :after])}
      end, fn _ -> true end)
  end

  def call(%Request{} = req) do
    debug = Keyword.get(req.opts, :debug, Config.debug?)
    app_id = Keyword.get(req.opts, :app_id, Config.app_id)
    app_secret = Keyword.get(req.opts, :app_secret, Config.app_secret)

    params =
      case debug do
        true -> Map.put(req.params, :debug, true)
        false -> req.params
      end
      |> Map.put(:app_id, app_id)
      |> Map.put(:app_secret, app_secret)
      |> Map.put(:method, req.method |> Atom.to_string |> String.upcase)


    req = %Request{ req | params: params}

    if Config.log? do
      Logger.log(:info, "[zuck] #{req.method} #{String.trim_trailing(req.path, "/")} #{inspect req.params}")
    end

    body = Request.body(req)
    qs = Request.query_string(req)

    url = :hackney_url.make_url(Config.endpoint <> req.version, req.path, qs)

    headers = [
      {"Accept", "application/json"}
    ]

    with {:ok, status, _headers, body_ref} <- :hackney.request(:post, url, headers, {:form, body}, req.http_opts),
         {:ok, body} <- :hackney.body(body_ref),
         {:ok, parsed_body} <- Poison.decode(body, keys: :atoms) do

      case status do
        200 -> {:ok, parsed_body}
        _   -> {:error, Map.get(parsed_body, :error, parsed_body)}
      end

    end
  end

end
