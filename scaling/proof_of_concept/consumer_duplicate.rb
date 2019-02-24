#!/usr/bin/env ruby
require 'bunny'
require 'time'


def duplicate_or_terminate(ms_time_spent)
  target_time = 5000

  # Creates a new worker when a request is stuck in a queue for too long.
  if ms_time_spent > target_time
    puts "Adding worker"
    Thread.new do
      # Creates a new xterm terminal that executes consumer_duplicate.rb
      # the terminal will be closed if consumer_duplicate.rb is not running.
      `#{'xterm -e ruby consumer_duplicate.rb'}`
    end
  end


  # Kills a worker when a request is being processed too quickly.
  if ms_time_spent <= target_time
    puts "Terminating worker"
    system( "" ) or exit
  end


end




connection = Bunny.new(automatically_recover: false)
connection.start

channel = connection.create_channel
queue = channel.queue('task_queue', durable: true)

channel.prefetch(1)
puts ' [*] Waiting for messages. To exit press CTRL+C'

begin
  queue.subscribe(manual_ack: true, block: true) do |delivery_info, _properties, body|
    # Creates a notification that a worker has retrieved a request from a queue.
    puts " [x] Received '#{body}'"

    # Calculates the time that a request spent being stuck in a queue.
    startTime = Time.parse(body)
    currentTime = Time.now
    ms_time_spent = ((currentTime - startTime) * 1000).to_i
    puts "Time spent in queue (millisecond) " + ms_time_spent.to_s

    # Hardcoded delay to simulate the processing of a request.
    sleep 3

    puts ' [x] Done'
    channel.ack(delivery_info.delivery_tag)

    # Decide whether there should be more or less worker.
    duplicate_or_terminate(ms_time_spent)

  end
rescue Interrupt => _
  connection.close
end