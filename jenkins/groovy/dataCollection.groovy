//Definición de rango
def miRango1 = 1..5
//Metodo each con closure
miRango1.each {
println it
} //Salida: 1, 2, 3, 4, 5
println '--------------------------------\n'
//Definición y acceso directo con each, también con closure
(1..<5).each { println it } //Salida: 1, 2, 3, 4
println '--------------------------------\n'
//Acceso mediante bucle for
for(int i in 1..5) {
println i
} //Salida: 1, 2, 3, 4, 5
println '--------------------------------\n'
//Definición de rango con exclusión por la derecha y por la izquierda
def miRango2 = 17<..<66
//Ejemplos de atributos y métodos
println miRango2.from //Salida: 18, desde
println miRango2.to //Salida: 65, a
println miRango2.contains(17) //Salida: false, 17 no pertenece al rango
println miRango2.contains(18) //Salida: true, 18 pertenece al rango
println miRango2.contains(65) //Salida: true, 65 pertenece al rango
println miRango2.contains(66) //Salida: false, 66 no pertenece al rango
println miRango2.size() //Salida: 48, tamaño del rango
println miRango2.get(10) //Salida: 28, valor del elemento en la posición 10
println miRango2[10]
//Salida: 28, valor del elemento en la posición 10
println '--------------------------------\n'
//Metodo reverse
miRango1 = miRango1.reverse()
miRango1.each {
println it
} //Salida: 5, 4, 3, 2, 1
println '--------------------------------\n'
// Rango en una comparación Switch
def nota = 4;
switch(nota) {
case 0..<5:
println 'Necesita mejorar'
break
case 5..<7:
println 'Progresa adecuadamente'
break
case 7..10:
println '¡Excelente!'
break
} //Salida: Necesita mejorar
println '--------------------------------\n'
// Uso de un rango de fechas, se importa clase java para dar formato a la salida
def hoy = new Date()
def semana = hoy + 7
import java.text.SimpleDateFormat
def formatoFecha = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss")
(hoy..<semana).each { dia ->
println ((formatoFecha.format(dia)).substring(0,10))
} //Salida: 14/26/2022, 15/26/2022, 16/26/2022, 17/26/2022, 18/26/2022, 19/26/2022,20/26/2022
println '--------------------------------\n'
//Definición de rango string
('a'..'e').each { letra ->
println letra
} //Salida: a, b, c, d, e