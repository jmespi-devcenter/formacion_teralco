def capitales=['España':'Madrid', 'Francia':'Paris', 'Alemania':'Berlín', 'Irlanda':'Dublín']

def otrasCapitales=['Italia':'Roma', 'Reino Unido':'Londres']

capitales += otrasCapitales

println capitales

/*for (mp in capitales) {
    println "Clave: ${mp.key}, Valor: ${mp.value}"
}*/

otrasCapitales.each{
    capitales.remove(it.key)
}

println capitales