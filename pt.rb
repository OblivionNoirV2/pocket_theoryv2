require 'optparse'
class InputGathering
  def parse_keywords
    # Store any cmd flags
    c_args = {}
    #todo: Split the flags so it can recognize the different segments 
    @parser = OptionParser.new do |opts|
      opts.banner = "Usage: pt.rb [options]"

      # displays when run with --help flag, or nothing
      # Keywords arg is whatever the user passed after k
      opts.on("-k", "--keywords a,b,c", Array, "What kind of sound are you going for?") do |keywords|
        c_args[:keywords] = keywords
      end
      #todo: deal with edge case where words starting with h also trigger the -h flag
      opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        
      end
    end
    
    begin
      @parser.parse!
    rescue OptionParser::MissingArgument => no_keyword
      you_screwed_up()
    rescue OptionParser::InvalidOption => wrong_keyword
      you_screwed_up()
    end

    return c_args
  end

  def you_screwed_up()
      puts("Add arguments like -k (args) or --keywords (multiple args)")
      puts(@parser)
      parse_keywords()
  end
end
ig = InputGathering.new()
options = ig.parse_keywords()
puts (options)

#flag options: scales, intervals, chords [emotion]
#other flag options, intervals (flagged with minor, major, etc)

#get options from above, then determine what to display 

class Analyze
  def initialize
    
  end

  def get_values(first, second)

  end 
end


class Descriptions < Analyze
  def initialize
    
  end
end