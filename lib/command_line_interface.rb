class CommandLineInterface
    PASTEL = Pastel.new
    PROMPT = TTY::Prompt.new

    def logo
        logo_img = <<-LOGO

        `  `  `  `` ``  `  `  `  `` `` ``  `  `  `  `` ``  `  `  `  `` `` ``
        `  `` `` ``  `  ``````` `` ````````````````````` ````````````  `  `  `  
        `` `` `` ```.``````  ````````..-::/+o++/:--..``````````...--` ``  `  `  
        `  `  `-:-.``````    ````..-::+oys+/:--..``````````...-:--- `` `` ``
        `` `` ``.+o.```````   `````..-:/+oys+/:--..```````````..-:-:/.  `  `  
        `` `` ``/s/.```````   `````..-:/+oys+/:--..```````````..----o/  `  `  
        `  ` `os-.```````   ````...-:/+oyso/:--..```````````...-:-+o`` `` ``
        `` `` `-oo.````````   ````...-:/+oyso/:--..```````````...-:-/o- `  `  
        `` ` /s/.```````    ````..--:/+oyso/::-...```````````..----o+       
        `  ``os-.```````    ````..--:/+oyso/::-...```````````...-:.oo` `` ``
        `` `` -so.````````    ````..--:/+oyso/::-...```````````...-:./o-`  `  
        `  `/s/.````````   `````..--:/+oyso+/:-...```````````...----o/ `` ``
        `  `os..````````   `````..--:/+oyyo+/:--..````````````..--:.oo``` ``
        `` ``.so.````````    `````..--:/+oyyo+/:--..````````````...-:.+s-  `  
        `  /s/.````````    `````..--:/+oyyo+/:--..````````````...-:-:s/``  `
        `  oy.`````````    `````..--:/+oyyo+/:--..````````````...--:.ss`` ``
        `` `.yo``````````    `````..--:/+oyyo+/:--...````````````...-:.+s. `  
        ` /s:``````````    `````..--:/+oyyo+/:--...````````````...-:-:s/` ``
        ` sy.````````..........-----:/+oyyo+/:------..............---.ss` ``
        `` `+o.----:::::::://///////////+oyyo+/////////////::::::::---:.++``  
        ``///++++++++++++ooooo++++++syyyyyyyyo+++++ooooooo+++++++++++///` ``
        ` -//////////////////////////+oossssso///://://://::/::/::/:///:/-`  
        `` `` `` ``  `  `  `` `` ``  ` ````````` ``  `  `  `  `` `` ``  `  `  
        `  `  `` `` ``  `  `  `  `` `` ``  `  `  `` `` ``  `  `  `  `` `` ``
        LOGO
        puts logo_img
    end

    def greeting
        puts "Welcome to The Riddle Book"
    end
    
    def see_all_user_riddles
        @show_riddles_prompt_choice = PROMPT.select(PASTEL.red("Here are your riddles:"), user_riddles, require: true)
        context_and_answer_of_riddles
    end
    
    def make_a_new_riddle
        puts "What is the name/title for your new riddle?"
        title = user_input
        puts "What is the context of your new riddle?"
        context = user_input
        puts "What is the answer to your new riddle"
        answer = user_input
        new_riddle = Riddle.create(title: title, context: context, answer: answer)
        user = User.find_by name: @@returning_player_username
        new_riddlebook = Riddlebook.create(user_id: user.id, riddle_id: new_riddle.id)
        menu
    end

    def new_or_returning_user_menu
        new_or_returning_user = returning_player_menu
        case new_or_returning_user
        when "New"
            make_new_user
            new_or_returning_user_menu
        when "Returning"
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
                second_prompt_choice = prompt.select(PASTEL.red("Here are this users riddles:"), other_user_riddles(prompt_choice), require: true)
                end
                if second_prompt_choice == book.riddle.title
                    puts "What would be the answer to this riddle?"
                    puts "*" * 100
                    puts "#{book.riddle.context}"
                    puts "*" * 100
                    user_riddle_answer = user_input
                    if user_riddle_answer == book.riddle.answer
                        puts "*" * 100
                        puts "Correct!"
                        puts "*" * 100
                        menu
                    else
                        puts "*" * 100
                        puts "Incorrect"
                        puts "*" * 100
                        menu
                    end
                    break
            end
        end
    end

    def exit_app
        puts "*" * 100
        puts "Thank you for using this application"
        puts "*" * 100
        exit
    end
    
    def menu
        puts "Welcome back, #{@@returning_player_username}"
        @menu_prompt_choice = PROMPT.select(PASTEL.red("What would you like to do?"), require: true) do |menu|
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


#===========================================================================================
    private 
#===========================================================================================



                            #New User Helper Methods
#===========================================================================================
def make_new_user #helper
    puts "*" * 100
    puts "Welcome new Player"
    puts "Please input a new Username:"
    @new_player_username = user_input
    if User.exists?(name: @new_player_username)
        puts "Username Already Taken"
        make_new_user
    else
        create_user_in_new_player
    end
end

def create_user_in_new_player #helper
    puts "Creating user..."
        new_user = User.create(name: @new_player_username)
        puts "User created!"
        new_user.save
        new_riddle = Riddle.create
        puts "Now you must make a riddle so that we may remember you."
        puts "What is the title of your riddle"
        new_riddle.title = user_input
        puts "Great! Now what do you want your riddle to be?"
        new_riddle.context = user_input
        puts "You're doing great! Lastly, what do you want the answer to your riddle to be?"
        new_riddle.answer = user_input
        puts "Wonderful, let's patch everything up and get you started..."
        new_riddle.save
        new_riddlebook = Riddlebook.create
        new_riddlebook.user = new_user
        new_riddlebook.riddle = new_riddle
        new_riddlebook.save
end
    
#===========================================================================================



                            #Login Riddle Helper Methods
#===========================================================================================
def first_riddle_successful_login #helper
    puts "*" * 100
    puts "All Good. Logging you in."
    puts "*" * 100
end

def first_riddle_incorrect_login #helper
    puts "*" * 100
    puts "Wrong answer"
    puts "*" * 100
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
#===========================================================================================



                            #Returning User Helper Methods
#===========================================================================================
def welcome_back_message #helper
    puts "*" * 100
    puts "Welcome Back"
    puts "Please Input your Username"
    puts "*" * 100
end

def returning_player_riddle_checker #helper
    Riddlebook.all.find_each do |book|
        if @@returning_player_username == book.user.name
            puts "*" * 100
            puts "Hello, #{book.user.name}"
            puts "*" * 100
            @user_found = true
            puts "Please input your riddle answer."
            puts "*" * 100
            puts "Riddle Title: #{book.riddle.title}"
            puts "*" * 100
            puts "Riddle: #{book.riddle.context}"
            puts "*" * 100
            returning_player_riddle = user_input
            first_riddle_check(returning_player_riddle)
            break
        end
    end
end

def returning_player_user_not_found #helper
    puts "*" * 100
    puts "User Not Found"
    puts "*" * 100
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
#===========================================================================================



                            #See User Riddles Helper Methods
#===========================================================================================
def context_and_answer_of_riddles #helper
    Riddlebook.all.find_each do |book|
        if book.riddle.title == @show_riddles_prompt_choice
            puts "*" * 100
            puts "Context of Riddle: #{book.riddle.context}"
            puts "*" * 100
            puts "Answer to Riddle: #{book.riddle.answer}"
            puts "*" * 100
            menu
        end
    end
end  
#===========================================================================================



                            #Edit User Riddles Helper Methods
#===========================================================================================
def case_for_edit_riddle_title #helper
    puts "*" * 100
    puts "What do you want to change your title to?"
    puts "*" * 100
    @title_change = user_input
end

def case_for_edit_riddle_context #helper
    puts "*" * 100
    puts "What do you want to change your context to?"
    puts "*" * 100
    @context_change = user_input
end

def case_for_edit_riddle_answer #helper
    puts "*" * 100
    puts "What do you want to change your answer to"
    puts "*" * 100
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
                menu
            when 'Context'
                case_for_edit_riddle_context
                book.riddle.context = @context_change
                book.riddle.save
                menu
            when 'Answer'
                case_for_edit_riddle_answer
                book.riddle.answer = @answer_change
                book.riddle.save
                menu
            end
        end
    end
end
#===========================================================================================



                        #Delete User Riddles Helper Methods
#===========================================================================================
def error_for_no_riddles_that_can_be_deleted #helper
    puts "*" * 100
    puts "You do not have any riddles you can delete"
    puts "*" * 100
    menu
end

def delete_riddle_that_user_chooses #helper
    Riddlebook.all.find_each do |book|
        if book.riddle.title == @delete_riddle_prompt_choice
            book.destroy
            puts "*" * 100
            puts "#{book.riddle.title} deleted"
            puts "*" * 100
            menu
        end
    end
end
#===========================================================================================



                        #See OTHER Users Riddles Helper Methods
#===========================================================================================
def other_user_riddles(user) #helper
    arr = []
    Riddlebook.all.find_each do |book|
        if book.user.name == user
            arr << book.riddle.title
        end
    end
    arr 
end
#===========================================================================================



                            #Main Menu Helper Methods
#===========================================================================================
def case_for_main_menu #helper
    case @menu_prompt_choice
    when 'See My Riddles'
        see_all_user_riddles
    when 'Make A New Riddle'
        make_a_new_riddle
    when 'Edit My Riddles'
        edit_user_riddle
    when 'Delete My Riddles'
        delete_user_riddle
    when 'Answer Other Riddles'
        riddles_for_all_other_users
    when 'Exit Application'
        exit_app
    end
end
#===========================================================================================


                            #Misc. Helper Methods
#===========================================================================================
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
#===========================================================================================
end