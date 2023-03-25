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
    $concepts_found = []
    $emotions_found = []
  end 
  def parse_keywords()
    @parser = OptionParser.new do |opts|
      opts.banner = "Usage: pt.rb [options]"

      #displays when run with --help flag, or nothing
      opts.on("-m, a, b, c", String, "What kind of sound are you going for?") do |keywords_str|
        #split the string up into an array
        keywords_array = keywords_str.split(",")
        #map all keywords to the array
        keywords_array.map do |keyword|
          #also check that it fits the chord/scale/interval[emotion] format
          if keyword.match?(/\A\w+\[[\w\s]+\]\z/) && are_args_included(keyword)
            #issue is that it returns after only one match is found, need to return 
            #the array AFTER ensuring all matches are found
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
  #culprit detected: keyword is only the first entry
  def are_args_included(keyword)
  #check if the input contains any of the array options for emotions 
  #and the words chord/scale/interval
    emotion_found = false
    concept_found = false
    puts("Keyword: #{keyword}")
    @emotions_array.each do |e|
      #Check if the keyword has any matches in the array
      if keyword.include?(e)
        #then add any found to the corresponding array
        $emotions_found.push(e)
        #Then ensure it has found all the matches before it breaks
        emotion_found = true
      break
      end
    end

    @concept_array.each do |c|
      if keyword.include?(c)
        $concepts_found.push(c)
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

$input_array = $ig.parse_keywords()

#flag options: scales, intervals, chords [emotion]
#other flag options, intervals (flagged with minor, major, etc)

#get options from above, then determine what to display 
#should be easy, just check what it contains and use a switch to match it
class Results

  def initialize()
    @scales = {
      "happy" => ["Major(Ionian)", "Lydian"],
      "sad" => ["Minor(Aeolian)", "Melodic Minor", "Harmonic Minor", "Phrygian"],
      "dissonant" => ["Locrian", "Super Locrian", "Chromatic"],
      "other" => ["Dorian", "Mixolydian", "Whole Tone", "Hirajoshi"]
    }

    @chords = {
      "happy" => ["Major Triad"],
      "sad" => ["Minor Triad"],
      "dissonant" => ["Diminished, Augmented"],
      "other" => ["Power chords", "sus2", "sus4", "7ths and beyond", "Inversions"]
   }
    @intervals = {
      "happy" => ["Major 2nd", "Major 3rd", "Major 6th", "Major 7th"],
      "sad" => ["Minor 2nd", "Minor 3rd", "Minor 6th", "Minor 7th"],
      "dissonant" => "[Dimninished, Augmented]",
      "other" => ["Perfect 1st", "Perfect 4th", "Perfect 5th", "Perfect 8th"]
    }
  end

  def display_results()

  end
  #give descriptions of each match, how to formulate it
  def evaluate()
    #puts($input_array)
    #fetch the emotion and concept used from the class above
    puts($concepts_found)
    puts($emotions_found)
  end
  
end

rs = Results.new()
rs.evaluate()