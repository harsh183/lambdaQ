require 'bunny'
require 'json'

#ESTABLISHING RABBIT MQ CONNECTION
#writes and returns channel using rabbit mq adapter, only one per program
def set_up_channel
	amqp_conn = Bunny.new
	amqp_conn.start
	p "connection established"
	channel = amqp_conn.create_channel
	p "channel created"
	return channel
end

#take input from exchange and bind to new output queue, given names
def bind_exchange_to_queue(channel, exchange_in_name, queue_name)
	exchange_source = channel.fanout(exchange_in_name)
	puts "accessed exchange"
	
	#current queue
	queue_output = channel.queue(queue_name) 
	
	#bind queue to fanout exchange
	queue_output.bind(exchange_source)
	
	return queue_output
end

#take input from exchange and bind to new output exchange, given names
#return current queue, output exchange
def bind_exchange_to_exchange(channel, exchange_in_name, queue_name, exchange_out_name)
	exchange_source = channel.fanout(exchange_in_name)
	puts "accessed exchange"
	
	#current queue
	queue_current = channel.queue(queue_name)

	#bind queue to fanout exchange
	queue_current.bind(exchange_source)

	#output exchange
	exchange_output = channel.fanout(exchange_out_name)
	
	return queue_current, exchange_output
end


#loop through queue, compute result of input via function, and output to exchange
def deploy_function_to_exchange(queue_current, exchange_out, user_func = function)
	count = 0
	#set manual acknowledge to false TO PREVENT MEMORY LEAK
	queue_current.subscribe(block: true, manual_ack: false) do |delivery_info, metadata, payload|
		#input
		input = payload
		result = user_func.call(input)
		exchange_out.publish(payload,
				     reply_to: metadata[:reply_to],
				     correlation_id: metadata[:correlation_id])
		puts "processed " + count.to_s
		count = count + 1
	end
end

