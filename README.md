# TRUTH (or Veritas)

TRUTH is a client-side software, which provides a secure and private chat environment, as well as the persistent chat data query.

When people shop online more and more often, even buying foreign goods, or signing a remote labor contract with a foreign company, it is inevitable to communicate online. The preservation of chat records becomes even more important.
We hope that the chat history will not be modified and deleted, and we can confirm the time of each record and the identity of both parties.

# How to use

You need have [elixir](https://elixir-lang.org/) and [phoenix](https://phoenixframework.org/) installed.

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

![look](./4.png)

- remote public key:
The the public key belongs to who you are chatting with. (default is me).

- new message:
You can type any messages in textarea, then click send button. TRUTH will generate a moneybutton,
with the encrypted message data in opreturn.

- find my chat history:
Query with Bitdb, to find all chat history related with your public key. And decrypt the message.

TRUTH use ECDH to generate share secret.

