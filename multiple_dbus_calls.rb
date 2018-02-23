#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#

require 'dbus'

PARALLEL = 5
UNIT_NAME = 'ruby_dbus_test.service'

def local_service_unit_is_active(k)
  puts "current thread #{Thread.current[:num]}\n"
  sys_bus = DBus.system_bus
  core_service = sys_bus.service('org.freedesktop.systemd1')
  obj = core_service.object('/org/freedesktop/systemd1')
  obj.default_iface = 'org.freedesktop.systemd1'

  puts "before obj.introspect #{Thread.current[:num]}\n"
  obj.introspect
  puts "after obj.introspect #{Thread.current[:num]}\n"
  obj
end

def build_thread(k)
  Thread.new do
    Thread.current.abort_on_exception = true
    Thread.current[:num] = k

    resp = local_service_unit_is_active(UNIT_NAME)
    puts "\nFINISHED: result for #{k} active: #{resp.bus.inspect}\n"
  end
end

threads = []

PARALLEL.times do |k|
  puts "building thread #{k + 1} out of #{PARALLEL}"
  threads << build_thread(k)
end

threads.each(&:join)

