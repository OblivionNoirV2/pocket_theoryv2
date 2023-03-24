require 'optparse'
selecting = true

class InputGathering

  def parse_keywords

    @parser = OptionParser.new do |opts|
      opts.banner = "Usage: pt.rb [options]"

      # displays when run with --help flag, or nothing
      # Keywords arg is whatever the user passed after k
      opts.on("-k, a, b, c", String, "What kind of sound are you going for?") do |keywords_str|
        keywords_array = keywords_str.split(",")
        keywords_array.map do |keyword|
          if keyword.match?(/\A\w+\[[\w\s]+\]\z/)
           return keywords_array
          else
            you_screwed_up()
          end
        end
      end
      #todo: deal with edge case where words starting with h also trigger the -h flag
      opts.on_tail("-h", "--help", "Show this message") do
        puts(opts)
        exit
      end
    end

    begin
      @parser.parse!
      rescue OptionParser::MissingArgument => no_keyword
        you_screwed_up()
      rescue OptionParser::InvalidOption => wrong_keyword
        you_screwed_up()
      rescue OptionParser::InvalidArgument => invalid_argument
        you_screwed_up()
    end

  end
$ig = InputGathering.new()
  def you_screwed_up()
    puts("Add arguments like -k something[emotion] \nand any additional arguments seperated by a comma")
    puts(@parser)
    $ig.parse_keywords()
  end
end
=begin
      puts("Add more? (y if yes)")
            again = gets.chomp()
            if (again == "y")
              $ig.parse_keywords()
            else 
              selecting = false
            end
=end
#loop it until the user is done
#while (selecting)
  x = $ig.parse_keywords()
  puts(x)
   
#end




#flag options: scales, intervals, chords [emotion]
#other flag options, intervals (flagged with minor, major, etc)

#get options from above, then determine what to display 

class Analyze
  def initialize()
    
  end

  def get_values(first, second)

  end 
end


class Descriptions < Analyze
  def initialize()
    
  end
end