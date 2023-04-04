require 'optparse'

class InputGathering
  attr_reader :emotion_used, :concept_used
  
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
        $emotion_used = e
        break
      end
    end

    @concept_array.each do |c|
      if keyword.include?(c)
        concept_found = true
        $concept_used = c
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
      "dissonant" => ["Diminished", "Augmented"],
      "other" => ["Power chords", "sus2", "sus4", "7ths and beyond", "Inversions"]
   }
    @intervals = {
      "happy" => ["Major 2nd", "Major 3rd", "Major 6th", "Major 7th"],
      "sad" => ["Minor 2nd", "Minor 3rd", "Minor 6th", "Minor 7th"],
      "dissonant" => ["Diminished", "Augmented"],
      "other" => ["Perfect 1st", "Perfect 4th", "Perfect 5th", "Perfect 8th"]
    }
  end
  #give descriptions of each match, how to formulate it
  def evaluate()
    #puts($input_array)
    #fetch the emotion and concept used from the class above
    ie = InputGathering.new()
    #puts $emotion_used
    #puts $concept_used

    case $concept_used
      when "scales"
        @scales[$emotion_used].each { |scale| puts scale }
      when "chords"
        @chords[$emotion_used].each { |chord| puts chord }
      when "intervals"
        @intervals[$emotion_used].each { |interval| puts interval }
    end  
  end
end

rs = Results.new()
rs.evaluate()