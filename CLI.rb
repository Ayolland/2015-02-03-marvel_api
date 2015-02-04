require 'pry'
require 'marvel_api'
require 'active_support/all'

def launch
  puts "BARE BONES MARVEL TERMINAL"
  while true 
    display_description(search)
  end
end

def display_description(array)
  system "clear"
  counter = 0
  puts "Top " + array.length.to_s + " Results from the Marvel Database:"
  h_line
  array.each do |entry|
    counter +=1
    puts counter.to_s + ": " + entry["name"]
  end
  h_line
  puts "Enter a number you would like more info on."
  puts "0 or a non-number will quit"
  input = gets.to_i
  (input != 0) ? more_info(input,array) : quit
end

string = "The Mad Titan Thanos, a melancholy, brooding individual, consumed with the concept of death, sought out personal power and increased strength, endowing himself with cybernetic implants until he became more powerful than any of his brethren."

def h_line
  puts "-" * 50
  nil
end

def paragraph(string)
  puts "No info available..." if string == ""
  loop do
    puts paragraph_line = string.truncate(80, separator: ' ', omission: '')
    string = string.from (paragraph_line.length + 1)
    break if string == nil #not sure why this works...
  end
end

def quit
    abort ("Thanks for checking it out!")
end

def more_info(selection,array)
  launch_client
  system "clear"
  puts array[selection - 1]["name"]
  h_line
  paragraph(array[selection - 1]["description"])
  h_line
  puts "press Enter to return to search"
  gets
  
end

def launch_client
  client = Marvel::Client.new
  client.configure do |config|
    config.api_key = "c254d7e19e2172fd7b0a5cd7f585e749"
    config.private_key = 'f928ea4ae3e710ad33bce4c0ce67368263d5724b'
  end 
  client
end

def search
  client = launch_client
  puts "Enter a character or group name to search the Marvel Database for..."
  puts "(0 will quit)"
  search_string = gets.chomp
  quit if search_string == "0"
  puts "Accessing the Marvel database and saving the top results"
  puts "Be patient..."
  hot_mess_array = client.characters(nameStartsWith: search_string, orderBy: 'modified')
  puts "Got it! (Press Enter)"
  hot_mess_array
 end


 launch


#binding.pry