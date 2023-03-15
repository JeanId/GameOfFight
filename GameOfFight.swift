//
//  GameOfFight .swift
//  
//
//  Created by Jean Barottin on 03/03/2023.
//

import Foundation

/*
 ******** Class definition ******
 */

enum CharacterType: String {
    case Warrior, Magus, Colossus, Dwarf
}


extension CharacterType {
    var initialLifeCapital: Int {
        switch self {
        case .Warrior:
            return 100
        case .Magus:
            return 150
        case .Colossus:
            return 150
        case .Dwarf:
            return 75
        }
    }
    
    var weaponStrengh: Int {
        switch self {
        case .Warrior:
            return 50
        case .Magus:
            return 25
        case .Colossus:
            return 25
        case .Dwarf:
            return 75
        }
    }
}


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
    
    //function returns the number of characters
    static func getNbCharacter() -> Int {
        return Character.listName.count
    }
    
    //function returns true if the characterName is new
    static func isNewName(characterName:String) -> Bool {
        return !Character.listName.contains(characterName.lowercased())
    }
}


class Player {
    var playerLabel: String
    var team: [Character] = []
    var history: [RoundRecorder] = []
    var roundNumber = 0
    
    init(playerLabel: String) {
        self.playerLabel = playerLabel
    }
   
    func createCharacter(characterName: String, type: CharacterType) {
        self.team.append(Character(characterName: characterName, type: type))
    }
    
    func createRoundRecorder(soldierNumber: Int,opponentNumber: Int, healRound: Bool, opponentLifeValue: Int) {
        self.history.append(RoundRecorder(soldierNumber: soldierNumber, opponentNumber: opponentNumber, healRound: healRound, opponentLifeValue: opponentLifeValue))
    }
}


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


class Game {
    private let playerA = Player(playerLabel: "Joueur A")
    private let playerB = Player(playerLabel: "Joueur B")
    private var currentRoundNumber = 0
    
    func startGame() {
        sayWelcome()
        createTeam(player: playerA)
        createTeam(player: playerB)
        displayTeam(player: playerA)
        displayTeam(player: playerB)
    }
    
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
        
        for i in 0...(player.history.count - 1) {
            print("**  ⚔️  ⚔️  Round : \(i+1)  ⚔️  ⚔️   \(player.team[player.history[i].soldierNumber].characterName) \(returnOpponentRoundName(player: player, roundNumber: i+1)) ** crédit de vie restante : \(player.history[i].opponentLifeValue)")
            print("")
        }
    }
    
    private func returnOpponentPlayer(player: Player) -> Player {
        if player.playerLabel == "Joueur A" {
            return playerB
        } else {
            return playerA
        }
        
    }
    
    private func returnOpponentRoundName(player: Player, roundNumber: Int) -> String {
        if player.history[roundNumber-1].healRound {
            return "a soigné  : " + player.team[player.history[roundNumber-1].opponentNumber].characterName
        } else {
            return "a attaqué : " + returnOpponentPlayer(player: player).team[player.history[roundNumber-1].opponentNumber].characterName
        }
    }
    
    private func launchRoundAttack(player: Player) {
        let opponentPlayer = returnOpponentPlayer(player: player)
        
        player.roundNumber += 1
        
        let soldier = selectCharacter(player: player)
        
        if player.team[soldier].type == .Magus {
            if selectToHeal() {
                let opponent = selectCharacter(player: player)
                player.team[opponent].lifeValue = player.team[opponent].lifeValue + player.team[soldier].type.weaponStrengh
                player.createRoundRecorder(soldierNumber: soldier, opponentNumber: opponent, healRound: true, opponentLifeValue: player.team[opponent].lifeValue)
                displayRoundResult(player: player)
            } else {
                let opponent = selectCharacter(player: opponentPlayer)
                opponentPlayer.team[opponent].lifeValue = opponentPlayer.team[opponent].lifeValue - player.team[soldier].type.weaponStrengh
                player.createRoundRecorder(soldierNumber: soldier, opponentNumber: opponent, healRound: false, opponentLifeValue: opponentPlayer.team[opponent].lifeValue)
                displayRoundResult(player: player)
            }

        } else {
            let opponent = selectCharacter(player: opponentPlayer)
            opponentPlayer.team[opponent].lifeValue = opponentPlayer.team[opponent].lifeValue - player.team[soldier].type.weaponStrengh
            player.createRoundRecorder(soldierNumber: soldier, opponentNumber: opponent, healRound: false, opponentLifeValue: opponentPlayer.team[opponent].lifeValue)
            displayRoundResult(player: player)
        }

    }
    
    private func displayRoundResult(player: Player) {
        print("")
        print("""
        ********************************************************************************************************
        **  ⚔️  ⚔️  Round numéro : \(player.roundNumber)  du \(player.playerLabel)  ⚔️  ⚔️   \(player.team[player.history[player.roundNumber-1].soldierNumber].characterName) \(returnOpponentRoundName(player: player, roundNumber: player.roundNumber)) ** crédit de vie restante : \(player.history[player.roundNumber-1].opponentLifeValue)
        ********************************************************************************************************
        
        """)
    }
    
    private func controlIfAllCharactersAreDead(player: Player) -> Bool {
        
        return player.team[0].isDeadCharacter && player.team[1].isDeadCharacter && player.team[2].isDeadCharacter
    }

    private func sayWelcome() {
        print("")
        print("******************************************************")
        print("* 🛡️ ⚔️  Bonjour et bienvenue sur GameOfFight  ⚔️ 🛡️  💥 *")
        print("******************************************************")
        print("")
        print("****** Première étape constitution des équipes *******")
    }
    
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
    
    private func displayTeam(player: Player) {
        print("")
        print("")
        print("\(player.playerLabel) : récapitulatif de l'équipe constituée")
        print("")
        
        displayCharacters(player:player)
        
        
    }
                  
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
    
    private func inputCharacterType() -> CharacterType? {
        var type:CharacterType = .Warrior
        if let choice = inputPickedNumber(max: 4) {
            switch choice {
                case 1:
                type = .Warrior
                case 2:
                type = .Magus
                case 3:
                type = .Colossus
                case 4:
                type = .Dwarf
                default:
                return nil
            }
            
        } else {
            return nil
        }
        return type
    }
    
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
 ******** End of Class definition *************
 */
/*
 ******** main programme *****************
 */
var game = Game()
game.startGame()
game.startFight()
//game.testFonction()
