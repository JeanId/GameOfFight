//
//  GameOfFight .swift
//  
//
//  Created by Jean Barottin on 03/03/2023.
//

import Foundation

/*
 Class definition
 */

enum CharacterType {
    case Warior, Magus, Colossus, Dwarf
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
    var team:[Character]=[]
    var isAliveCharacter:Bool = true
    
    func createTeam() {
        
    }
    
    func createCharacter() {
        let character = Character(characterName: <#T##String#>, type: <#T##CharacterType#>)
    }
}

var character = Character(characterName: "Keller", type: .Magus)

print(character.characterName)
print(character.lifeValue)
print(character.weaponValue)
