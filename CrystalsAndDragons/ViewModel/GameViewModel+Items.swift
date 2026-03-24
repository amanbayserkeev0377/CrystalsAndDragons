extension GameViewModel {
    
    func handleGet(_ itemName: String) {
        let room = player.currentRoom
        
        guard let item = room.items.first(where: { $0.name == itemName }) else {
            view.showMessage("There is no \(itemName) here.")
            return
        }
        
        guard item.type != .chest else {
            view.showMessage("You can't pick up the chest.")
            return
        }
        
        if case .gold(let coins) = item.type {
            player.gold += coins
            room.items.removeAll { $0.name == itemName }
            view.showMessage("You picked up \(coins) coins. Total gold: \(player.gold).")
            return
        }
        
        room.items.removeAll { $0.name == itemName }
        player.pickUp(item: item)
        view.showMessage("You picked up \(itemName).")
    }
    
    func handleDrop(_ itemName: String) {
        guard player.hasItem(named: itemName) else {
            view.showMessage("You don't have \(itemName).")
            return
        }
        
        guard let item = player.inventory.first(where: { $0.name == itemName }) else { return }
        
        player.drop(item: item)
        player.currentRoom.items.append(item)
        
        // if torchlight dropped in dark room - light it permanently
        if itemName == "torchlight" && player.currentRoom.isDark {
            player.currentRoom.isLit = true
        }
        
        view.showMessage("You dropped \(itemName).")
    }
    
    func handleOpen() {
        guard player.currentRoom.items.contains(where: { $0.name == "chest" }) else {
            view.showMessage("There is no chest here.")
            return
        }
        
        guard player.hasItem(named: "key") else {
            view.showMessage("You need a key to open the chest.")
            return
        }
        
        view.showMessage("You opened the chest and found the Holy Grail! You WIN! 🏆")
        isGameOver = true
    }
    
    func handleEat(_ itemName: String) {
        guard player.hasItem(named: itemName) else {
            view.showMessage("You don't have \(itemName).")
            return
        }
        
        guard let item = player.inventory.first(where: { $0.name == itemName }),
              case .food(let restoreAmount) = item.type else {
            view.showMessage("\(itemName) is not edible.")
            return
        }
        
        player.drop(item: item)
        player.health += restoreAmount
        view.showMessage("You ate \(itemName) and restored \(restoreAmount) health. Health: \(player.health).")
    }
}
