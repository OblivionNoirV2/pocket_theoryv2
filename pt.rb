require 'optparse'

#store any cmd flags 
c_args = {}
OptionParser.new do |opts|
  opts.banner = "Usage: pt.rb [options]"
    #displays when user runs with --help flag, or nothing
    #keywords arg is whatever the user passed after k
    #todo: add try catch block in case they just enter -k with nothing after
  opts.on("-k", "--keywords a,b,c", Array, "What kind of sound are you going for?") do |keywords|
    c_args[:keywords] = keywords
  end
  #parse the options passed
end.parse!
#if no keywords passed
if c_args[:keywords].nil?
  puts "Enter keywords in this format: scale, chord, or interval[emotions, ex happy, sad, dark]"
  input = gets.chomp
  c_args[:keywords] = input.split(",").map(&:strip)
end

puts "do something with the keywords: #{c_args[:keywords].inspect}"


#flag options: scales, intervals, chords [emotion]
#other flag options, intervals (flagged with minor, major, etc)
