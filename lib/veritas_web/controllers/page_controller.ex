defmodule VeritasWeb.PageController do
  use VeritasWeb, :controller

  def index(conn, _params) do
    conn
    |> put_layout(:app)
    |> live_render(VeritasWeb.VeritasLive, session: %{})
  end

  def about(conn, _) do
    conn
    |> render("about.html")
  end
end
