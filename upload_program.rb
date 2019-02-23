require 'faraday'

function = "
def double(x)
  x * 2
end
"

# TODO: Unhardcode the server
API_URL = "http://localhost:4567"
api = Faraday.new(url: API_URL)

response = api.post '/submit', {language: 'ruby', 
                                function: function}

p response.body
