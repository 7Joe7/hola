# encoding: UTF-8

require 'fileutils'
require 'zip'

module FilesHelper

  def get_current_address
    Dir.pwd
  end

  def get_current_folder
    File.basename(Dir.pwd)
  end

  def dir_exists?(location)
    File.directory?(location) ? true : puts("Directory #{location} doesn't exist.")
  end

  def file_exists?(location)
    File.exist?(location) ? true : puts("The file #{location} doesn't exist.")
  end

  def remove_dir(location)
    FileUtils.rm_rf(location)
    puts "Directory #{location} removed."
  end

  def create_dir(location, options = {})
    if dir_exists?(location)
      if options[:overwrite]
        remove_dir(location)
      else
        puts "Directory #{location} already exists."
        return
      end
    end
    FileUtils.mkdir_p(location)
    puts "Directory #{location} created."
  end

  def for_all_in_dir(location, options = {})
    Dir.glob(File.join(File.join(location, options[:recursive] && '**'), options[:matching] || '*')) { |f| yield f }
  end

  def unzip(zip_file, location)
    create_dir(location)
    Zip::File.open(zip_file) { |content| content.each { |f| content.extract(f, File.join(location, f.name)) } }
  end

  def zip(zip_file)
    Zip::File.open(zip_file, Zip::File::CREATE) { |zip| yield zip }
  end

  def zip_folder(zip_file, to_zip, options = {})
    zip(zip_file) do |zip|
      for_all_in_dir(to_zip, matching: options[:matching], recursive: true) { |file| zip.add(File.basename(file), file) }
      yield zip if block_given?
    end
  end

  def add_to_open_zip(zip, file)
    zip.add(File.basename(file), file)
  end

  def edit_file(address)
    new_file_content = yield File.open(address, 'r') { |f| f.read }
    File.open(address, 'w+') { |f| f.write(new_file_content) }
  end

  def create_file_by_template(template_path, path)
    text = load_file_text(template_path)
    yield text if block_given?
    create_file(path, text)
  end

  def load_file_text(path)
    File.open(path, 'r') { |f| f.read } if file_exists?(path)
  end

  def create_file(path, text)
    File.open(path, 'w+') { |f| f.write(text) }
    puts "File #{path} created."
  end

# Replaces text in all files in the folder address
# @param text [String] text to be replaced
# @param folder_address [String] folder address to search in
# @return nil
  def replace_in_all(text, folder_address)
    Dir[File.join(folder_address, '*')].each do |address|
      content = File.open(address, 'r') { |f| f.read }
      if content.gsub!(text) { |match| yield match }
        File.open(address, 'w+') { |f| f.write(content) }
        puts "Replaced all in: #{address}."
      end
    end
  end

# Puts all file addresses which contain the text
# @param text [String] searched text
# @param location [String] folder address searched
# @return nil
  def find_in_all(text, location)
    Dir[File.join(location, '*')].each do |address|
      File.open(address, 'r') { |f| puts "Found in file: #{f}" if f.read =~ /#{text}/ }
    end
  end

  def catch_errno_enoent
    yield
  rescue Errno::ENOENT => e
    # Nothing bad happened
  end
end