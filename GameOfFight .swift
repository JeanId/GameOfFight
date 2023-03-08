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

enum CharacterType {
    case Warior, Magus, Colossus, Dwarf
}

enum IdPlayer {
    case Player_A, Player_B
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
        case .Warior:
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
            if characterName == name return false
        }
        return true
    }
    
}

class HealerCharacter:Character {
    func heal() {
    
    }
}

class Player {
    
    var player:IdPlayer = .Player_A
    var team:[Character]=[]
    var isAliveCharacter:Bool = true
    
    func createTeam() {
        
    }
    
    func createCharacter(characterName: String, type: CharacterType ){
        team.append(Character(characterName: characterName, type: type))
    }
}

class Game {
    var playerA = Player()
    var playerB = Player()
    
    
    func sayWelcome() {
        print("Bonjour bienvenue sur GameOfFight 💥 ")
        print("****** Première étape constitution des équipes ******")
    }
    
    func createTeam(player:IdPlayer) {
        let currentIdPlayer = player
        var playerLabel = ""
        var currentPlayer = Player()
        
        switch currentIdPlayer {
        case .Player_A:
            playerLabel = "Joueur A"
            currentPlayer = playerA
        case .Player_B:
            playerLabel = "Joueur B"
            currentPlayer = playerB
        }
        
        for i in 1..3 {
            print("\(playerLabel) : contitution de son équipe de 3 personnages")
            print("\(playerLabel) : Entrez le nom du personnage numéro \(i)")
            if let name = readLine() {
                print("personnage nuréro \(i) : \(name)")
            }

            print("""
            \(playerLabel) : Choisissez le type du personnage numéro \(i) en tapant le chiffre correspondant :
            1. ⚔️  Warrior     L'attaquant classique (points de vie et arme équilibrés)
            2. 🛡️  Magus       Soigne les autres membres de son équipe (points de vie élevés et arme faible en attaque)
            3. 🔪 Colossus    Imposant et trés résistant (points de vie élevés et arme moyenne)
            4. 🪓 Dwarf       Redoutable (Points de vie faibles et arme ravageuse)
            """)

            if let name = readLine() {
                print("personnage \(1) \(name)")
            }
            
        }
        
    }
}

/*
 ******** End of Class definition ******
 */


var character = Character(characterName: "Keller", type: .Magus)

print(character.characterName)
print(character.lifeValue)
print(character.weaponValue)
