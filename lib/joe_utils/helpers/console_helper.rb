module ConsoleHelper
  def get_input(message)
    puts message
    value = gets
    value == 'exit' ? exit_program : next_step(value)
  end

  def process_input(input, options = {})
    input.each { |arg| yield arg }
    options
  end

  def exit_program
    exit
  end
end