puts "Welcome to botlang, a command line client for using botlang."

print "botlang(main) >> "

input = gets.chomp.split(" ")

size_limit = input.size.to_i

cmd = {
  "search"   =>     "find_word",
  "retrieve" => "retrieve_word",
  "discuss"  =>      "run_aiml",
}

number = 0
#
#puts size_limit

size_limit.times do

  def find_word
#    puts "Hello World"

    number = 0

    # A list of all possible answers.
    possible_answers = File.readlines("answers/possible_answers.txt", chomp: true)

    # Display list of all possible answers.
    print possible_answers

    # Asks you to pick your answer.
    print " >> "
    pick_answer = gets.chomp.strip.to_i

    # Sets correct answer to your answer.
    correct_answer = possible_answers[pick_answer].strip

    puts " "

    # Sets the loop limit to the size of the array.
    size_limit = possible_answers.size.to_i

    # If loop reaches the correct answer before loop limit, generates auto answer. Otherwise continue loop until end.
    size_limit.times do
      answer = possible_answers[number]

      if answer == correct_answer
        print "Correct: "; puts answer

        # Generates an automatic answer from learned answer.
        open("results/#{correct_answer.tr ' ', '_'}.rb", "w") { |f|
          f.puts "puts '#{answer}' "
        }
      else
        print "Incorrect: "; puts answer
      end

      number = number + 1
    end
  end

  def retrieve_word
#    puts "Hello World"

    print ">> "; find_script = gets.chomp

    system("ruby results/#{find_script}")
  end

  def improvise
#    puts "Hello World"

    number = File.read("data/number/input.txt").strip.to_i

    # The dialogue script in question.
    dialogue_script = File.readlines("dialogue/dialogue_script.txt")

    # Size limit based on the size of the dialogue script.
    size_limit = dialogue_script.size.to_i

    # random value that rand_value will use.
    rIncrement = number * size_limit

    # Split dialogue input
    dialogue_section = dialogue_script[number]

    split_section = dialogue_section.split(" ")
 
    title = split_section[0]

    # random value is equal to the size of the number value * size limit, mod the size_limit.
    rand_value = rand(rIncrement) % size_limit

    # Determines the AIML dialogue.
    aiml_script = dialogue_script[number].strip

    # Determines the file name.
    file_name = "#{dialogue_script[number].tr ' ', '_'}"

    # Create the AIML file.
    open("chatbots/#{file_name}.aiml", "w") { |f|
      f.puts "<aiml>
  <category>
    <pattern>#{title}</pattern>
    <template>#{aiml_script}</template>
  </category>
</aiml>"
    }

    open("data/number/input.txt", "w") { |f|
      f.puts number = number + 1
    }
  end

  def run_aiml
#    puts "Hello World"

    require 'programr'

    bot_name = "BIANCA"
    usr_name = "SARAH"

    brains = Dir.glob("chatbots/*")

    robot = ProgramR::Facade.new
    robot.learn(brains)

    system("clear")

    puts " Welcome to Bianca. This is the terminal for my chatbot. She can perform ciphers, write poetry, study pictures, learn new words, and how to classify them."

    while true
      print "#{usr_name } >> "
      s = STDIN.gets.chomp

      reaction = robot.get_reaction(s)

      if reaction == ""
        # reaction.play("en")

        STDOUT.puts "#{bot_name} << I have no answer for that."
      elsif reaction ==   "see you later"; exit
      else
        # reaction.play("en")

        STDOUT.puts "#{bot_name} << #{reaction}"
      end
    end
  end

  task = cmd[input[number]].to_s

  if    task ==     "find_word"; find_word
  elsif task == "retrieve_word"; retrieve_word
  elsif task ==      "run_aiml"; run_aiml
  end

  number = number + 1

  sleep(0.5)
end
