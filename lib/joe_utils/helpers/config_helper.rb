# encoding: UTF-8

require 'json'

module ConfigHelper
  def sort_json_file(address)
    json_content = File.open(address, 'r') { |f| f.read }
    hash = JSON.load(json_content)
    structure = hash.sort_by { |key, _| key.to_s }
    hash = {}
    structure.each {|field| hash[field[0]] = field[1] }
    File.open(address, 'w+') { |f| f.write(JSON.pretty_generate(hash)) }
    puts 'File hash content has been sorted.'
  end

  def is_inside_string?()
    
  end

  def get_list_of_constants(file_content)
    file_content.match()
  end

  def select_config_in_file(file_content, config_name)
    file_content.match()
  end
end