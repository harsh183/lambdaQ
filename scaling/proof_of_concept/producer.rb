#!/usr/bin/env ruby

#A producer that sends a timestamp of when it first loads a request to a queue
require 'bunny'

connection = Bunny.new(automatically_recover: false)
connection.start

channel = connection.create_channel
queue = channel.queue('task_queue', durable: true)

msTime = Time.now.to_s
puts msTime

queue.publish(msTime, persistent: true)
puts " [x] Sent to queue "

connection.close



