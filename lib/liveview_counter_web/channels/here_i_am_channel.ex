defmodule LiveviewCounterWeb.HereIAmChannel do
  use LiveviewCounterWeb, :channel
  alias LiveviewCounter.Presence

  @impl true
  def join("who_is_here", _payload, socket) do
    send(self(), :after_join)
    {:ok, assign(socket, :user_id, socket.assigns.user_id)}
  end

  @impl true
  def handle_info(:after_join, socket) do
    {:ok, _} =
      Presence.track(socket, socket.assigns.user_id, %{
        online_at: inspect(System.system_time(:second))
      })

    # :ok = Phoenix.PubSub.broadcast(LiveviewCounter.PubSub, "new_guy", {System.get_env("FLY_REGION")})
    # push(socket, "presence_state", Presence.list(socket))
    {:noreply, socket}
  end

  def handle_info(msg, socket) do
    msg |> dbg()
    {:noreply, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (who_is_here:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end
end
