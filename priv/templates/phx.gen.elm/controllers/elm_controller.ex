defmodule <%= app_name %>Web.ElmController do
  use <%= app_name %>Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
