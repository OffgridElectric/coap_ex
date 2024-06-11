defmodule CoAP.SocketServerTest do
  use ExUnit.Case

  import ExUnit.CaptureLog

  alias CoAP.SocketServer
  alias CoAP.Adapters.GenericServer

  defmodule FakeEndpoint do
  end

  describe "CoAP.SocketServer decoding errors" do
    test "non repeatable options" do
      peer_ip = "127.0.0.1"
      peer_port = 5830

      {:ok, server} = SocketServer.start_link([{GenericServer, FakeEndpoint}, peer_port])

      data =
        <<100, 69, 0, 1, 252, 1, 46, 56, 68, 80, 231, 168, 249, 100, 69, 0, 1, 252, 1, 46, 56, 68,
          80, 231, 168, 249>>

      log =
        capture_log(fn ->
          ref = Process.monitor(server)
          send(server, {:udp, :socket, peer_ip, peer_port, data})

          response =
            receive do
              {:DOWN, ^ref, :process, ^server, _reason} ->
                :ok
            after
              100 -> {:error, {:timeout, :await_response}}
            end

          assert response == :ok
        end)

      assert log =~ "CoAP socket failed to decode udp packets"
      assert log =~ "is not repeatable"
      assert log =~ "from ip: \"#{peer_ip}\""
      assert log =~ "port: #{peer_port}"
      assert log =~ "data: #{inspect(data, binaries: :as_binary)}"
    end

    test "CaseClauseError" do
      peer_ip = "127.0.0.1"
      peer_port = 5830

      {:ok, server} = SocketServer.start_link([{GenericServer, FakeEndpoint}, peer_port])

      data =
        <<100, 69, 0, 1, 83, 61, 239, 152, 68, 244, 81, 253, 46, 100, 69, 0, 1, 83, 61, 239, 152,
          68, 244, 81, 253, 46>>

      log =
        capture_log(fn ->
          ref = Process.monitor(server)
          send(server, {:udp, :socket, peer_ip, peer_port, data})

          response =
            receive do
              {:DOWN, ^ref, :process, ^server, _reason} ->
                :ok
            after
              100 -> {:error, {:timeout, :await_response}}
            end

          assert response == :ok
        end)

      assert log =~ "CoAP socket failed to decode udp packets"
      assert log =~ "CaseClauseError"
      assert log =~ "from ip: \"#{peer_ip}\""
      assert log =~ "port: #{peer_port}"
      assert log =~ "data: #{inspect(data, binaries: :as_binary)}"
    end
  end
end
