# Test for Ruby DBus

Wample script to reproduce packet issues when we call DBus multiple times in different threads. The problem is not limited
to Systemd, making calls to NetworkManager also raises the same errors. Below is a sample Systemd unit to test with.
Script is only checking if the unit is running, you can either install it or you can modify UNIT_NAME in the script and
use a unit that is already installed in your system.

When I run multiple_dbus_calls.rb I sometimes get this error

```
$ ./multiple_dbus_calls.rb
building thread 1 out of 5
building thread 2 out of 5
building thread 3 out of 5
current thread 0
current thread 1
building thread 4 out of 5
current thread 2
building thread 5 out of 5
current thread 3
current thread 4
before obj.introspect 0
before obj.introspect 1
before obj.introspect 2
before obj.introspect 3
/home/zaburt/.rvm/gems/ruby-2.4.3@dbus_test/gems/ruby-dbus-0.14.1/lib/dbus/marshall.rb:183:in `do_parse': DBus::InvalidPacketException (DBus::InvalidPacketException)
        from /home/zaburt/.rvm/gems/ruby-2.4.3@dbus_test/gems/ruby-dbus-0.14.1/lib/dbus/marshall.rb:62:in `block in unmarshall'
        from /home/zaburt/.rvm/gems/ruby-2.4.3@dbus_test/gems/ruby-dbus-0.14.1/lib/dbus/marshall.rb:61:in `each'
        from /home/zaburt/.rvm/gems/ruby-2.4.3@dbus_test/gems/ruby-dbus-0.14.1/lib/dbus/marshall.rb:61:in `unmarshall'
        from /home/zaburt/.rvm/gems/ruby-2.4.3@dbus_test/gems/ruby-dbus-0.14.1/lib/dbus/message.rb:201:in `unmarshall_buffer'
        from /home/zaburt/.rvm/gems/ruby-2.4.3@dbus_test/gems/ruby-dbus-0.14.1/lib/dbus/message_queue.rb:139:in `message_from_buffer_nonblock'
        from /home/zaburt/.rvm/gems/ruby-2.4.3@dbus_test/gems/ruby-dbus-0.14.1/lib/dbus/message_queue.rb:31:in `pop'
        from /home/zaburt/.rvm/gems/ruby-2.4.3@dbus_test/gems/ruby-dbus-0.14.1/lib/dbus/bus.rb:441:in `wait_for_message'
        from /home/zaburt/.rvm/gems/ruby-2.4.3@dbus_test/gems/ruby-dbus-0.14.1/lib/dbus/bus.rb:453:in `send_sync'
        from /home/zaburt/.rvm/gems/ruby-2.4.3@dbus_test/gems/ruby-dbus-0.14.1/lib/dbus/bus.rb:339:in `send_sync_or_async'
        from /home/zaburt/.rvm/gems/ruby-2.4.3@dbus_test/gems/ruby-dbus-0.14.1/lib/dbus/bus.rb:365:in `introspect_data'
        from /home/zaburt/.rvm/gems/ruby-2.4.3@dbus_test/gems/ruby-dbus-0.14.1/lib/dbus/proxy_object.rb:73:in `introspect'
        from ./multiple_dbus_calls.rb:18:in `local_service_unit_is_active'
        from ./multiple_dbus_calls.rb:28:in `block in build_thread'
```

and sometimes this

```
$ ./multiple_dbus_calls.rb
building thread 1 out of 5
building thread 2 out of 5
building thread 3 out of 5
current thread 0
current thread 2
building thread 4 out of 5
current thread 1
building thread 5 out of 5
current thread 3
current thread 4
before obj.introspect 0
before obj.introspect 2
before obj.introspect 1
before obj.introspect 3
/home/zaburt/.rvm/gems/ruby-2.4.3@dbus_test/gems/ruby-dbus-0.14.1/lib/dbus/marshall.rb:103:in `read_string': String is not nul-terminated (DBus::InvalidPacketException)
        from /home/zaburt/.rvm/gems/ruby-2.4.3@dbus_test/gems/ruby-dbus-0.14.1/lib/dbus/marshall.rb:212:in `do_parse'
        from /home/zaburt/.rvm/gems/ruby-2.4.3@dbus_test/gems/ruby-dbus-0.14.1/lib/dbus/marshall.rb:62:in `block in unmarshall'
        from /home/zaburt/.rvm/gems/ruby-2.4.3@dbus_test/gems/ruby-dbus-0.14.1/lib/dbus/marshall.rb:61:in `each'
        from /home/zaburt/.rvm/gems/ruby-2.4.3@dbus_test/gems/ruby-dbus-0.14.1/lib/dbus/marshall.rb:61:in `unmarshall'
        from /home/zaburt/.rvm/gems/ruby-2.4.3@dbus_test/gems/ruby-dbus-0.14.1/lib/dbus/message.rb:227:in `unmarshall_buffer'
        from /home/zaburt/.rvm/gems/ruby-2.4.3@dbus_test/gems/ruby-dbus-0.14.1/lib/dbus/message_queue.rb:139:in `message_from_buffer_nonblock'
        from /home/zaburt/.rvm/gems/ruby-2.4.3@dbus_test/gems/ruby-dbus-0.14.1/lib/dbus/message_queue.rb:38:in `pop'
        from /home/zaburt/.rvm/gems/ruby-2.4.3@dbus_test/gems/ruby-dbus-0.14.1/lib/dbus/bus.rb:441:in `wait_for_message'
        from /home/zaburt/.rvm/gems/ruby-2.4.3@dbus_test/gems/ruby-dbus-0.14.1/lib/dbus/bus.rb:458:in `send_sync'
        from /home/zaburt/.rvm/gems/ruby-2.4.3@dbus_test/gems/ruby-dbus-0.14.1/lib/dbus/bus.rb:339:in `send_sync_or_async'
        from /home/zaburt/.rvm/gems/ruby-2.4.3@dbus_test/gems/ruby-dbus-0.14.1/lib/dbus/bus.rb:365:in `introspect_data'
        from /home/zaburt/.rvm/gems/ruby-2.4.3@dbus_test/gems/ruby-dbus-0.14.1/lib/dbus/proxy_object.rb:73:in `introspect'
        from ./multiple_dbus_calls.rb:18:in `local_service_unit_is_active'
        from ./multiple_dbus_calls.rb:28:in `block in build_thread'
```

# Systemd Unit installation

With a user that has permissions to write to system folders, copy (ruby_dbus_test.service)[ruby_dbus_test.service]
as /etc/systemd/system/ruby_dbus_test.service and reload Systemd units

```
sudo cp ruby_dbus_test.service /etc/systemd/system/
sudo systemctl daemon-reload
```

