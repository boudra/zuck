defmodule Zuck.Config do

  @endpoint "https://graph.facebook.com/"

  def version() do
    Application.get_env(:zuck, :version, "v2.9")
  end

  def endpoint() do
    Application.get_env(:zuck, :endpoint, @endpoint)
  end

  def http() do
    Application.get_env(:zuck, :http, [])
  end

  def app_id do
    Application.get_env(:zuck, :app_id, nil)
  end

  def app_secret do
    Application.get_env(:zuck, :app_secret, nil)
  end

  def log? do
    Application.get_env(:zuck, :log, true)
  end

  def debug? do
    Application.get_env(:zuck, :debug, true)
  end

end
