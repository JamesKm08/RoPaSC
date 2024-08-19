module gameAdd::RockPaperScissors {
    use std::string::{String,utf8};
    use std::signer;

    // Create a struct resource with computer's choice and the result of the game
    struct GameResult has key{
        computer_choice: String,
        game_result: String
    }

    // Function to create the game and will access and modify the struct resource
    public entry fun createGame(account: &signer) acquires GameResult{
        // Check if the account has the struct resource already and thus borrow it mutably
        if(exists<GameResult>(signer::address_of(account))){
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

}