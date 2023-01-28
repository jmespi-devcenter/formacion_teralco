def tablaMohs = ['Talco':'se raya fácilmente con la uña', 
'Yeso':'se raya con dificultad con la uña', 
'Calcita':'se raya con una moneda de cobre', 
'Fluorita':'se raya con un cuchillo de acero', 
'Apatita':'se raya difícilmente con un cuchillo', 
'Ortoclasa':'se raya con una lija para el acero', 
'Cuarzo':'raya al vidrio', 
'Topacio':'se raya con herramientas de carburo de wolframio',
 'Corindón':'se raya con herramientas de carburo de silicio', 
 'Diamante':'solo se raya con otro diamante']

println tablaMohs.get('Talco');
println tablaMohs.'Talco';
println tablaMohs['Talco'];

println"------------------------\n"
tablaMohs.each {
println it
}
println"------------------------\n"
tablaMohs.each {
print it.key
print " => "
println it.value
}
println"------------------------\n"

tablaMohs.each {mineral, dureza ->
    println "El mineral ${mineral} ${dureza}"
}