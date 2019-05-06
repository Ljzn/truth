defmodule Veritas.KeyChain do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def my_keys do
    GenServer.call(__MODULE__, :my_keys)
  end

  def init(_) do
    if File.exists?("./.keys") do
      data = File.read!("./.keys")
      {pubkey, privkey} = :erlang.binary_to_term(data)

      {:ok, %{pubkey: pubkey, privkey: privkey}}
    else
      {pubkey, privkey} = ExthCrypto.ECIES.ECDH.new_ecdh_keypair()
      # pubkey = compress(pubkey)
      data = :erlang.term_to_binary({pubkey, privkey})
      File.touch("./.keys")
      File.write!("./.keys", data)

      {:ok, %{pubkey: pubkey, privkey: privkey}}
    end
  end

  def handle_call(:my_keys, _, state) do
    {:reply, state, state}
  end

  def compress(<<_prefix::size(8), x_coordinate::size(256), y_coordinate::size(256)>>) do
    prefix = case rem(y_coordinate, 2) do
      0 -> 0x02
      _ -> 0x03
    end
    <<prefix::size(8), x_coordinate::size(256)>>
  end
end
