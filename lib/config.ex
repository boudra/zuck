defmodule Zuck.Config do

  @endpoint "https://graph.facebook.com/"

  def endpoint do
    version = Application.get_env(:zuck, :version, "v2.9")
    @endpoint <> version
  end

  def log? do
    Application.get_env(:zuck, :log, true)
  end

  def debug? do
    Application.get_env(:zuck, :debug, true)
  end

end
