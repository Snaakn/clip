#! /usr/bin/ruby

require 'yaml'

class Clipboard
  def initialize
    if !File.exist?("vault.yaml")
      @vault = File.new('vault.yaml', 'w')
    end
    @vault = File.open('vault.yaml', 'r+')
    @list = YAML.load(@vault.read)
    if !@list
      @list = Hash.new
    end
  end
  def save key
    @vault = File.open('vault.yaml', 'w+')
     str = IO.popen('pbpaste', 'w+').read
     h = Hash.new
     h = {"#{key}" => "#{str}"}
     puts @list.class
     @list.merge!(h)
     @vault.write(@list.to_yaml)
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
    @vault = File.open('vault.yaml', 'w+')
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
  else
    puts "Use 'sv #name' to save clipboard, cp #name to load to clipboard, list to list all saved keywords"
  end
end

get_cmd()
