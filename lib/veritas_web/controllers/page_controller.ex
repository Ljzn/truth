defmodule VeritasWeb.PageController do
  use VeritasWeb, :controller

  def index(conn, _params) do
    conn
    |> put_layout(:app)
    |> live_render(VeritasWeb.VeritasLive, session: %{})
  end


  def conversation(conn, data) do
    conn
    |> assign(:script, data["script"])
    |> assign(:text, data["text"])
    |> put_layout(:app)
    |> live_render(VeritasWeb.ChatLive, session: %{})
  end

  def history(conn, _) do
    conn
    |> put_layout(:app)
    |> live_render(VeritasWeb.HistoryLive, session: %{})
  end

  def about(conn, _) do
    conn
    |> render("about.html")
  end

  def keys(conn, _) do
    keys = Veritas.KeyChain.my_keys()
    conn
    |> assign(:keys, keys)
    |> render("keys.html")
  end
end
