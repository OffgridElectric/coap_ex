defmodule CoAP.SocketServerTest do
  use ExUnit.Case

  alias CoAP.SocketServer
  alias CoAP.Adapters.GenericServer
  alias CoAP.Message

  @port 5827

  defmodule FakeEndpoint do
    def request(message) do
      # path should have api in it
      # params should be empty

      payload =
        case message.payload do
          data when byte_size(data) > 0 -> data
          _ -> "Created"
        end

      %Message{
        type: :con,
        code_class: 2,
        code_detail: 1,
        message_id: message.message_id,
        token: message.token,
        payload: payload
      }
    end
  end

  @tag :wip3
  test "asdasdas" do
    peer_ip = "127.0.0.1"
    peer_port = @port + 3

    {:ok, server} = SocketServer.start_link([{GenericServer, FakeEndpoint}, peer_port])

    IO.inspect(server, label: "Server")

    data =
      <<100, 69, 0, 1, 252, 1, 46, 56, 68, 80, 231, 168, 249, 100, 69, 0, 1, 252, 1, 46, 56, 68,
        80, 231, 168, 249>>

    send(server, {:udp, :socket, peer_ip, peer_port, data})

    # assert byte_size(response.payload) == 1024
    response =
      receive do
        {:deliver, response, _peer} -> response
        {:error, reason} -> {:error, reason}
      after
        10_000 -> {:error, {:timeout, :await_response}}
      end

    assert response == :ok
  end
end
