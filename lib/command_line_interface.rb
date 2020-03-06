class CommandLineInterface
    PASTEL = Pastel.new
    PROMPT = TTY::Prompt.new
    DOOM_FONT = TTY::Font.new(:doom)
    STANDARD_FONT = TTY::Font.new(:standard)
    STRAIGHT_FONT = TTY::Font.new(:straight)

    def logo
        logo_img = <<-LOGO
        ```  ``  ```  ``  ```  ``   ``  ``   ``  ``   ``  ```  ``  ```  ``  ```  ``   ``  ``   ``  ``   ``
        ``   ``  ``   ``  ``   ``  ```  ``  ```  ``  ```  ``   ``  ``   ``  ``   ``  ```  ``  ```  ``  ```  
          ``   ``  ```  ``  ``` `` ``   ```````````..`` ``  ``````````````````````````````  ``   ``  ``   ``
        ``   ``  ``   `` ```````````    ``````...--::/++oo+++/::--...```````````````...--:.`  ```  ``  ```  
          ``   ``  ``.....``````````    ``````...--::/++syso+/::--...```````````````....-::-...` ``  ```  ` 
          ```  ``  ``::/-.``````````    ``````...--::/++syso+/::--...```````````````....--:--:-` ``  ``   ``
        ``   ``  `` `+s/..`````````     ``````...--::/+osyso+/::--...````````````````...--:--+/.`  ``  ```  
          ```  ``  `ooy-.``````````     ``````...--::/+osyso+//:--....```````````````...--:--/o/```  ``   ``
        ``   ``  ``-oso..``````````     ``````...--::/+osyso+//:---...```````````````....--:-:so-  ``  ```  
          ```  ``  /os/..``````````     ``````...--::/+osyso+//:---...```````````````....--:--oo/``  ``   ``
        ``   ``  ``ooy-.```````````    ```````...--::/+osyyo+//:---...````````````````...--:-.+oo  ``  ```  
          ```  `` .oso..```````````    ```````...--::/+osyyo+//:---...````````````````...--::.:so-`  ``   ``
        ``  ```  `/oy/..``````````     ```````...--::/+osyyo+//:---...````````````````....--:..so/ ``  ```  
          ```  `` ooy-.```````````     ``````....--::/+osyyo+//::--...````````````````....--:-.+oo`  ```  ``
          ``   ```sss..```````````     ``````....--::/+osyyo+//::--...`````````````````...--:-.:os.  ``   ``
        ``   ``  :os/..```````````     ``````....--::/+osyyo++/::--....````````````````....--:..so:``  ```  
          ```  ``ooy...```````````     ``````...---://+osyyo++/::--....````````````````....--:..ooo  ``   ``
        ``   `` `sss..```````````     ```````...---://+osyyo++/::--....````````````````....--:-./os.`  ```  
          ```  `:sy/..```````````     ```````...---://+osyyo++/::--....`````````````````...---:.-so: ``   ``
        ``   `` +sy...```````````     ```````...--:://+oshyo++/::--....`````````````````....--:..soo`  ```  
          ```  `sss..````````````     ```````...--:://+oshyso+/::--....`````````````````....--:-.+oy```   ``
        ``   ``-sy/`.````````````     ```````...--:://+oshyso+/::---...`````````````````....--::.-ss:  ```  
          ```  +sy.`.```````````      ```````...--:://+oshyso+/::---...`````````````````.....--:..so+``   ``
           `  `yss``````````````      ```````...--:://+oshyso+/::---....`````````````````....--:-.+oy``   ``
        ``   `-yy/``````````````     ```````....--:://+oshyso+/::---....`````````````````....--::.:sy- ```  
          ``  /sy.`.````````````     ```````....--:://+oshyso+//:---....`````````````````....---:..ys+`   ``
        ``   `sss```````````````     ```````....--:://+oshyso+//:---....`````````````````.....--:-.ooy ```  
          ```.yy/`````````....-----::::::::::::::::::/+oshyso+/::::::::::::::::::--------.....--::./sy-   ``
        ``   `+y..-----::::::://///////////////////////+oyyo//////////////////////////:::::::----:..y+````  
          ````/+-::::::::::::::::::////////////////+ssyhhhhhhyso+////////////////::::::::::::::::::-+/.   ``
        ``  `:/:/+ossssssssssssssssssssssssssssssssyhyyssssyyyhyssssssssssssssssssssssssssssssssso+///:```  
          ```:////////::///:///:://::://:://::://::/+osssssysso+::::::::::::::::::::::::::::::::///////`  ``
           `   ``   `   ``   `   ``` ```   `   `   ``` ````` ``  ``   `   ``  ``   ``` ```   `   `   ``` ```
        ``  ```  ``   ``  ``   ``  ``   ``  ```  ``  ```  ``  ```  ``   ``  ``   ``  ``   ``  ```  ``  ```  
          ``   ``  ```  ``   ``  ``   ``  ``   ``  ``   ``  ``   ``  ```  ``   ``  ``   ``  ``   ``  ``   ``
        LOGO
        puts logo_img
    end

    def greeting
        puts PASTEL.magenta(DOOM_FONT.write("===Welcome==="))
        puts PASTEL.red(DOOM_FONT.write("To The Riddlebook"))
    end
    
    def see_all_user_riddles
        @show_riddles_prompt_choice = PROMPT.select(PASTEL.red("Here are your riddles:"), user_riddles, require: true)
        context_and_answer_of_riddles
    end
    
    def make_a_new_riddle
        puts PASTEL.cyan("What is the name/titlefor your new riddle?")
        title = user_input
        puts PASTEL.cyan("What is the context of your new riddle?")
        context = user_input
        puts PASTEL.cyan("What is the answer to your new riddle")
        answer = user_input
        new_riddle = Riddle.create(title: title, context: context, answer: answer)
        user = User.find_by name: @@returning_player_username
        new_riddlebook = Riddlebook.create(user_id: user.id, riddle_id: new_riddle.id)
        system "clear"
        box = TTY::Box.success("New Riddle Created")
        puts box
        menu
    end

    def new_or_returning_user_menu
        new_or_returning_user = returning_player_menu
        case new_or_returning_user
        when "New"
            system "clear"
            make_new_user
            new_or_returning_user_menu
        when "Returning"
            system "clear"
            returning_player
        when "Exit"
            exit_app
        end
    end
    
    def edit_user_riddle
        @list_of_user_riddles = PROMPT.select(PASTEL.red("Here are your riddles:"), user_riddles, require: true)
        choose_what_to_edit_in_riddle
    end
    
    def delete_user_riddle
        begin
        @delete_riddle_prompt_choice = PROMPT.select(PASTEL.red("Here are your riddles:"), user_riddles[1..-1])
        rescue
            error_for_no_riddles_that_can_be_deleted
        end
        delete_riddle_that_user_chooses
    end

    def riddles_for_all_other_users
        prompt_choice = PROMPT.select(PASTEL.red("Here is the list of users:"), all_users, require: true)
        Riddlebook.all.find_each do |book|
            if prompt_choice == book.user.name
                second_prompt_choice = PROMPT.select(PASTEL.red("Here are this users riddles:"), other_user_riddles(prompt_choice), require: true)
                end
                if second_prompt_choice == book.riddle.title
                    puts PASTEL.red("What would be the answer to this riddle?")
                    puts PASTEL.magenta("*") * 100
                    puts PASTEL.red("Context") + PASTEL.blue(" #{book.riddle.context}")
                    puts PASTEL.magenta("*") * 100
                    user_riddle_answer = user_input
                    if user_riddle_answer == book.riddle.answer
                        correct_box = TTY::Box.success("Correct Answer!")
                        system "clear"
                        puts correct_box
                        menu
                    else
                        incorrect_box = TTY::Box.error("Incorrect Answer!")
                        system "clear"
                        puts incorrect_box
                        menu
                    end
                    break
            end
        end
    end

    def exit_app
        system "clear"
        box = TTY::Box.frame(width: 30, height: 5, align: :center, padding: 1, style: {
                fg: :white,
                bg: :magenta,
            border: {
                type: :thick,
                #fg: :red,
                bg: :magenta,
            }
            }) do
            "Thank you for playing"
        end
        puts box
        exit
    end
    
    def menu
        puts PASTEL.blue(STRAIGHT_FONT.write("Welcome back, #{@@returning_player_username}"))
        @menu_prompt_choice = PROMPT.select(PASTEL.red(STRAIGHT_FONT.write("Choose from the following:")), require: true) do |menu|
            menu.choice 'See My Riddles'
            menu.choice 'Make A New Riddle'
            menu.choice 'Edit My Riddles'
            menu.choice 'Delete My Riddles'
            menu.choice 'Answer Other Riddles'
            menu.choice 'Exit Application'
        end
        case_for_main_menu
    end
    
    
    def run
        logo
        greeting
        new_or_returning_user_menu
        menu
    end


    #===========================================================================================#
    private 
    #===========================================================================================#



                                    #New User Helper Methods
    #===========================================================================================#
    def make_new_user #helper
        system "clear"
        puts PASTEL.magenta("*") * 100
        puts PASTEL.green("Welcome New Player\nPlease input a new username:")
        @new_player_username = user_input
        if User.exists?(name: @new_player_username)
            system "clear"
            box = TTY::Box.error("Username Already Taken")
            puts box
            make_new_user
        else
            create_user_in_new_player
        end
    end

    def create_user_in_new_player #helper
        system "clear"
        puts PASTEL.green("Creating user...")
            new_user = User.create(name: @new_player_username)
            puts PASTEL.green("User created!")
            new_user.save
            new_riddle = Riddle.create
            puts "Now you must make a riddle so that we may remember you."
            puts PASTEL.red("What is the title of your riddle")
            new_riddle.title = user_input
            puts PASTEL.red("Great! What does your riddle entail?")
            new_riddle.context = user_input
            puts PASTEL.red("You're doing great! Lastly, what do you want the answer to your riddle to be?")
            new_riddle.answer = user_input
            puts PASTEL.green("Wonderful, let's patch everything up and get you started...")
            new_riddle.save
            new_riddlebook = Riddlebook.create
            new_riddlebook.user = new_user
            new_riddlebook.riddle = new_riddle
            new_riddlebook.save
    end
    
    #===========================================================================================#



                                #Login Riddle Helper Methods
    #===========================================================================================#
    def first_riddle_successful_login #helper
        system "clear"
        box = TTY::Box.success("All Good. Logging you in....")
        puts box
    end

    def first_riddle_incorrect_login #helper
        puts PASTEL.magenta("*") * 100
        puts "Wrong answer"
        puts PASTEL.magenta("*") * 100
    end
        
    def first_riddle_check(riddle_answer) #helper
        riddle_check = false
        Riddlebook.all.find_each do |book|
            if book.riddle.answer == riddle_answer
                first_riddle_successful_login
                riddle_check = true
            end
        end
        if riddle_check == false
            first_riddle_incorrect_login
            returning_player
        end
    end
    #===========================================================================================#



                                #Returning User Helper Methods
    #===========================================================================================#
    def welcome_back_message #helper
        box = TTY::Box.success("Welcome Back.\nPlease Input your Username")
        puts box
    end

    def returning_player_riddle_checker #helper
        system "clear"
        Riddlebook.all.find_each do |book|
            if @@returning_player_username == book.user.name
                puts PASTEL.green(STRAIGHT_FONT.write("Hello, #{book.user.name}"))
                @user_found = true
                puts PASTEL.green(STRAIGHT_FONT.write("Please input your riddle answer."))
                puts PASTEL.magenta("*") * 100
                puts PASTEL.red("Riddle Title:") + PASTEL.blue(" #{book.riddle.title}")
                puts PASTEL.magenta("*") * 100
                puts PASTEL.red("Riddle:") + PASTEL.blue(" #{book.riddle.context}")
                puts PASTEL.magenta("*") * 100
                returning_player_riddle = user_input
                first_riddle_check(returning_player_riddle)
                break
            end
        end
    end

    def returning_player_user_not_found #helper
        system "clear"
        box = TTY::Box.error("User Not Found")
        puts box
    end

    def returning_player #helper
        @user_found = false
        welcome_back_message
        @@returning_player_username = user_input
        returning_player_riddle_checker
        if @user_found == false
            returning_player_user_not_found
            returning_player
        end
    end

    def returning_player_menu #helper
        PROMPT.select(PASTEL.red("Are you a new or returning player?"), %w(New Returning Exit), active_color: :bright_red, symbols: {marker: '>'}, require: true)
    end
    #===========================================================================================#



                                #See User Riddles Helper Methods
    #===========================================================================================#
    def context_and_answer_of_riddles #helper
        system "clear"
        Riddlebook.all.find_each do |book|
            if book.riddle.title == @show_riddles_prompt_choice
                puts PASTEL.magenta("*") * 100
                puts PASTEL.red("Context of Riddle:") + PASTEL.blue(" #{book.riddle.context}")
                puts PASTEL.magenta("*") * 100
                puts PASTEL.red("Answer to Riddle:") + PASTEL.blue(" #{book.riddle.answer}")
                puts PASTEL.magenta("*") * 100
                menu
            end
        end
    end  
    #===========================================================================================#



                                #Edit User Riddles Helper Methods
    #===========================================================================================#
    def case_for_edit_riddle_title #helper
        puts PASTEL.magenta("*") * 100
        puts "What do you want to change your title to?"
        puts PASTEL.magenta("*") * 100
        @title_change = user_input
    end

    def case_for_edit_riddle_context #helper
        puts PASTEL.magenta("*") * 100
        puts "What do you want to change your context to?"
        puts PASTEL.magenta("*") * 100
        @context_change = user_input
    end

    def case_for_edit_riddle_answer #helper
        puts PASTEL.magenta("*") * 100
        puts "What do you want to change your answer to"
        puts PASTEL.magenta("*") * 100
        @answer_change = user_input
    end

    def choose_what_to_edit_in_riddle #helper
        Riddlebook.all.find_each do |book|
            if book.riddle.title == @list_of_user_riddles
                @list_of_what_can_be_changed_in_riddle = PROMPT.select(PASTEL.red("Which would you like to change?"), require: true) do |menu|
                    menu.choice 'Title'
                    menu.choice 'Context'
                    menu.choice 'Answer'
                end
                case @list_of_what_can_be_changed_in_riddle
                when 'Title'
                    case_for_edit_riddle_title
                    book.riddle.title = @title_change
                    book.riddle.save
                    system "clear"
                    title_box = TTY::Box.success("Title successfully changed")
                    puts title_box
                    menu
                when 'Context'
                    case_for_edit_riddle_context
                    book.riddle.context = @context_change
                    book.riddle.save
                    system "clear"
                    context_box = TTY::Box.success("Context successfully changed")
                    puts context_box
                    menu
                when 'Answer'
                    case_for_edit_riddle_answer
                    book.riddle.answer = @answer_change
                    book.riddle.save
                    system "clear"
                    riddle_box = TTY::Box.success("Answer successfully changed")
                    puts riddle_box
                    menu
                end
            end
        end
    end
    #===========================================================================================#



                            #Delete User Riddles Helper Methods
    #===========================================================================================#
    def error_for_no_riddles_that_can_be_deleted #helper
        box = TTY::Box.error("You do not have any riddles you can delete")
        puts box
        menu
    end

    def delete_riddle_that_user_chooses #helper
        Riddlebook.all.find_each do |book|
            if book.riddle.title == @delete_riddle_prompt_choice
                book.destroy
                system "clear"
                box = TTY::Box.success("#{book.riddle.title} deleted")
                puts box
                menu
            end
        end
    end
    #===========================================================================================#



                            #See OTHER Users Riddles Helper Methods
    #===========================================================================================#
    def other_user_riddles(user) #helper
        arr = []
        Riddlebook.all.find_each do |book|
            if book.user.name == user
                arr << book.riddle.title
            end
        end
        arr 
    end
    #===========================================================================================#



                                #Main Menu Helper Methods
    #===========================================================================================#
    def case_for_main_menu #helper
        case @menu_prompt_choice
        when 'See My Riddles'
            system "clear"
            see_all_user_riddles
        when 'Make A New Riddle'
            system "clear"
            make_a_new_riddle
        when 'Edit My Riddles'
            system "clear"
            edit_user_riddle
        when 'Delete My Riddles'
            system "clear"
            delete_user_riddle
        when 'Answer Other Riddles'
            system "clear"
            riddles_for_all_other_users
        when 'Exit Application'
            exit_app
        end
    end
    #===========================================================================================#


                                    #Misc. Helper Methods
    #===========================================================================================#
    def user_riddles #helper
        arr = []
        Riddlebook.all.find_each do |book|
            if book.user.name == @@returning_player_username
                arr << book.riddle.title
            end
        end
        arr
    end

    def all_users #helper
        arr = []
        Riddlebook.all.find_each do |book|
            arr << book.user.name
        end
        arr
    end

    def user_input #helper
        gets.chomp
    end
    #===========================================================================================#
end