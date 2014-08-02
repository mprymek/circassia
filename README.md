Circassia
=========

Simple circular buffer with persistent data storage based on mnesia.

You can create as much named buffers as you wish, each of them of its own (fixed) size.
Each buffer is stored in a separate mnesia table with the same name.

At present, there's only one operation: `push`. You can push any term into the buffer and
the buffer behaves as a FIFO queue: if you push into a not-full buffer, the operation
returns nil. If you push into a full buffer, the oldest value is returned (and removed from the buffer).

Usage:
```
iex(1)> :mnesia.start
:ok
iex(2)> Circassia.init_buffer(:my_buffer,3)
:ok
iex(3)> Circassia.push(:my_buffer,:a)
nil
iex(4)> Circassia.push(:my_buffer,:b)
nil
iex(5)> Circassia.push(:my_buffer,:c)
nil
iex(6)> Circassia.push(:my_buffer,:d)
:a
iex(7)> Circassia.push(:my_buffer,:e)
:b
iex(8)> Circassia.push(:my_buffer,:f)
:c
iex(9)> Circassia.push(:my_buffer,:g)
:d
```
