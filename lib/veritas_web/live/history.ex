defmodule VeritasWeb.HistoryLive do
  use Phoenix.LiveView


  def render(assigns) do
    ~L"""
    <h1>History</h1>
    """
  end

  @state %{
    privkey: nil,
    pubkey: nil,

  }

  def mount(%{}, socket) do
    state = @state
    {:ok, assign(socket, state)}
  end

  def mount(session, socket) do
    session.data
    state = %{
      privkey: session["privkey"],
      pubkey: session["pubkey"]
    }
    {:ok, assign(socket, session)}
  end

end
