import Foundation

var roomCount = 0
repeat {
    print("How many rooms would you like? (enter 5 or more)")
    guard let input = readLine(), let count = Int(input) else {
        print("Please enter a valid number.")
        continue
    }
    if count < 5 {
        print("Too few rooms! Please enter 5 or more.")
    }
    roomCount = count
} while roomCount < 5
            
let game = GameViewModel(roomCount: roomCount)
game.start()
