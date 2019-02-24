# require 'bundler/setup'
require 'bunny'
require 'json'


def add(x, y, z)
  x + y + z
end


channel = set_up_channel

target_time = 500

EXCHANGE_NAME_FOR_FUNCTION = 'submitted_inputs'
QUEUE_NAME = 'inputs_to_run'
exchange_submitted_inputs = channel.fanout(EXCHANGE_NAME_FOR_FUNCTION)
queue_inputs_to_run = channel.queue('inputs_to_run')
queue_inputs_to_run.bind(exchange_submitted_inputs)

channel.prefetch(1)
queue_inputs_to_run.subscribe(block: true) do |delivery_info, metadata, payload|
  parsed_payload = JSON.parse(payload)
  
  startTime = Time.parse(body)
  currentTime = Time.now
  ms_time_spent = ((currentTime - startTime) * 1000).to_i

  check_should_duplicate(ms_time_spent, target_time)
  
  x = parsed_payload['x']
y = parsed_payload['y']
z = parsed_payload['z']
output = add(x, y, z)
  
  p "#{parsed_payload} became #{output}"
  output_json = output.to_json
  default_exchange = channel.default_exchange
  default_exchange.publish output_json,
                           routing_key: metadata[:reply_to],
                           correlation_id: metadata[:correlation_id]

  check_should_terminate(ms_time_spent, target_time
end

