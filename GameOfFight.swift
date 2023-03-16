//
//  GameOfFight .swift
//  
//
//  Created by Jean Barottin on 03/03/2023.
//

import Foundation

/*
 ******************************** Class definition ***************
 */

// different type of characters definition
enum CharacterType: String {
    case warrior = "Warrior"
    case magus = "Magus"
    case colossus = "Colossus"
    case dwarf = "Dwarf"
}

// additional features for the characters
extension CharacterType {
    var initialLifeCapital: Int {
        switch self {
        case .warrior:
            return 100
        case .magus:
            return 150
        case .colossus:
            return 150
        case .dwarf:
            return 75
        }
    }
    
    var weaponStrengh: Int {
        switch self {
        case .warrior:
            return 50
        case .magus:
            return 25
        case .colossus:
            return 25
        case .dwarf:
            return 75
        }
    }
}


// class defining the character's role, features and state
class Character {
    var characterName: String
    var type: CharacterType
    var lifeValue: Int
    static var listName: [String] = []
    var isDeadCharacter: Bool {
        get {
            if lifeValue > 0 {
                return false
            } else {
                return true
            }
        }
    }
    
    init(characterName: String,type: CharacterType) {
        self.characterName = characterName
        Character.listName.append(characterName.lowercased())
        self.type = type
        self.lifeValue = type.initialLifeCapital
    }
    
        
    // returns true if the characterName is new (indifferent for upper or lower case)
    static func isNewName(characterName:String) -> Bool {
        return !Character.listName.contains(characterName.lowercased())
    }
}

// class defining the team and the attacks history for each player
class Player {
    var playerLabel: String
    var team: [Character] = []
    var history: [RoundRecorder] = []
        
    init(playerLabel: String) {
        self.playerLabel = playerLabel
    }

    // creation of a character in the team for each player
    func createCharacter(characterName: String, type: CharacterType) {
        self.team.append(Character(characterName: characterName, type: type))
    }
    
    // creation of a recording of a round for each player
    func createRoundRecorder(soldierNumber: Int,opponentNumber: Int, healRound: Bool, opponentLifeValue: Int) {
        self.history.append(RoundRecorder(soldierNumber: soldierNumber, opponentNumber: opponentNumber, healRound: healRound, opponentLifeValue: opponentLifeValue))
    }
}

// class defining the data recorded for each round
class RoundRecorder {
    var soldierNumber: Int
    var opponentNumber: Int
    var healRound: Bool
    var opponentLifeValue: Int
    
    init(soldierNumber: Int, opponentNumber: Int, healRound: Bool, opponentLifeValue: Int) {
        self.soldierNumber = soldierNumber
        self.opponentNumber = opponentNumber
        self.healRound = healRound
        self.opponentLifeValue = opponentLifeValue
        
    }
}

// class that manages the flow of the game
class Game {
    private let playerA = Player(playerLabel: "Joueur A")
    private let playerB = Player(playerLabel: "Joueur B")
    private var currentRoundNumber = 0
    
    // game launch : teams constitution and summary display of the teams
    func startGame() {
        sayWelcome()
        createTeam(player: playerA)
        createTeam(player: playerB)
        displayTeam(player: playerA)
        displayTeam(player: playerB)
    }
    
    // fight launch winner detection and result display
    func startFight() {
        while ((!controlIfAllCharactersAreDead(player: playerA)) && (!controlIfAllCharactersAreDead(player: playerB))) {
            self.currentRoundNumber += 1
            launchRoundAttack(player: playerA)
            if controlIfAllCharactersAreDead(player: playerB) {
                break
            }
            launchRoundAttack(player: playerB)
        }
        
        if controlIfAllCharactersAreDead(player: playerA) {
            displayWinner(player: playerB)
        } else {
            displayWinner(player: playerA)
        }
    }
    
