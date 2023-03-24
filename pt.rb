require 'optparse'

class InputGathering

  def initialize()
    #use other to display less common modes that don't fit a particular theme, like hirajoshi or dorian
    @emotions_array = [
      "happy", "sad", "dissonant", "other"
    ]
    @concept_array = [
      "chords", "scales", "intervals"
    ]
  end 
  def parse_keywords()

    @parser = OptionParser.new do |opts|
      opts.banner = "Usage: pt.rb [options]"

      #displays when run with --help flag, or nothing
      opts.on("-m, a, b, c", String, "What kind of sound are you going for?") do |keywords_str|
        #split the string up into an array
        keywords_array = keywords_str.split(",")
        #check for proper formatting, like something[something]
        keywords_array.map do |keyword|
          #also check that it fits the chord/scale/interval[emotion] format
          if keyword.match?(/\A\w+\[[\w\s]+\]\z/) && are_args_included(keyword)
            return keywords_array 
          else
            you_screwed_up()
          end
        end
      end
      opts.on("-e", "--emotions", "Show the emotions array") do
        puts(@emotions_array)
        exit()
      end

      opts.on("-c", "--concepts", "Show the concepts array") do
        puts(@concept_array)
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

  def are_args_included(keyword)
  #check if the input contains any of the array options for emotions 
  #and the words chord/scale/interval
    emotion_found = false
    concept_found = false

    @emotions_array.each do |e|
      if keyword.include?(e)
        emotion_found = true
        break
      end
    end

    @concept_array.each do |c|
      if keyword.include?(c)
        concept_found = true
        break
      end
    end
    #This is true if both bools are true
    return emotion_found && concept_found
  end

$ig = InputGathering.new()
  def you_screwed_up()
    puts("Add arguments like -m scales/chords/intervals[emotion] \nand any additional arguments seperated by a comma(no space between)")
    puts(@parser)
    $ig.parse_keywords()
  end
end

input_array = $ig.parse_keywords()
puts(input_array)
#flag options: scales, intervals, chords [emotion]
#other flag options, intervals (flagged with minor, major, etc)

#get options from above, then determine what to display 
#should be easy, just check what it contains and use a switch to match it
class Results

  def initialize()
    @input_array = input_array

    @scales = {
      "happy" => ["Major(Ionian)", "Lydian"],
      "sad" => ["Minor(Aeolian)", "Melodic Minor", "Harmonic Minor", "Phrygian"],
      "dissonant" => ["Locrian", "Super Locrian", "Chromatic"],
      "other" => ["Dorian", "Mixolydian", "Whole Tone", ""]
    }
  end

  def display_results()

  end
  #give descriptions of each match, how to formulate it
  def evaluate()

  end
  
end

