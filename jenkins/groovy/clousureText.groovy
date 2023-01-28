def saludaPlaneta = { nombre ->
println "¡Hola ${nombre}!" }

def despidePlaneta = { nombre ->
println "¡Adios ${nombre}!" }

// Ejemplo de clouser como parámetro
def ssolar = ['Mercurio', 'Venus', 'Tierra', 'Marte', 'Júpiter', 'Saturno', 'Urano',
'Neptuno', '¿Plutón?']

def mensajePlanetas(sistema, Closure mensaje) {
    for (cceleste in sistema ) {
    mensaje cceleste
    }
}

mensajePlanetas(ssolar, saludaPlaneta)
mensajePlanetas(ssolar, despidePlaneta)