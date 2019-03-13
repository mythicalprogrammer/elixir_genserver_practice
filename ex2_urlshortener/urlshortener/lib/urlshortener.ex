defmodule URLShortener do
  use GenServer

  # Client API
  def start_link(name, opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts ++ [name: name])
  end

  def stop(name) do
    GenServer.cast(name, :stop)
  end

  def flush(name) do
    GenServer.cast(name, :flush)
  end

  def shorten(name, url) do
    GenServer.call(name, {:shorten, url})
  end

  def get(name, short_link) do
    GenServer.call(name, {:get, short_link})
  end

  def count(name) do
    GenServer.call(name, :count)
  end

  # GenServer callbacks
  def init(:ok) do
    {:ok, %{}}
  end

  def handle_cast(:stop, state) do
    {:stop, :normal, state}
  end

  def handle_cast(:flush, _state) do
    {:noreply, %{}}
  end

  def handle_call({:shorten, url}, _from, state) do
    short = md5(url)
    {:reply, short, Map.put(state, short, url)}
  end

  def handle_call({:get, short_link}, _from, state) do
    {:reply, Map.get(state, short_link), state}
  end

  def handle_call(:count, _from, state) do
    {:reply, Map.size(state), state}
  end

  defp md5(url) do
    :crypto.hash(:md5, url)
    |> Base.encode16(case: :lower)
  end
end
