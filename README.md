# Crystals and Dragons 🐉

A console-based maze exploration game written in Swift.

## How to Run

1. Open `CrystalsAndDragons.xcodeproj` in Xcode
2. Build the project: `Cmd+B`
3. Run in Terminal for colored output:
```
Product → Edit Scheme → Run → Options → Console → Terminal
```
Then press `Cmd+R`

## Architecture

The project uses **MVVM** architecture:

- **Models** (`Models/`) — data structures: `Room`, `Item`, `Player`, `Maze`, `Monster`
- **ViewModel** (`ViewModel/`) — game logic split into extensions:
  - `GameViewModel.swift` — game loop and initialization
  - `GameViewModel+Movement.swift` — player movement
  - `GameViewModel+Items.swift` — item interactions
  - `GameViewModel+Combat.swift` — monster encounters
- **View** (`View/`) — `ConsoleView` handles all input/output

## Commands

| Command | Description |
|---------|-------------|
| `N` `S` `W` `E` | Move in a direction |
| `get [item]` | Pick up an item |
| `drop [item]` | Drop an item |
| `open` | Open chest (requires key) |
| `eat [item]` | Eat food to restore health |
| `fight` | Fight monster (requires sword) |

## Features

- ✅ Procedurally generated maze (DFS algorithm)
- ✅ Dark rooms — need torchlight to see
- ✅ Dropping torchlight permanently lights dark room
- ✅ Food restores health
- ✅ Monsters with 5-second response timer
- ✅ Sword enables fight command
- ✅ Gold collection
- ✅ Colored terminal output (ANSI)

## Known Limitations

- ANSI colors require Terminal.app — not visible in Xcode console
- Input typed during monster timer is not processed as a game command

## Requirements

- Xcode 15+
- macOS 13+
- Swift 5.9+
