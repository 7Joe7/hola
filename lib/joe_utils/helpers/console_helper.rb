module ConsoleHelper
  def process_input(talks, message_key)
    puts talks[message_key]
    value = gets
    value == 'exit' ? exit_program(talks) : yield(value)
  end

  def exit_program(talks)
    puts talks['exit'] if talks['exit']
    exit
  end
end