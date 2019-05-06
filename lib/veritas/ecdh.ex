defmodule Veritas.Ecdh do

  @curve :secp256k1

  # r: {pubkey, privkey}
  def keypair(curve \\ @curve) when is_atom(curve) do
    :crypto.generate_key(:ecdh, curve)
  end

  def common_secret(privkey, pubkey, curve \\ @curve) when is_atom(curve) do
    :crypto.compute_key(:ecdh, pubkey, privkey, curve)
  end
end
