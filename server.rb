require 'sinatra'

# TODO: Make a program that composes the api request - another ruby program

def save_program(program_text)
  File.write('programs/function.rb', program_text)
  # TODO: Better file and folder structure for multiple users etc
  # A database maybe?
end   

get '/' do
  "Hello World"
  # TODO: Put an actual web interface
end

post '/submit' do
  # TODO: Support multiple functions
  save_program(params[:function])
  "Did it in: #{params[:language]}"
  # TODO: Support multiple languages
end

# TODO: Some way to let people define chaining workflows - maybe a chain() or pipe() call - more advanced version is auto detecting but that's for later

# TODO: Construct the json messaging based on the function parameters
# TODO: Expose Some url to call the function

