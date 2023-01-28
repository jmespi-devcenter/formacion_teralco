// Otro closure con solo un parámetro
def cuadrado = { factor ->
factor * factor
}

// Closure con dos parámetros
def multiplicar = { factor01, factor02 ->
factor01 * factor02
}

println cuadrado(8)
println multiplicar(2,6)

// Precarga de parámetro
def doble = multiplicar.curry(2)
println doble(6)

def triple = multiplicar.curry(3)
println triple(6)
