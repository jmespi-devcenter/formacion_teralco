def valor01 = ( 1==1 ) ? 'OK' : 'KO'
def valor02 = ( 1==2 ) ? 'OK' : 'KO'
println "$valor01 $valor02" //Salida: OK KO
nodefinido=null
def nombre = nodefinido ?: "Anónimo"
println "$nombre" //Salida: Anónimo