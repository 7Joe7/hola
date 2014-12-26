module ConsoleHelper
  def get_input(message)
    puts message
    value = gets
    value == 'exit' ? exit_program : next_step(value)
  end

  def exit_program
    exit
  end
end