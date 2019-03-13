# Notgen Code Analysis

This is hand rolling without using GenServer.

## Code Analysis

### start function

```elixir
def start do
    spawn(__MODULE__, :loop, [%{}])
end
```

This check function is call to create one process of URLshortener in this case the module is named Notgen.

Why this is neat is because you can have a loop to create multiple processes all self contained URLshortner code and execute request concurrently.


### loop function  

```elixir
  def loop(state) do
    receive do
      {:stop, caller} ->
        send caller, "Shutting down."
      {:shorten, url, caller} ->
        url_md5 = md5(url)
        new_state = Map.put(state, url_md5, url)
        send caller, url_md5
        loop(new_state)
      {:get, md5, caller} ->
        send caller, Map.fetch(state, md5)
        loop(state)
      :flush ->
        loop(%{})
      _ ->
        loop(state)
    end
  end
```

Notice the loop function loop itself. Erlang and Elixir aren't object like in OOP where you can hold state. To hold state you need to loop the function itself while sending the updated state usually like an accumulator pattern but continuously until someone tell it to end.

Every process can only send and recieve messages. The `receive` code block is where you tell your process what type of message you're willing to answer.  

Notice in the `receive` block the logic chose to listen to four type of message (`:stop`, `shorten`, `get`, `flush`).

So when you call `start` function, you start an instance of your shorten in a process. Each process act like a server. It wait for a user or this case `caller` request and return via `send` the result. 

All request and response are just messages in the Elixir/Erlang world. Process communicate via messages and all messages that a process get are store in a mailbox. You always want a catch all case statement in your `receive` block because you need to resolve the message. If a message type isn't handle in your `receive` code block then it stays in the mailbox forever. When the mail get fill up more and more it will cause problem. The catch all is `_ ->` just fyi. 







