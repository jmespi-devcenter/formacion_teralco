def lunasjupiter = []
def ssolar = ['Mercurio', 'Venus', 'Tierra', 'Marte', 'Júpiter', 'Saturno', 'Urano',
'Neptuno', '¿Plutón?']
def numeros = [4, 19, 1000, 2, 6]
lunasjupiter << "Io"
lunasjupiter.add("Europa")
println lunasjupiter[1]
println ssolar.getAt(2); println '\n'

lunasjupiter[3] = "Calisto"
lunasjupiter.each {
println it
}
println '\n'
lunasjupiter.remove(2)
lunasjupiter[3] = "Ganímedes"
lunasjupiter[4] = "Ortosia"
lunasjupiter.each {
println it
}
println '\n'
ssolar.each { planeta ->
println planeta
}
println '\n'
println(ssolar)
ssolar.removeLast()
println(ssolar)
ssolar.each { planeta ->
println planeta
}
println '\n'
ssolar.eachWithIndex { planeta, indice ->
println "El '${planeta}' ocupa el índice de la lista: ${indice}"
}
println ssolar
println '\nOrdenando lista...\n'
ssolar.sort()
println ssolar
ssolar.eachWithIndex { planeta, indice ->
println "El '${planeta}' ocupa el índice de la lista: ${indice}"
}
ssolar += lunasjupiter
println ssolar
ssolar.sort()
println ssolar
ssolar -= lunasjupiter
println ssolar