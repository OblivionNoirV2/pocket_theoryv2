require 'optparse'

class InputGathering

  def parse_keywords()

    @parser = OptionParser.new do |opts|
      opts.banner = "Usage: pt.rb [options]"

      #displays when run with --help flag, or nothing
      opts.on("-k, a, b, c", String, "What kind of sound are you going for?") do |keywords_str|
        #split the string up into an array
        keywords_array = keywords_str.split(",")
        #check for proper formatting, like something[something]
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
    puts("Add arguments like -k something[emotion] \nand any additional arguments seperated by a comma(no space between)")
    puts(@parser)
    $ig.parse_keywords()
  end
end

x = $ig.parse_keywords()
puts(x)
   





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