defmodule CoAP.SocketServerTest do
  use ExUnit.Case

  test "failing" do
    pid = self()

    connection_id = {{10, 151, 2, 59}, 5683, <<83, 61, 239, 152>>}

    message =
      {:udp, pid, {10, 151, 2, 59}, 5683,
       <<100, 69, 0, 1, 83, 61, 239, 152, 68, 244, 81, 253, 46, 100, 69, 0, 1, 83, 61, 239, 152,
         68, 244, 81, 253, 46>>}

    state = %{
      connections: %{connection_id => pid},
      endpoint: nil,
      monitors: %{},
      port: 0,
      socket: 0
    }

    result = CoAP.SocketServer.handle_info(message, state)

    assert result == {:noreply, state}

    assert_receive {
                      :receive,
                      %CoAP.Message{
                        code_class: 2,
                        code_detail: 5,
                        message_id: 1,
                        method: nil,
                        multipart: %CoAP.Multipart{control: nil, description: nil, more: false, multipart: false, number: 0, requested_number: 0, requested_size: 0, size: 0},
                        options: %{etag: [<<244, 81, 253, 46>>], nil: <<69, 0, 1, 83>>},
                        payload: "",
                        raw_size: 26,
                        request: false,
                        status: {:ok, :content},
                        token: <<83, 61, 239, 152>>,
                        type: :ack,
                        version: 1
                      }
                    }
  end

  test "failing 2" do
    pid = self()

    connection_id = {{10, 151, 2, 59}, 5683, <<106, 90, 188, 119>>}

    message =
      {:udp, pid, {10, 151, 2, 59}, 5683,
      <<100, 69, 0, 1, 106, 90, 188, 119, 68, 244, 81, 253, 46, 100, 69, 0, 1, 106, 90, 188, 119, 68, 244, 81, 253, 46>>}

    state = %{
      connections: %{connection_id => pid},
      endpoint: nil,
      monitors: %{},
      port: 0,
      socket: 0
    }

    result = CoAP.SocketServer.handle_info(message, state)

    assert result == {:noreply, state}

    assert_receive {:receive,
                    %CoAP.Message{
                      version: 1,
                      type: :ack,
                      request: false,
                      code_class: 2,
                      code_detail: 5,
                      method: nil,
                      status: {:ok, :content},
                      message_id: 1,
                      token: <<106, 90, 188, 119>>,
                      options: %{etag: [<<244, 81, 253, 46>>], nil: <<69, 0, 1, 106>>},
                      multipart: %CoAP.Multipart{
                        multipart: false,
                        description: nil,
                        control: nil,
                        more: false,
                        number: 0,
                        size: 0,
                        requested_size: 0,
                        requested_number: 0
                      },
                      payload: "",
                      raw_size: 26
                    }}
  end
end
