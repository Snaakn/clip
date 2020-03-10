#! /usr/bin/ruby

require 'yaml'

class Clipboard
  def initialize
    if !File.exist?("clipboard.yml")
      @clipboard = File.new('clipboard.yml', 'w')
    end
    @clipboard = File.open('clipboard.yml', 'r+')
    @list = yml.load(@clipboard.read)
    if !@list
      @list = Hash.new
    end
  end
  def save key
    @clipboard = File.open('clipboard.yml', 'w+')
     str = IO.popen('pbpaste', 'w+').read
     h = Hash.new
     h = {"#{key}" => "#{str}"}
     puts @list.class
     @list.merge!(h)
     @clipboard.write(@list.to_yml)
    puts "SAVED"
  end

  def copy key
    IO.popen('pbcopy', 'w') {|i| i << @list[key] }
    puts "Copied to clipboard"
  end

  def list
    puts "possible keywords are:"
    puts @list.keys
  end
  def reset
    @clipboard = File.open('clipboard.yml', 'w+')
  end
  def delete key
    @clipboard = File.open('clipboard.yml', 'w+')
    puts @list.class
    @list.delete("#{key}")
    @clipboard.write(@list.to_yml)
    puts "Deleted"
  end

end


@clip = Clipboard.new()
@arg_array = ARGV

def get_cmd
t = Time.now.day.to_s + Time.now.hour.to_s+ Time.now.min.to_s + Time.now.sec.to_s
#  puts @arg_array.length
#  puts @arg_array.to_s

# check input if a name was given
#  else name will be generated using day and time
if @arg_array[1].to_s == ''
  @arg_array[1] = "EMPTY#{t}"
end

# check which command was given
  cmd = @arg_array[0].to_s
  if cmd == "sv"
    @clip.save(@arg_array[1])
  elsif cmd == "cp"
    @clip.copy(@arg_array[1])
  elsif cmd == "ls"
    @clip.list
  elsif cmd == "reset"
    @clip.reset
  elsif cmd == "DELETE"
    @clip.delete(@arg_array[1])
  else
    puts "Use 'sv #name' to save clipboard, cp #name to load to clipboard, list to list all saved keywords"
  end
end

get_cmd()
