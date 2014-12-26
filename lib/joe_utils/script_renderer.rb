module ScriptRenderer

  # @param [String] file_path
  def render_script(file_path)
    lines = File.open(file_path, 'r') { |f| f.readlines }

    structures, requires, comments, modules, klass, methods, class_name, full_class_name = [], [], [], [], '', {}, '', ''
    class_began, private_began, public_began, methods_began, structure_began = false, false, true, false, false

    lines.each do |line|
      line.strip!
      if line[0] == '#'
        comments << line[1..-1]
      elsif line =~ /^require /
        match = line.match(/\brequire ['"]/)
        requires << match.post_match[0..-2]
      elsif line =~ /^module /
        match = line.match(/\bmodule /)
        modules << match.post_match[/\b[A-Z]+(::[A-Z_]+)*\b/]
      elsif line =~ /^class /
        class_began = true
        klass = line[/^class [A-Za-z_]+(::[A-Za-z_]+)*/][6..-1].split('::').last
      elsif line =~ /^def initialize/
        methods_began = true
      elsif line =~ /^def /
        methods[line[/^def \w+/][4..-1]] = {arguments: []}
      elsif line =~ /^private /
        private_began = true
      elsif line =~ /^[A-Z]+\b = {/ && class_began && !methods_began
        structure_began = true
        structures << {name: line[/^[A-Z]+\b/] }
        structures.last[:content] = {}
      elsif line =~ /^[a-z_]+: ?/ && structure_began
        match = line.match(/^[a-z_]+: ?/)
        structures.last[:content][match.to_s[0..-3].to_sym] = "'\"".include?(match.post_match[0]) ? match.post_match[1..-3] : match.post_match[0..-2]
      elsif line =~ /^:[a-z]+ ?=> ?/ && structure_began
        match = line.match(/^:[a-z]+ ?=> ?/)
        structures.last[:content][match.to_s[1..-5].to_sym] = "'\"".include?(match.post_match[0]) ? match.post_match[1..-3] : match.post_match[0..-2]
      elsif line == '}'
        structure_began = false
      else
        # puts line
      end
    end
  end

  def get_whole_class_name(file_content)
    file_content[/#{@app_structure.vendor}::#{@app_structure.app_name_unof}::[a-zA-Z\d]+/]
  end

  def get_class_name(file_content)
    get_whole_class_name(file_content).split('::').last
  end
end