require 'pry'
require 'marvel_api'
require 'active_support/all'

# Public: launch
# Begins the CLI and loops the search method infinitely.
#
# Returns:
# nil (also it should never return at all.)


def launch
  puts "BARE BONES MARVEL TERMINAL"
  while true #the only way out of this loop is breaking it at the terminal or caling #quit
    array = search
    display_description(array)
  end
end

# Public: display_description
# Prints out a numbered list of characters found by the Marvel API gem
# 
# Returns:
# nil

def display_description(array)
  trash = []
  array.each do |entry|
    trash.push(entry) if entry.description == "" #puts any search result with no description into trash
  end
  array = array - trash
  #binding.pry
  if array == []
    puts "Sorry, no detailed entries found."
    puts ""
  else
    counter = 0
    puts array.length.to_s + " results from the Marvel database:"
    h_line
    array.each do |entry|
      counter +=1
      puts counter.to_s + ": " + entry["name"]
    end
  end
  h_line
  puts "Additional entries with no description:"
  trash.each do |entry|
    puts " - " + entry["name"]
  end
  #binding.pry
  h_line
  puts "Enter a number you would like more info on." if array != []
  puts "0 or a non-number will return to SEARCH."
  input = gets.to_i
  (input != 0) ? more_info(input,array) : search
end

# Public: h_line
# Prints 80 dashes
#
# Returns:
# nil
 
def h_line
  puts "-" * 80
  nil
end

# Public: paragraph
# Takes a string as a prarmeter and prints it as a paragraph, broken up by words, 80 character lines
# NOTE: this uses active support methods
#
# Parameters:
# string  - String: the text to be printed.
#
# Returns:
# nil ?

def paragraph(string)
  puts "No info available..." if string == "" #technically useless now...
  loop do
    puts paragraph_line = string.truncate(80, separator: ' ', omission: '') #prints the first 80 characters, stopping at the nearest space before
    string = string.from (paragraph_line.length + 1) #removes that first line from the original string, and then the loop repeats
    break if string == nil #not entrirely sure why this works, but ends the loop when there is no string left.
  end
end

# Public: quit
# Quits the program and prints the enclosed message.
#
# Returns:
# I have no idea how it would even be possible to test this return, but I'm going to guess nil

def quit
    abort ("Thanks for checking it out!") 
end

# Public: more_info
# Displays the "description" key for a selected character hashie in the array
#
# Parameters:
# selection - Integer: index+1 of the hashie to be called 
# array     - Array: the array of hashies pulled from the API
#
# Returns:
# nil

def more_info(selection,array)
  client = launch_client # loading up a new API client object
  puts ""
  puts "Name: " + array[selection - 1]["name"]
  h_line
  puts "Description:"
  paragraph(array[selection - 1].description) #hashies let you call keys with a .
  h_line
  puts "Searching for relevant events..."
  puts "Be patient..."
  stories = client.character_events(array[selection - 1].id) #this calls up an array of events that use the character id of the current selection.
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
   display_description(array) #re-loads the array into the menu. It appears to go back.
  elsif input == 2
    display_events(stories) #sends the array of event hashies to be printed out.
  end
end

# Public: display_events
# Takes an array of hashies filled with events linked to a character and prints them.
#
# Parameters:
# array - Array: filled with event hashies
#
# Returns:
# nil

def display_events(array)
  array.each do |entry|
    #binding.pry
    puts "Event: " + entry.title #hashies let you call keys with a .
    paragraph(entry.description) #hashies let you call keys with a .
    puts ""
    puts "(press Enter to continue or 1 to finish)"
    gets.to_i == 1 ? break : entry #entry is meaningless here, it just continues the loop.
  end
  h_line
end

# Public: launch_client
# Creates an new instance of the Client object supplied in the Marvel API gem, and configs it using my API keys.
# 
# Returns:
# client - The client object created.

def launch_client
  client = Marvel::Client.new
  client.configure do |config|
    config.api_key = "c254d7e19e2172fd7b0a5cd7f585e749"
    config.private_key = 'f928ea4ae3e710ad33bce4c0ce67368263d5724b'
  end 
  client
end

# Public: search
# Searches the Marvel API for Characters based on user input
#
# Returns:
# hot_mess_array - Array: filled with hashies representing entries for matching Marvel characters.

def search
  client = launch_client # loading up a new API client object
  puts "Enter a character or group name to search the Marvel Database for..."
  puts "(Enter 0 to QUIT)"
  search_string = gets.chomp
  quit if search_string == "0"
  puts "Accessing the Marvel database and saving the top results"
  puts "Be patient..."
  hot_mess_array = client.characters(nameStartsWith: search_string, orderBy: 'modified') # I wish I knew what 'modified' does...
  hot_mess_array
 end


launch


#binding.pry