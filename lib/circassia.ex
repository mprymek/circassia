defmodule Circassia.Meta do
  defstruct size: 0, idx: 0, length: 0
end

defmodule Circassia do
  alias Circassia.Meta

  def init_buffer(table\\__MODULE__,size) when is_integer(size) and size>0 do
    # in mnesia, we can't create table and write to it in one transaction
    {:atomic, :ok} = :mnesia.create_table table, [disc_copies: [node], attributes: [:id,:data]]
    :ok = :mnesia.dirty_write({table,:meta,%Meta{size: size}})
    :ok
  end

  def push(table\\__MODULE__,data) do
    f = fn ->
      [{_,_,m=%Meta{}}] = :mnesia.read(table,:meta)
      {pop_val,m2} = cond do
        m.length == m.size ->
          [{_,_,old_val}] = :mnesia.read(table,m.idx)
          {old_val,%Meta{m | idx: rem(m.idx+1,m.size)}}

        m.length < m.size ->
          :ok = :mnesia.write({table,m.idx,data})
          {nil,%Meta{m | length: m.length+1, idx: rem(m.idx+1,m.size)}}
      end
      :ok = :mnesia.write({table,m.idx,data})
      :ok = :mnesia.write({table,:meta,m2})
      pop_val
    end
    {:atomic, pop_val} = :mnesia.transaction(f)
    pop_val
  end
end
