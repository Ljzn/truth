defmodule VeritasWeb.ChatLive do
  use Phoenix.LiveView


  def render(assigns) do
    ~L"""
    <h1>Conversation</h1>

    <form phx-change="change">
      <label>Remote Public Key</label>
      <input name="remote_pubkey" type="text" value="<%= @remote_pubkey |> Base.encode16() %>" ></input>
      <p style="color:red"><%= @warning %><p>
    </form>

    <form phx-change="text-change">
      <label>New Message</label>
      <textarea name="text"></textarea>
      <a href="/conversation/<%= @script %>"><button type="button">send</button></a>
    </form>


    <label>Find My Chat History</label>
    <a href="https://babel.bitdb.network/query/<%= @query %>"<button type="button">find</button></a>
    """
  end

  @state %{
    moneybutton: "",
    script: "",
    warning: "",
    secret: nil,
    privkey: nil,
    pubkey: nil,
    messages: ["hello"],
    remote_pubkey: Base.decode16!("046F0EBDADE003F710E6481982726759A19CB65731ADBFF3DC7C787F693B808090587D2F3BDFAC7719215C871DD39A0CC3BD2694679C3A0DE0313CFD218E5BE360"), # Jay's pubkey
  }

  def mount(_, socket) do
    keys = Veritas.KeyChain.my_keys()
    state = %{
      @state |
      secret: ExthCrypto.ECIES.ECDH.generate_shared_secret(keys.privkey, @state.remote_pubkey)
    }
    {:ok, assign(socket, state) |> assign(keys)}
  end

  def handle_event("change", %{"remote_pubkey" => remote}, socket) do
    # IO.inspect socket.assigns
    case Base.decode16(remote) do
      {:ok, remote_pubkey} ->
        if byte_size(remote_pubkey) == 65 do
          secret = ExthCrypto.ECIES.ECDH.generate_shared_secret(socket.assigns.privkey, remote_pubkey)
          change = %{
            remote_pubkey: remote_pubkey,
            secret: secret,
            warning: ""
          }
          # IO.inspect secret, label: "secret"
          {:noreply, assign(socket, change)}
        else
          {:noreply, assign(socket, :warning, "invalid remote pubkey!")}
        end
      _ ->
        {:noreply, assign(socket, :warning, "invalid remote pubkey!")}
    end
  end

  def handle_event("text-change", data, socket) do
    text = data["text"]
    encrypted = ExthCrypto.AES.encrypt(text, :ecb, socket.assigns.secret)
    IO.inspect encrypted
    decrypted = ExthCrypto.AES.decrypt(encrypted, :ecb, socket.assigns.secret) |> binary_trim_leading_zero()
    IO.inspect decrypted, label: "decrypted text"

    # moneybutton = make_moneybutton(socket.assigns.pubkey, socket.assigns.remote_pubkey, encrypted)
    # {:noreply, assign(socket, :moneybutton, moneybutton)}
    script = make_script(socket.assigns.pubkey, socket.assigns.remote_pubkey, encrypted)

    {:noreply, assign(socket, :script, script)}
  end

  def handle_event("refresh", _, socket) do

    {:noreply, socket}
  end

  def make_script(pub1, pub2, data) do
    "OP_RETURN #{bin2hex(pub1)} #{bin2hex(pub2)} #{bin2hex(data)}"
  end

  defp binary_trim_leading_zero(bin) do
    :erlang.binary_to_list(bin) |> Enum.drop_while(fn x -> x == 0 end) |> :erlang.list_to_binary()
  end


  defp bin2hex(bin), do: Base.encode16(bin, case: :lower)

end