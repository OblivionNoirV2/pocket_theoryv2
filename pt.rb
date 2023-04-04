require 'optparse'

class InputGathering
  attr_reader :emotion_used, :concept_used
  
  def initialize()
    #use other to display less common modes that don't fit a particular theme, like hirajoshi or dorian
    @emotions_array = [
      "najor", "minor", "dissonant", "other"
    ]
    @concept_array = [
      "chords", "scales", "intervals"
    ]

  end 
  def parse_keywords()

    @parser = OptionParser.new do |opts|
      opts.banner = "Usage: pt.rb [options]"

      #displays when run with --help flag, or nothing
      opts.on("-m, a, b, c", String, "Add arguments like -m scales/chords/intervals[major/minor/dissonant/other] \nand any additional arguments seperated by a comma(no space between)") do |keywords_str|
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
    puts("Add arguments like -m scales/chords/intervals[major/minor/dissonant/other] \nand any additional arguments seperated by a comma(no space between)")
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
      "major" => ["Major(Ionian): A simple, happy sounding scale.\n
        Formula: whole, whole, half, whole, whole, whole, half
        Example: C D E F G A B", 
        "\nLydian: A happy sounding scale that is similar to major, 
        but with a raised 4th that can give it a unique, mystical quality.\n
        Formula: whole, whole, whole, half, whole, whole, half
        Example: C D E F# G A B"],
      "minor" => ["\nMinor(Aeolian): A scale that tends to sound sad and dark. Very versatile.\n
        Formula: whole, half, whole, whole, half, whole
        Example: C D D# F G G# A#", 
        "\nMelodic Minor: A slightly brighter minor scale with the unique quality 
        of sometimes having a different formula ascending and descending.
        The choice is up to you.\n
        Formula, ascending: whole, half, whole, whole, whole, whole
        Formula, descending(same as Aeolian): whole, half, whole, whole, half, whole
        Example: C D D# F G A B / A# G# G F D# D C", "\nHarmonic Minor: The Aeolian scale with a raised 7th, 
        which creates a slight sense of darkness and unease. Very Classical sound.\n
        Formula: whole, half, whole, whole, half, whole + half
        Example: C D D# F G G# B", "\nPhrygian: Not to be confused with the Phrygian Dominant. 
        Has a very dark, epic quality to it.\n
        Formula: half, whole, whole, whole, half, whole
        Example: C C# D# F G G# A#"],
      "dissonant" => ["\nLocrian: A tense, very dark scale that can sound unstable or scary.\n
        Formula: half, whole, whole, half, whole, whole
        Example: C C# D# F F# G# A#", "\nSuper Locrian(Altered Scale): A more extreme version of Locrian. Very tense and unstable.\n
        Formula: half, whole, half, whole, whole, whole
        Example: C C# D# E F# G# A#", "\nChromatic: The opposite of a scale, pretty much. Any order of notes. 
        Usually extremely dissonant and unpleasant, more often used in unison with an existing scale."],
      "other" => ["\nDorian: A unique, hard to describe scale that is often said to sound medieval and folk-ish.\n 
        Formula: whole, half, whole, whole, whole, half
        Example: C D D# F G A A#", "\nMixolydian: The Ionian scale with a flattened 7th, 
        and a very common scale in blues and jazz.\n
        Formula: whole, whole, half, whole, whole, half
        Example: C D E F G A A#", "\nWhole Tone: A unique, dreamy, etherial sounding scale with 6 notes instead of 7.\n
        Formula: whole, whole, whole, whole, whole
        Example: C D E F# G# A#", "\nHirajoshi: A 5 note scale that sounds very orential or Japanese.\n
        Formula: whole, half, whole + whole, half
        Example: C D D# G G#"]
    }

    @chords = {
      "major" => ["Major Triad"],
      "minor" => ["Minor Triad"],
      "dissonant" => ["Diminished", "Augmented"],
      "other" => ["Power chords", "sus2", "sus4", "7ths and beyond", "Inversions"]
   }
    @intervals = {
      "major" => ["Major 2nd", "Major 3rd", "Major 6th", "Major 7th"],
      "minor" => ["Minor 2nd", "Minor 3rd", "Minor 6th", "Minor 7th"],
      "dissonant" => ["Diminished", "Augmented"],
      "other" => ["Perfect 1st", "Perfect 4th", "Perfect 5th", "Perfect 8th"]
    }
  end
  #give descriptions of each match, how to formulate it
  def evaluate()
    #puts($input_array)
    #fetch the emotion and concept used from the class above
    ie = InputGathering.new()
    case $concept_used
      when "scales"
        @scales[$emotion_used].each { |scale| puts scale }
        puts("\nNote that 'scale' and 'mode' are ambiguous in this program for the sake of simplicity.")
      when "chords"
        @chords[$emotion_used].each { |chord| puts chord }
      when "intervals"
        @intervals[$emotion_used].each { |interval| puts interval }
    end 

  end
end

rs = Results.new()
rs.evaluate()