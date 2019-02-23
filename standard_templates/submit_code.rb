require 'bundler/setup'
require 'bunny'
require 'json'

# TODO: Make this sinatra supports and take args from the web

amqp_conn = Bunny.new
amqp_conn.start
channel = amqp_conn.create_channel

EXCHANGE_NAME_FOR_FUNCTION = 'submitted_inputs'
exchange_for_function = channel.fanout(EXCHANGE_NAME_FOR_FUNCTION)

# TODO: Unhardcode this (take from the url) - perhaps as json and/or params - whichever is simpler
payload = { 'x': 10 }

exchange_for_function.publish(payload.to_json)

# TODO: Have some way to collect back responses
