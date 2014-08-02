defmodule CircassiaTest do
  use ExUnit.Case
  alias Circassia, as: C

  @table :test_table

  test "complex test" do
    table=:first_test_table
    :mnesia.delete_table(table)
    C.init_buffer table, 3
    assert C.push(table, :a) == :nil
    assert C.push(table, :b) == :nil
    assert C.push(table, :c) == :nil
    assert C.push(table, :d) == :a
    assert C.push(table, :e) == :b
    assert C.push(table, :f) == :c
    assert C.push(table, :g) == :d
    :mnesia.delete_table(table)
  end
end
