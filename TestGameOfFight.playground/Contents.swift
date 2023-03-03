//: A UIKit based Playground for presenting user interface
  

import PlaygroundSupport


enum CharacterType {
    case Warior, Magus, Colossus, Dwarf
}

class Character {
    var characterName:String
    var type:CharacterType
    var lifeValue:Int
    var weaponValue:Int
    
    
    init(characterName:String,type:CharacterType) {
        self.characterName = characterName
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
    
}

class HealerCharacter:Character {
    func heal() {
    
    }
}

class Player {
    var team:[Character]=[]
    var isAliveCharacter:Bool = true
}

var character = Character(characterName: "Keller", type: .Magus)
print(character.characterName)
print(character.lifeValue)
print(character.weaponValue)
var p1 = Player()
print(p1.team)
