def text = "La razón de la sinrazón que a mi razón se hace, de tal manera mi razón enflaquece, que con razón me quejo de la vuestra fermosura... Con estas razones perdía el pobre caballero el juicio..."

def regExp = ~"\s([a-z|A-Z])*raz(o|ó)n[a-z]*";

def matcher = text =~ regExp

println "El número de coincidencias son " + matcher.size()


matcher.eachWithIndex {it, index ->
    println index+1 + ". Ocurrencia_ " + it

}