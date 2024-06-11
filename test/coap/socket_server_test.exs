defmodule CoAP.SocketServerTest do
  use ExUnit.Case

  alias CoAP.SocketServer

  test "handle_info/2" do
    connection_id = {{10, 148, 21, 176}, 5683, <<252, 1, 46, 56>>}
    state = %{connections: %{connection_id => self()}, monitors: %{}, endpoint: %{}, config: %{}}

    message =
      {:udp, self(), {10, 148, 21, 176}, 5683,
       <<100, 69, 0, 1, 252, 1, 46, 56, 68, 80, 231, 168, 249, 100, 69, 0, 1, 252, 1, 46, 56, 68,
         80, 231, 168, 249>>}

    resp = SocketServer.handle_info(message, state)

    assert resp == {:noreply, state}
  end
end
