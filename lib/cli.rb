class Cli

    attr_reader :taco

    def initialize
        Ingredient.load
        welcome
    end

    def welcome
        clear
        welcome_banner
        prompt = "Welcome to Taco Town! Your best source for spectacular and creative tacos recipes!\n\nPlease choose an option:\n".bold + "1. Create your own Taco\n2. Random Taco\n3. Saved Tacos\n4. Leave Taco Town\n\n"
        puts prompt
        input = welcome_input_loop(prompt)
        if input == 1
            @taco = Taco.new
            create_taco
        elsif input == 2
            @taco = Taco.random
            taco_save?
        elsif input == 3
            saved_tacos
        elsif input == 4
            clear
            goodbye_banner
            sleep 2
            clear
        end
    end

    def welcome_input_loop(prompt)
        input = get_int
        until input && input < 5 && input > 0
            invalid_input
            clear
            puts prompt
            input = get_int
        end
        input
    end

    def create_taco
        input = create_taco_input
        if input == Ingredient.types.count + 1
            welcome
        else
            choose_ingredient(Ingredient.types[input-1])
        end
    end
    
    def create_taco_prompt
        clear
        puts "Please choose an ingredient type:".bold
        Ingredient.types.each_with_index {|type, index| puts "#{index + 1}. #{type.split("_").map{|word| word.capitalize}.join(" ")}"}
        puts "#{Ingredient.types.count + 1}. Main Menu\n\n"
    end

    def create_taco_input_loop
        input = get_int
        until input && input > 0 && input <= Ingredient.types.count + 1
            invalid_input
            create_taco_prompt
            input = get_int
        end
        input
    end

    def create_taco_input
        create_taco_prompt
        input = create_taco_input_loop
        until !@taco.has_type?(Ingredient.types[input-1])
            puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\nYour Taco already has an ingredient of this type!"
            sleep 2
            create_taco_prompt
            input = create_taco_input_loop
        end
        input
    end

    def choose_ingredient(type)
        matching = Ingredient.find_by_type(type)
        input = choose_ingredient_input(matching)
        display_ingredient(matching[input-1])
    end

    def choose_ingredient_prompt(matching)
        clear
        puts "Please select an ingredient:".bold 
        matching.each_with_index{|ingredient, index| puts "#{index + 1}. #{ingredient.name.capitalize}"}
        puts 
    end

    def choose_ingredient_input(matching)
        choose_ingredient_prompt(matching)
        input = get_int
        until input && input > 0 && input <= matching.count
            invalid_input
            choose_ingredient_prompt(matching)
            input = get_int
        end
        input
    end

    def display_ingredient(ingredient)
        input = display_ingredient_input(ingredient)
        if input == "n"
            choose_ingredient(ingredient.type)
        elsif input == "y"
            @taco.add_ingredient(ingredient)
            if @taco.full?
                taco_save?
            else
                create_taco
            end
        end
    end

    def display_ingredient_prompt(ingredient)
        clear
        puts ingredient.recipe 
        puts "\nAdd Ingredient? (y/n)"
    end

    def display_ingredient_input(ingredient)
        display_ingredient_prompt(ingredient)
        input = gets.chomp.downcase
        until input.size == 1 && (input == "y" || input == "n")
            invalid_input
            display_ingredient_prompt(ingredient)
            input = gets.chomp.downcase
        end
        input
    end

    def taco_save?
        taco_save_prompt
        input = taco_save_input
        if input == "n"
            welcome
        elsif input == "y"
            @taco.save
            puts "Your taco has been saved!"
            sleep 2
            welcome
        end
    end

    def taco_save_prompt
        clear
        puts "Here is your Taco:\n\n".bold
        @taco.ingredients.each {|ingredient| puts "#{ingredient.type.split("_").map{|word| word.capitalize}.join(" ")}: ".bold + "#{ingredient.name.capitalize}"}
        puts "\nWould you like to save this taco? (y/n)".bold
    end

    def taco_save_input
        input = gets.chomp
        until input.size == 1 && (input == "y" || input == "n")
            invalid_input
            taco_save_prompt
            input = gets.chomp
        end
        input
    end

    def saved_tacos
        if Taco.all.count == 0
            puts "You have no saved tacos."
            sleep 2
            welcome
        else
            Taco.all.each_with_index do |taco, index|
                saved_tacos_prompt(index)
                if  !saved_tacos_input(index)
                    break
                end
            end
            welcome
        end
    end

    def saved_tacos_prompt(counter)
        clear
        puts "Showing taco #{counter+1} out of #{Taco.all.count}".bold
        Taco.all[counter].recipe.each{|type, name| puts "#{type.split("_").map{|word| word.capitalize}.join(" ")}: ".bold + "#{name.capitalize}"}
        puts "\n\nn for next taco, i for ingredient recipes, m for main menu"
    end

    def saved_taco_ingredients(index)
        clear
        Taco.all[index].ingredients.each do |ingredient| 
            saved_taco_ingredients_prompt(ingredient, Taco.all[index].recipe)
            if !saved_taco_ingredients_input(ingredient, Taco.all[index].recipe)
                break
                welcome
            end
        end
    end

    def saved_taco_ingredients_prompt(ingredient, recipe)
        clear
        recipe.each{|type, name| puts "#{type.split("_").map{|word| word.capitalize}.join(" ")}: ".bold + "#{name.capitalize}"}
        puts "\n\n\n#{ingredient.recipe}\n\n"
        puts "n for next ingredient, m for main main menu"
    end

    def saved_taco_ingredients_input(ingredient, recipe)
        input = gets.chomp.downcase
        until input == "n" || input == "m"
            invalid_input
            clear
            saved_taco_ingredients_prompt(ingredient, recipe)
        end
        if input == "n"
            return true
        elsif input == "m"
            return false
        end
    end

    def saved_tacos_input(counter)
        input = gets.chomp.downcase
        until input == "n" || input == "m" || input == "i"
            invalid_input
            saved_tacos_prompt(counter)
            input = gets.chomp
        end
        if input == "i"
            saved_taco_ingredients(counter)
        elsif input == "m" || (input == "n" && counter + 1 == Taco.all.count)
            return false
        elsif input == "n"
            return true
        end
    end

    def taco_full?
        @taco.ingredients.count == 5
    end

    def get_int
        input = Integer(gets) rescue false
    end

    def clear
        puts "\e[2J\e[f"
    end

    def clear
        puts "\e[2J\e[f"
    end

    def invalid_input
        puts
        puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        puts
        puts "Invalid input! Please try again"
        sleep 2
        clear
    end

    def welcome_banner
        file = File.open("./lib/taco_town.txt")
        puts file.read
    end

    def goodbye_banner
        file = File.open("./lib/goodbye.txt")
        puts file.read
    end

end