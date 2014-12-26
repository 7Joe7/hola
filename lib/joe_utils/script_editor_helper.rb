# encoding: UTF-8

module ScriptEditorHelper
  # @param pars [Array]
  # @return [nil]
  def add_pars_to_controllers(pars)
    Dir["#{@app_structure.controllers_fld}/*"].each do |controller|
      content = load_file_text(controller)
      content.sub!(/CONFIG = \{[\s\w:',.\/\?=\-]*?\s\s}/) { |config|
        pars.each { |par| config.sub!(/CONFIG = \{\n/, "CONFIG = {\n\t\t\t#{par},\n") unless content[par] || content[par[/['"][\s\w:,.\/\?=\-]+?['"]/]] }
        config
      }
      create_file(controller, content)
    end
  end
end