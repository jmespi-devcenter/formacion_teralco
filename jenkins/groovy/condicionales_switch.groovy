//También se soporta la expresión switch / case, como se muestra en el siguiente ejemplo

 def person="Adam"

 def partner = switch(person) {
    case 'Romeo' -> 'Juliet'
    case 'Adam' -> 'Eve'
    case 'Antony' -> 'Cleopatra'
    case 'Bonnie' -> 'Clyde'
}

println partner