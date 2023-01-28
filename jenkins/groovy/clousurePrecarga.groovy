// Closure con solo un parámetro
def saludaPlaneta = { nombre ->
println "¡Hola ${nombre}!" }
saludaPlaneta 'Venus'

// Precarga de parámetro
def planeta = saludaPlaneta.curry('Mercurio')
planeta
