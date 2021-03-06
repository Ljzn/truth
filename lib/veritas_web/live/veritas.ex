defmodule VeritasWeb.VeritasLive do
  use Phoenix.LiveView


  def render(assigns) do
    ~L"""
    <ul>
      <li>
        <a href="/conversation"><button class="column column-50">Begin New Conversation</button></a>
      </li>
    </div>
    """
      # <li>
      #   <a href="/history"><button class="column column-50">Search My Chat History</button></a>
      # </li>
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
