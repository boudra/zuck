defmodule Zuck do

  alias Zuck.Config

  require Logger

  def get(path, params \\ %{}, opts \\ []) do
    request(:get, path, params, "", opts)
  end

  def post(path, params \\ %{}, opts \\ []) do
    body = params
             |> Enum.map(fn
               ({k,v}) when is_map(v) -> case Poison.encode(v) do
                 {:ok, v} -> {k, v}
                 _ -> {k, v}
               end
               (v) -> v
             end)

    request(:post, path, %{}, body, opts)
  end

  def request(method, path, params, body, opts) do

    headers = [
      {"Accept", "application/json"}
    ]

    debug = Keyword.get(opts, :debug, Config.debug?)

    qs = case debug do
          true -> Map.put(params, :debug, true)
          false -> params
         end
         |> Map.to_list

    if Config.log? do
      Logger.log(:info, "[zuck] #{method} #{String.trim_trailing(path, "/")} #{inspect params}")
    end

    url = :hackney_url.make_url(Config.endpoint, path, qs)

    with {:ok, status, _headers, body_ref} <- :hackney.request(method, url, headers, {:form, body}, opts),
         {:ok, body} <- :hackney.body(body_ref),
         {:ok, parsed_body} <- Poison.decode(body, keys: :atoms) do

      case status do
        200 -> {:ok, parsed_body}
        _   -> {:error, Map.get(parsed_body, :error, parsed_body)}
      end

    end

  end

end