    // display winner and result
    private func displayWinner(player: Player) {
        print("")
        print("")
        print("")
        print("""
        *************************************************************************
        ** ⚔️ 🛡️  Le \(player.playerLabel)  🛡️  ⚔️   a gagné la partie !!   🌟 🌟 bravo 🌟 🌟   **
        *************************************************************************
        """)
        print("")
        
        for i in 0..<player.history.count {
            print("**  ⚔️  ⚔️  Round : \(i+1)  ⚔️  ⚔️   \(player.team[player.history[i].soldierNumber].characterName) \(returnOpponentRoundName(player: player, currentRoundNumber: i+1)) ** crédit de vie restante : \(player.history[i].opponentLifeValue)")
            print("")
        }
    }
    
    // return of the opposing player
    private func returnOpponentPlayer(player: Player) -> Player {
        if player.playerLabel == "Joueur A" {
            return playerB
        } else {
            return playerA
        }
        
    }
    
    // return the fight wording of the opponent
    private func returnOpponentRoundName(player: Player, currentRoundNumber: Int) -> String {
        if player.history[currentRoundNumber-1].healRound {
            return "a soigné  : " + player.team[player.history[currentRoundNumber-1].opponentNumber].characterName
        } else {
            return "a attaqué : " + returnOpponentPlayer(player: player).team[player.history[currentRoundNumber-1].opponentNumber].characterName
        }
    }
    
    // launch an attack by a player
    private func launchRoundAttack(player: Player) {
        let opponentPlayer = returnOpponentPlayer(player: player)
        
        
        let soldier = selectCharacter(player: player)
        
        if player.team[soldier].type == .magus {
            if selectToHeal() {
                let opponent = selectCharacter(player: player)
                player.team[opponent].lifeValue = player.team[opponent].lifeValue + player.team[soldier].type.weaponStrengh
                player.createRoundRecorder(soldierNumber: soldier, opponentNumber: opponent, healRound: true, opponentLifeValue: player.team[opponent].lifeValue)
                displayRoundResult(player: player)
            } else {
                let opponent = selectCharacter(player: opponentPlayer)
                opponentPlayer.team[opponent].lifeValue = opponentPlayer.team[opponent].lifeValue - player.team[soldier].type.weaponStrengh
                if opponentPlayer.team[opponent].lifeValue < 0 {
                    opponentPlayer.team[opponent].lifeValue = 0
                }
                player.createRoundRecorder(soldierNumber: soldier, opponentNumber: opponent, healRound: false, opponentLifeValue: opponentPlayer.team[opponent].lifeValue)
                displayRoundResult(player: player)
            }

        } else {
            let opponent = selectCharacter(player: opponentPlayer)
            opponentPlayer.team[opponent].lifeValue = opponentPlayer.team[opponent].lifeValue - player.team[soldier].type.weaponStrengh
            if opponentPlayer.team[opponent].lifeValue < 0 {
                opponentPlayer.team[opponent].lifeValue = 0
            }
            player.createRoundRecorder(soldierNumber: soldier, opponentNumber: opponent, healRound: false, opponentLifeValue: opponentPlayer.team[opponent].lifeValue)
            displayRoundResult(player: player)
        }

    }
    
    // display the attack result
    private func displayRoundResult(player: Player) {
        print("")
        print("""
        ********************************************************************************************************
        **  ⚔️  ⚔️  Round numéro : \(currentRoundNumber)  du \(player.playerLabel)  ⚔️  ⚔️   \(player.team[player.history[currentRoundNumber-1].soldierNumber].characterName) \(returnOpponentRoundName(player: player, currentRoundNumber: currentRoundNumber)) ** crédit de vie restante : \(player.history[currentRoundNumber-1].opponentLifeValue)
        ********************************************************************************************************
        
        """)
    }
    
    // control if a player lost
    private func controlIfAllCharactersAreDead(player: Player) -> Bool {
        
        return player.team[0].isDeadCharacter && player.team[1].isDeadCharacter && player.team[2].isDeadCharacter
    }

    // display the welcome message
    private func sayWelcome() {
        print("")
        print("******************************************************")
        print("* 🛡️ ⚔️  Bonjour et bienvenue sur GameOfFight  ⚔️ 🛡️  💥 *")
        print("******************************************************")
        print("")
        print("****** Première étape constitution des équipes *******")
    }
    
