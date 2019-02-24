# require 'bundler/setup'
require 'bunny'
require 'json'
load 'utility.rb'

# TODO: Make this sinatra supports and take args from the web
# TODO: Look up RabbitMQ http support

channel = set_up_channel

EXCHANGE_NAME_FOR_FUNCTION = 'submitted_inputs'
exchange_for_function = channel.fanout(EXCHANGE_NAME_FOR_FUNCTION)

# INSERT PAYLOAD GENERATION HERE
payload["time"] = Time.now.to_s

exchange_for_function.publish(payload.to_json)

# TODO: Have some way to collect back responses
