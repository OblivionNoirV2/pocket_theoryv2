require 'optparse'

class InputGathering
  attr_reader :emotion_used, :concept_used
  
  def initialize()
    #use other to display less common modes that don't fit a particular theme, like hirajoshi or dorian
    @emotions_array = [
      "major", "minor", "dissonant", "other"
    ]
    @concept_array = [
      "chords", "scales", "intervals"
    ]

  end 
  def parse_keywords()

    @parser = OptionParser.new do |opts|
      opts.banner = "Usage: \nAdd arguments like -m scales/chords/intervals[major/minor/dissonant/other] \nand any additional arguments seperated by a comma(no space between)"

      #displays when run with --help flag, or nothing
      opts.on("-m, a, b, c", String) do |keywords_str|
        #split the string up into an array
        $keywords_array = keywords_str.split(",")
        #check for proper formatting, like something[something]
        $keywords_array.map do |keyword|
          #also check that it fits the chord/scale/interval[emotion] format
          if keyword.match?(/\A\w+\[[\w\s]+\]\z/) && are_args_included(keyword)
            return $keywords_array 
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
    $emotions_used = []
    $concepts_used = []
      #try assigning number of args to a variable, and looping for that amt?
      @emotions_array.each do |e|
        if keyword.include?(e)
          emotion_found = true
          #Note that this is seperating the emotion from the keyword, as it should
          #problem is it's only evaluating the first part of the keywords array
          puts e
          $emotions_used.push(e)
        end
      end

      @concept_array.each do |c|
        if keyword.include?(c)
          concept_found = true
          puts c
          $concepts_used.push(c)
        end
      end
      #This is true if both bools are true
      return emotion_found && concept_found
    
  end

$ig = InputGathering.new()
  def you_screwed_up()
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
      "major" => ["\nMajor Triad: The most basic major chord.\n
        Formula: root, major 3rd, perfect 5th
        Example: C E G"],
      "minor" => ["\nMinor Triad: The most basic minor chord.\n
        Formula: root, minor 3rd, perfect 5th
        Example: C D# G"],
      "dissonant" => ["\nDiminished: Any chord that usually is not dissonant, 
        with a flattened note to make it so. Tense and unstable.\n
        Example: C D# F# (a C minor with the 5th flattened)", "\nAugmented: Any chord that usually is not dissonant, 
        with a raised note to make it so. Tense and unstable.\n
        Example: C E G# (a C major with the 5th raised)"],
      "other" => ["\nPower chords: Two note chords with a neutral, but powerful sound.\n
        Formula: root, perfect 5th
        Example: C G", "\nsus2: Etherial, 'suspended' sound. 
        There is generally not much distinction between sus2 and sus4.\n
        Formula: root, second note of major scale, perfect fifth
        Example: C D G", "\nsus4: Etherial, 'suspended' sound. 
        There is generally not much distinction between sus2 and sus4.\n
        Formula: root, fourth note of major scale, perfect fifth
        Example: C F G", "\noctave: Chords containing 2 of the same note, often the root, 
        at different octaves. Simple way to create a huge, epic sound.", 
        "\n7ths and beyond: Any chord can have additional notes of the scale added in to create a larger sound. 
        To do this, skip the next note in the scale and add the one after that. 
        For example, a minor triad, C D# G,can have the C minor scale's A# added in 
        to create a C minor 7th, C D# G A#. Doing this again would create a 9th, and so on.", 
        "\nInversions: Notes in a chord do not follow a strict order. Change it up and experiment with different sounds!
        For example, C major can be played as C E G, E G C, G C E, 
        or even E E G C to create variations on the same base sound."], 
   }
    @intervals = {
      "major" => ["Major 2nd: 2 semitones", "Major 3rd: 4 semitones", "Major 6th: 9 semitones", "Major 7th: 11 semitones"],
      "minor" => ["Minor 2nd: 1 semitone", "Minor 3rd: 3 semitones", "Minor 6th: 8 semitones", "Minor 7th: 10 semitones"],
      "dissonant" => ["Aug 2nd: 3 semitones", "Aug 3rd: 5 semitones", "Aug 4th: 6 semitones", "Aug 5th: 8 semitones", 
        "Aug 6th: 10 semitones", "Aug 7th: 12 semitones", "Dim 2nd: 1 semitone", 
        "Dim 3rd: 2 semitones", "Dim 4th: 4 semitones", "Dim 5th: 6 semitones", 
        "Dim 6th: 7 semitones", "Dim 7th: 9 semitones"],
      "other" => ["Perfect 4th: 5 semitones", "Perfect 5th: 7 semitones", "Octave: 12 semitones"]
    }
  end
  #give descriptions of each match, how to formulate it
  def evaluate()
    #fetch the emotion and concept used from the class above
    ie = InputGathering.new()
    #puts($emotions_used)
    #puts($concepts_used)


    for i in $keywords_array do
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
end

rs = Results.new()
rs.evaluate()