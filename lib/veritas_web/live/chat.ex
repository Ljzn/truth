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
      <a href="/conversation/<%= @script %>/<%= @text %>"><button type="button">send</button></a>
    </form>


    <label>Find My Chat History</label>
    <button phx-click="find" >find</button>
    <ul>
    <%= for x <- @result do %>
      <li><%= x %></li>
    <% end %>
    </ul>
    """
  end

  @state %{
    text: "",
    result: [],
    query: "",
    moneybutton: "",
    script: "",
    warning: "",
    secret: nil,
    privkey: nil,
    pubkey: nil,
    remote_pubkey: Base.decode16!("046F0EBDADE003F710E6481982726759A19CB65731ADBFF3DC7C787F693B808090587D2F3BDFAC7719215C871DD39A0CC3BD2694679C3A0DE0313CFD218E5BE360"), # Jay's pubkey
  }

  def mount(_, socket) do
    keys = Veritas.KeyChain.my_keys()
    state = %{
      @state |
      secret: ExthCrypto.ECIES.ECDH.generate_shared_secret(keys.privkey, @state.remote_pubkey),
      query: make_query(keys.pubkey)
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
    # IO.inspect encrypted
    decrypted = ExthCrypto.AES.decrypt(encrypted, :ecb, socket.assigns.secret) |> binary_trim_leading_zero()
    # IO.inspect decrypted, label: "decrypted text"

    # moneybutton = make_moneybutton(socket.assigns.pubkey, socket.assigns.remote_pubkey, encrypted)
    # {:noreply, assign(socket, :moneybutton, moneybutton)}
    script = make_script(socket.assigns.pubkey, socket.assigns.remote_pubkey, encrypted)

    {:noreply, assign(socket, :script, script) |> assign(:text, text)}
  end

  def handle_event("find", _, socket) do
    q = socket.assigns.query
    {:ok, result} = Veritas.Bitdb.query(q)
    result = Enum.map(result, fn x ->
      """
      txid: #{x["tx"]["h"]},
      mseeage: #{hd(x["out"])["h3"] |> decrypt(socket)}

      """
    end)
    if result == [] do
      {:noreply, assign(socket, :result, ["not found, please wait a minute :P"])}
    else
      {:noreply, assign(socket, :result, result)}
    end
  end

  def make_script(pub1, pub2, data) do
    "OP_RETURN #{bin2hex(pub1)} #{bin2hex(pub2)} #{bin2hex(data)}"
  end

  defp binary_trim_leading_zero(bin) do
    :erlang.binary_to_list(bin) |> Enum.drop_while(fn x -> x == 0 end) |> :erlang.list_to_binary()
  end

  defp decrypt(xmsg, socket) do
    xmsg = xmsg |> Base.decode16!(case: :lower)
    ExthCrypto.AES.decrypt(xmsg, :ecb, socket.assigns.secret) |> binary_trim_leading_zero()
  end


  defp bin2hex(bin), do: Base.encode16(bin, case: :lower)

  def make_query(pubkey) do
    """
    {
      "v":3,
      "q":{
        "find":{
            "$or": [
              {"out.h1":"#{bin2hex(pubkey)}"},
              {"out.h2":"#{bin2hex(pubkey)}"}
            ]
        },
        "limit":10
      }
    }
    """ |> Base.encode64() |> IO.inspect(label: "query")
  end

end
