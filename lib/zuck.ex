defmodule Zuck do

  @endpoint "https://graph.facebook.com/v2.9"

  require Logger

  def get(path, params \\ %{}, opts \\ []) do
    request(:get, path, params, "", opts)
  end

  def post(path, params \\ %{}, opts \\ []) do
    params = params
             |> Enum.map(fn
               ({k,v}) when is_map(v) ->
                 {k, Poison.encode!(v)}
               (v) -> v
             end)

    request(:post, path, %{}, {:form, params}, opts)
  end

  def request(method, path, params, body, opts) do

    headers = [
      {"Accept", "application/json"}
    ]

    qs = params
         |> Map.to_list

    Logger.log(:info, "[zuck] #{path} #{inspect params} #{inspect body}")

    url = :hackney_url.make_url(@endpoint, path, qs)

    with {:ok, status, _headers, body_ref} <- :hackney.request(method, url, headers, body, opts),
         {:ok, body} <- :hackney.body(body_ref),
         {:ok, parsed_body} <- Poison.decode(body, keys: :atoms) do

      case status do
        200 -> {:ok, parsed_body}
        _   -> {:error, Map.get(parsed_body, :error, parsed_body)}
      end

    end

  end

end
