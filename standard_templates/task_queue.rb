require 'bundler/setup'
require 'bunny'
require 'json'

### Custom function goes here below (un-hardcode this later)

def double (x)
  x * 2
end

### Custom function ends here above

amqp_conn = Bunny.new
amqp_conn.start
channel = amqp_conn.create_channel

# TODO: Unique names for everything

EXCHANGE_NAME_FOR_FUNCTION = 'submitted_inputs'
QUEUE_NAME = 'inputs_to_run'
exchange_submitted_inputs = channel.fanout(EXCHANGE_NAME_FOR_FUNCTION)
queue_inputs_to_run = channel.queue('inputs_to_run')
queue_inputs_to_run.bind(exchange_compiled_programs)

queue_inputs_to_run.subscribe(block: true) do |delivery_info, metadata, payload|
  input = JSON.parse(payload)['x'] # TODO: Unhardcode this
  output = double(input)
  
  output_json = output.to_json
  default_exchange = channel.default_exchange
  default_exchange.publish output_json,
                           routing_key: metadata[:reply_to],
                           correlation_id: metadata[:correlation_id]
end

