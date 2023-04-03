require 'optparse'

class InputGathering
  def initialize()
    #use other to display less common modes that don't fit a particular theme, like hirajoshi or dorian
    @stats_array = [
      
    ]

    $stats_found = []
  end 
  def parse_keywords()
    @parser = OptionParser.new do |opts|
      opts.banner = "Usage: pt.rb [options]"

      #displays when run with --help flag, or nothing
      opts.on("-s, a, b, c", String, "Allocate stats") do |keywords_str|
        #split the string up into an array
        keywords_array = keywords_str.split(",")
        #map all keywords to the array
        keywords_array.map do |keyword|
          #also check that it fits the stat[number] format
          if keyword.match?(/\A\w+\[[\w\s]+\]\z/) && are_args_included(keyword)
            #issue is that it returns after only one match is found, need to return 
            #the array AFTER ensuring all matches are found
            return keywords_array 
          else
            you_screwed_up()
          end
        end
      end
      opts.on("-st", "--stats", "Show the stats array") do
        puts(@stats_array)
        exit()
      end

      opts.on_tail("-h", "--help", "Show this message") do
        puts(opts)
        exit()
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
  #culprit detected: keyword is only the first entry
  def are_args_included(keyword)
  #check if the input contains any of the array options for emotions 
  #and the words chord/scale/interval
    stat_found = false
    puts("Keyword: #{keyword}")
    @stats_array.each do |e|
      #Check if the keyword has any matches in the array
      if keyword.include?(e)
        #then add any found to the corresponding array
        $stats_found.push(e)
        #Then ensure it has found all the matches before it breaks
        stats_found = true
      break
      end
    end

    return stats_found
  end

$ig = InputGathering.new()
  def you_screwed_up()
    puts("Add arguments like -s stat[number] \nand any additional arguments seperated by a comma(no space between)")
    puts(@parser)
    $ig.parse_keywords()
  end
end

$input_array = $ig.parse_keywords()


#get options from above, then determine what to use

class Results

  def initialize()

  end

  def evaluate()
    #puts($input_array)
    #fetch the stats and numbers used from the class above
    puts($stats_found)
  end
  
end

rs = Results.new()
rs.evaluate()