print("Bonjour bienvenue sur GameOfFight 💥 ")
print("****** Première étape constitution des équipes ******")

print("Joueur 1 : contitution de son équipe de 3 personnages")
print("Joueur 1 : Entrez le nom du personnage \(1) ?")
if let name = readLine() {
    print("personnage \(1) \(name)")
}

print("""
Joueur 1 : Choisissez le type du personnage en tapant le chiffre correspondant :
1. ⚔️  Warrior     L'attaquant classique (points de vie et arme équilibrés)
2. 🛡️  Magus       Soigne les autres membres de son équipe (points de vie élevés et arme faible en attaque)
3. 🔪 Colossus    Imposant et trés résistant (points de vie élevés et arme moyenne)
4. 🪓 Dwarf       Redoutable (Points de vie faibles et arme ravageuse)
""")

if let name = readLine() {
    print("personnage \(1) \(name)")
}

