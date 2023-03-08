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

enum CharacterType:String {
    case Warrior, Magus, Colossus, Dwarf
}



class Character {
    var characterName:String
    var type:CharacterType
    var lifeValue:Int
    var weaponValue:Int
    static var listName:[String] = []
    
    
    init(characterName:String,type:CharacterType) {
        self.characterName = characterName
        Character.listName.append(characterName)
        self.type = type
        switch type {
        case .Warrior:
            lifeValue = 100
            weaponValue = 20
        case .Magus :
            lifeValue = 200
            weaponValue = 5
        case .Colossus:
            lifeValue = 150
            weaponValue = 25
        case .Dwarf:
            lifeValue = 50
            weaponValue = 50
        }
    }
    
    //function returns the number of character names
    static func getNbCharacter() -> Int {
        return Character.listName.count
    }
    
    //function returns true if the characterName is new
    static func isNewName(characterName:String) -> Bool {
        for name in Character.listName {
            if characterName == name {
                return false
            }
        }
    return true
    }
}

class HealerCharacter:Character {
    func heal() {
    
    }
}


class Player {
    var playerLabel:String = ""
    var team:[Character]=[]
    var isAliveCharacter:Bool = true
   
    
   
    
    func createCharacter(characterName: String, type: CharacterType ){
        team.append(Character(characterName: characterName, type: type))
    }
}

class PlayerA:Player {
    private static var playerA:Player? = nil
    public static var shared:Player {
        if playerA == nil {
            playerA = Player()
            playerA?.playerLabel = "Joueur A"
        }
        return playerA!
    }
    private override init() {
        
    }
    
}

class PlayerB:Player {
    private static var playerB:Player? = nil
    public static var shared:Player {
        if playerB == nil {
            playerB = Player()
            playerB?.playerLabel = "Joueur B"
        }
        return playerB!
    }
    private override init() {
        
    }
}


class Game {
    private let playerA = PlayerA.shared
    private let playerB = PlayerB.shared
    
    func startGame() {
        sayWelcome()
        createTeam(player: playerA)
        displayTeam(player: playerA)
        print("")
    }
    
    private func sayWelcome() {
        print("")
        print("******************************************************")
        print("* 🛡️ ⚔️  Bonjour et bienvenue sur GameOfFight  ⚔️ 🛡️  💥 *")
        print("******************************************************")
        print("")
        print("****** Première étape constitution des équipes *******")
    }
    
    private func createTeam(player:Player) {
        var nameCharacter = ""
               
        print("")
        print("")
        print("\(player.playerLabel) : constitution de son équipe de 3 personnages")

        for i in 1...3 {
            var isGoodInput = true
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
                    isGoodInput = true
                } else {
                    isGoodInput = false
                }
            } while (!isGoodInput)
            
        }
        
    }
    
    private func displayTeam(player:Player) {
        print("")
        print("")
        print("\(player.playerLabel) : récapitulatif de l'équipe constituée")
        print("")
     

        for character in player.team {
            print("""
            Personnage    : \(character.characterName)
            Type          : \(character.type.rawValue)
            Points de vie : \(character.lifeValue)
            Force arme    : \(character.weaponValue)
            """)
            print("")
        }
        
    }
                  
                  
    private func inputNameCharacter(index i:Int) -> String {
        var valid = true
        var result = ""
        repeat {
            print("")
            print("Entrez le nom du personnage numéro \(i)")
            if let name = readLine() {
                result = name
                valid = true
            } else {
                print("Personnage numéro \(i) : caractères incorrects, réessayez")
                valid = false
            }
            if valid == true {
                valid = Character.isNewName(characterName: result)
            }
        } while (!valid)
        
        return result
    }
    
    private func inputCharacterType() -> CharacterType? {
        var type:CharacterType = .Warrior
        if let choice = readLine() {
            switch choice {
                case "1" :
                type = .Warrior
                case "2" :
                type = .Magus
                case "3" :
                type = .Colossus
                case "4" :
                type = .Dwarf
                default:
                return nil
            }
        }
        return type
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
