module gameAdd::RockPaperScissors {
    use std::string::{String,utf8};
    use std::signer;
    use aptos_framework::randomness;

    // Create a struct resource with computer's choice and the result of the game
    struct GameResult has key{
        computer_choice: String,
        game_result: String
    }

    // Function to create the game and will access and modify the struct resource
    public entry fun createGame(account: &signer) acquires GameResult{
        // Create the signer of account
        let acc_signer = signer::address_of(account);
        // Check if the account has the struct resource already and thus borrow it mutably
        if(exists<GameResult>(acc_signer)){
            let result = borrow_global_mut<GameResult>(signer::address_of(account));
            result.computer_choice = utf8(b"Name Game");
            result.game_result = utf8(b"Game not yet played");
        }
        else{
            // Create a resource instance and move it to the global storage at the account address
            let result = GameResult {computer_choice: utf8(b"Name Game"), game_result: utf8(b"Game not yet played")};
            move_to(account, result);
        }
    }

    // Create the game function with randomness to ensure computer choice is random
    #[randomness]
    entry fun game(account:&signer, user_selection: String) acquires GameResult{
        // Use aptos randomness function
        let random_pick = randomness::u64_range(0, 3);
        // Signer of account
        let acc_signer = signer::address_of(account);
        // Borrow the GameResult resource for modifications
        let result = borrow_global_mut<GameResult>(acc_signer);

        // Assign the choices according to the random picks
        if(random_pick==0)
            {
                result.computer_choice = utf8(b"Rock");
            }
        else
        {
            if(random_pick==1)
                {
                    result.computer_choice = utf8(b"Paper");
                }
            else
            {
                result.computer_choice = utf8(b"Scissors");
            }
        };

        // Create computer's selection
        let computer_selection = &result.computer_choice;

        // Choosing the winner
        if (user_selection == *computer_selection) {
            result.game_result = utf8(b"Draw"); // Draw
        } else if ((user_selection == utf8(b"Rock") && *computer_selection == utf8(b"Scissors")) ||
            (user_selection == utf8(b"Paper") && *computer_selection == utf8(b"Rock")) ||
            (user_selection == utf8(b"Scissors") && *computer_selection == utf8(b"Paper"))) {
            result.game_result = utf8(b"Win"); // User wins
        } else {
            result.game_result = utf8(b"Lose"); // Computer wins
        }
    }

    // Get the result of the game
    public fun get_result(account: &signer): (String, String) acquires GameResult {
        // Signer of account
        let acc_signer = signer::address_of(account);
        // Borrow resource
        let result = borrow_global<GameResult>(acc_signer);
        (result.computer_choice, result.game_result)
    }

}