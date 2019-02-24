# TODO: Figure out what can be language agnostic and what can't
# TODO: Currently we assume correct code, but we realistically we need error detection too
# TODO: Law of Demeter

def generate_program(function)
  File.write("submit.rb", generate_program_submit(function))
  File.write("consumer_progenitor.rb", generate_queue_progenitor(function))
  File.write("consumer_duplicate.rb", generate_queue_duplicate(function))
end

def generate_program_submit(function)
  program = read_submit_template

  function_params = extract_function_params(function)
  payload_string = "payload = #{create_payload(function_params).inspect}"
  program = program.gsub("# INSERT PAYLOAD", payload_string)
end

# String sub for now, maybe come up with a better way to do it later
def generate_queue_progenitor(function)
  function_marker = "# INSERT THE FUNCTION HERE"
  program = read_task_queue
  program = program.gsub(function_marker, function)
  program = program.gsub("# INSERT IO", generate_io(function))
end

def generate_queue_duplicate(function)
  program = generate_queue_progenitor(function)
  program.sub("# INSERT TEARDOWN", "check_should_terminate(ms_time_spent, target_time")
end
 
def extract_function_name(function)
  signature = extract_function_signature(function)
  signature.split(/[( ]/)[0]
end

# TODO: What if there are no params 
def extract_function_params(function)
  signature = extract_function_signature(function)
  function_name = extract_function_name(function)

  signature.sub(function_name, "").delete('()').split(',') .map do |var| 
    var.strip 
  end
end

def extract_function_signature(function)
  declaration_lines = function.lines.filter do |line| 
    line.include? 'def' 
  end
  declaration_lines[0].split('def')[1].strip
end

def generate_io(function)
  function_name = extract_function_name(function)
  function_params = extract_function_params(function)
  parsed_payload = create_payload(function_params)
  generate_call_for_function(function_name, parsed_payload, function_params)
end

# No parms?
def create_payload(function_params)
  function_params.map do |param_name|
    [param_name, 10] 
  end.to_h
end

# What if the variable names conflict
# What about ordering
def generate_call_for_function(function_name, param_hash, function_params)
  output = ""
  payload_variable_name = 'parsed_payload'
  function_params.each do |param| 
    output += "#{param} = #{payload_variable_name}['#{param}']\n"
  end

  joined_param_string = function_params.join(', ')
  output += "output = #{function_name}(#{joined_param_string})"
  return output
end

def read_submit_template
  submit_template = 'standard_templates/submit_code.rb'
  File.read(submit_template)
end

def read_task_queue
  task_queue_tamplate = 'standard_templates/task_queue.rb'
  File.read(task_queue_tamplate)
end

# TEST Code delete later

program = "
def add(x, y, z)
  x + y + z
end
"
generate_program(program)


