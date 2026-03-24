import Foundation

extension GameViewModel {
    
    func handleFight() {
        guard let monster = player.currentRoom.monster else {
            view.showMessage("There is no monster here.")
            return
        }
        
        guard player.hasSword else {
            view.showMessage("You need a sword to fight!")
            return
        }
        
        view.showMessage("You fight the \(monster.name)!")
        resolveMonsterEncounter(didRespond: true, isFighting: true)
    }
    
    func handleMonsterEncounter() {
        guard player.currentRoom.monster != nil else { return }
        
        view.showMessage("You have 5 seconds to enter a command!")
        
        let responded = waitForInputWithTimeout(seconds: 5)
        resolveMonsterEncounter(didRespond: responded, isFighting: false)
    }
    
    private func waitForInputWithTimeout(seconds: Double) -> Bool {
        var input: String? = nil
        let lock = NSLock()
        
        let thread = Thread {
            let result = readLine()
            lock.lock()
            input = result
            lock.unlock()
        }
        thread.start()
        
        let deadline = Date().addingTimeInterval(seconds)
        while Date() < deadline {
            Thread.sleep(forTimeInterval: 0.1)
            lock.lock()
            let hasInput = input != nil
            lock.unlock()
            if hasInput { return true }
        }
        return false
    }
    
    func resolveMonsterEncounter(didRespond: Bool, isFighting: Bool) {
        guard let monster = player.currentRoom.monster else { return }
        
        if !didRespond {
            // no response - lose health and go back
            applyMonsterDamage()
            view.showMessage("The \(monster.name) attacks you!")
            retreatToPreviousRoom()
            return
        }
        
        // responded - 1/3 chance each outcome
        let outcome = Int.random(in: 0...2)
        
        switch outcome {
        case 0:
            // lose health and retreat
            applyMonsterDamage()
            view.showMessage("The \(monster.name) overpowers you!")
            retreatToPreviousRoom()
        case 1:
            // success but lose health
            applyMonsterDamage()
            if isFighting {
                player.currentRoom.monster = nil
                view.showMessage("You defeated the \(monster.name) but got wounded!")
            } else {
                view.showMessage("You escaped but got wounded!")
            }
        case 2:
            // full success
            if isFighting {
                player.currentRoom.monster = nil
                view.showMessage("You defeated the \(monster.name)!")
            } else {
                view.showMessage("You escaped unharmed!")
            }
        default:
            break
        }
        
        checkHealth()
    }
    
    private func applyMonsterDamage() {
        let damage = max(1, player.health / 10)
        player.health -= damage
        view.showMessage("You lost \(damage) health. Health: \(player.health).")
    }
    
    private func retreatToPreviousRoom() {
        if let previousRoom = player.previousRoom {
            player.currentRoom = previousRoom
        }
        describeCurrentRoom()
    }
}
