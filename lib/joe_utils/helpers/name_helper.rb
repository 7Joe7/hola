# encoding: UTF-8

module NameHelper

  def create_nice_file_name(file_content)
    class_name = file_content.match(/#{@app_structure.vendor}::[A-Z_]+::[a-zA-Z]+/).to_s.split('::').last
    class_name.gsub!(/[A-Z]+/) do |capital_letters|
      if capital_letters.size > 1 && class_name[-capital_letters.size..-1] != capital_letters
        "_#{capital_letters[0..-2].downcase}_#{capital_letters[-1].downcase}"
      else
        "_#{capital_letters.downcase}"
      end
    end
    class_name
  end
end