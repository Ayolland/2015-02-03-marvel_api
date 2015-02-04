require 'pry'
require 'marvel_api'
require 'active_support/all'

def launch
  puts "BARE BONES MARVEL TERMINAL"
  while true 
    array = search
    if array == []
      puts "Sorry, no entries found."
      puts ""
    elsif display_description(array)
    end
  end
end

def display_description(array)
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
  client = launch_client
  puts "Name: " + array[selection - 1]["name"]
  h_line
  puts "Description:"
  paragraph(array[selection - 1]["description"])
  h_line
  puts "Searching for relevant events..."
  puts "Be patient..."
  stories = client.character_events(array[selection - 1]["id"])
  h_line
  if stories == []
    puts "Sorry, no events found." 
  else
    puts "Enter 2 to display EVENTS"
  end
  puts "Enter 1 to return to RESULTS."
  puts "Enter 0 to return to SEARCH."
  input = gets.to_i
  if input == 1
   display_description(array)
  elsif input == 2
    display_events(stories)
  end
end

def display_events(array)
  array.each do |entry|
    #binding.pry
    puts "Event: " + entry.title #apparently these are hashies...
    paragraph(entry.description)
    puts ""
    puts "(press Enter to continue or 1 to finish)"
    gets.to_i == 1 ? break : entry #entry is meaningless here
  end
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
  hot_mess_array
 end


 launch


#binding.pry