    // create team of 3 characters for one player
    private func createTeam(player: Player) {
        var nameCharacter = ""
               
        print("")
        print("")
        print("\(player.playerLabel) : constitution de son équipe de 3 personnages")

        for i in 1...3 {
    
            nameCharacter = inputNameCharacter(index: i)
            
            repeat {
                print("")
                print("""
                Choisissez le type du personnage numéro \(i) en tapant le chiffre correspondant :
                1. ⚔️  Warrior     L'attaquant classique (points de vie et arme équilibrés)
                2. 🛡️  Magus       Soigne les autres membres de son équipe (points de vie élevés et arme faible en attaque)
                3. 🔪 Colossus    Imposant et trés résistant (points de vie élevés et arme moyenne)
                4. 🪓 Dwarf       Redoutable (Points de vie faibles et arme ravageuse)
                """)
                
                if let type = inputCharacterType() {
                    print("Type personnage numéro \(i) : \(type.rawValue)")
                    player.createCharacter(characterName: nameCharacter, type: type)
                    break
                }
            } while (true)
            
        }
        
    }
    
    // select one alive character of the player team
    private func selectCharacter(player: Player) -> Int {
        print("")
        repeat {
            print("")
            print("")
            print("Pour l'équipe du \(player.playerLabel) : Choisir un personnage pour le round : \(currentRoundNumber)")
            print("")
        
            displayCharacters(player:player)
            if let pickedCharacter = inputPickedNumber(max: 3) {
                if player.team[pickedCharacter-1].isDeadCharacter {
                    print(" 💀 ☠️ ☠️ ☠️ 💀 Attention ce personnage est mort !! Choisissez un personnage vivant ! 💀 ☠️ ☠️ ☠️ 💀 ")
                    continue
                } else {
                    return pickedCharacter-1
                }
            }
                
        } while (true)

    }
    
    // select if the round is to give a heal
    private func selectToHeal() -> Bool {
        print("")
        repeat {
            print("")
            print("""
            Choisissez le type de mission pour le prochain round  :
            1. ⚔️  Attaque
            2. 🩺  Soin
            """)
            if let val = inputPickedNumber(max: 2) {
                if val == 2 {
                    return true
                } else {
                    return false
                }
            }
        } while (true)
    }
    
    // summary display of team for a player
    private func displayTeam(player: Player) {
        print("")
        print("")
        print("\(player.playerLabel) : récapitulatif de l'équipe constituée")
        print("")
        
        displayCharacters(player:player)
        
        
    }
    
    // display the team characters for a player
    private func displayCharacters(player: Player) {
        for (i, character) in player.team.enumerated() {
            print("""
               \(i+1). Personnage    : \(character.characterName)
                  Type          : \(character.type.rawValue)
                  Points de vie : \(character.lifeValue)
                  Force arme    : \(character.type.weaponStrengh)
               """)
            print("")
        }
    }
    
    // input the character name and control if the name exists
    private func inputNameCharacter(index i: Int) -> String {
        var result = ""
        repeat {
            print("")
            print("Choisissez un nom pour le personnage numéro \(i)")
            if let name = readLine() {
                result = name
            } else {
                print("Personnage numéro \(i) : caractères incorrects, réessayez")
                continue
            }
        } while (!Character.isNewName(characterName: result))
        
        return result
    }
    
    // input the character type and control if valid
    private func inputCharacterType() -> CharacterType? {
        var type:CharacterType = .warrior
        if let choice = inputPickedNumber(max: 4) {
            switch choice {
                case 1:
                type = .warrior
                case 2:
                type = .magus
                case 3:
                type = .colossus
                case 4:
                type = .dwarf
                default:
                return nil
            }
            
        } else {
            return nil
        }
        return type
    }
    
    // pick of a number between 0 and max
    private func inputPickedNumber(max i: Int) -> Int? {
        
        if let text = readLine() {
            if let val = Int(text) {
                if val > i || val <= 0 {
                    return nil
                } else {
                    return val
                }
            }
        }
        return nil
    }
}


/*
 *************************** End of Class definition *************
 */


/*
 ******** main programme *****************
 */
var game = Game()
game.startGame()
game.startFight()
