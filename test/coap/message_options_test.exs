defmodule CoAP.MessageOptionsTest do
  use ExUnit.Case
  # doctest CoAP.MessageOptions

  test "failing" do
    message = <<152, 68, 244, 81, 253, 46>>

    result = CoAP.MessageOptions.decode(message)

    assert result == {%{nil: <<68, 244, 81, 253, 46>>}, <<>>}
  end

  test "failing 2" do
    message = <<188, 119, 68, 244, 81, 253, 46>>

    result = CoAP.MessageOptions.decode(message)

    assert result == {%{uri_path: [<<119, 68, 244, 81, 253, 46>>]}, <<>>}
  end
end
