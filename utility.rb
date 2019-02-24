require 'bunny'
require 'json'

# Writes and returns channel using rabbit mq adapter, only one per thread
def set_up_channel
  amqp_conn = Bunny.new
  amqp_conn.start
  channel = amqp_conn.create_channel
end

#take input from exchange and bind to new output queue, given names
def bind_exchange_to_queue(channel, exchange_in_name, queue_name)
  exchange_source = channel.fanout(exchange_in_name)
  queue_output = channel.queue(queue_name) 
  queue_output.bind(exchange_source)
  return queue_output
end

#take input from exchange and bind to new output exchange, given names
#return current queue, output exchange
def bind_exchange_to_exchange(channel, exchange_in_name, queue_name, exchange_out_name)
  exchange_source = channel.fanout(exchange_in_name)
  queue_current = channel.queue(queue_name)
  queue_current.bind(exchange_source)
  exchange_output = channel.fanout(exchange_out_name)
  return queue_current, exchange_output
end


#loop through queue, compute result of input via function, and output to exchange
def deploy_function_to_exchange(queue_current, exchange_out, user_func = function)
    queue_current.subscribe(block: true, manual_ack: false) do |delivery_info, metadata, payload|
    input = payload
    result = user_func.call(input)
    exchange_out.publish(payload,
                         reply_to: metadata[:reply_to],
                         correlation_id: metadata[:correlation_id])
    puts "#{input} became #{output}"
  end
end

def check_should_duplicate(ms_time_spent, target_time)

  # Creates a new worker when a request is stuck in a queue for too long.
  if ms_time_spent > target_time * 2
    puts "Adding worker"
    Thread.new do
      # Creates a new xterm terminal that executes consumer_duplicate.rb
      # the terminal will be closed if consumer_duplicate.rb is not running.
      `#{'xterm -e ruby consumer_duplicate.rb'}`
    end
  end
end

def check_should_terminate(ms_time_spent, target_time)
  # Kills a worker when a request is being processed too quickly.
  if ms_time_spent <= target_time * 0.5
    puts "Terminating worker"
    system( "" ) or exit
  end
end

