def color = 'blanco'
def pregunta = "¿De qué color es el caballo de Santiago?"
println "Clase del objeto 'color': " + color.class
println 'Clase del objeto "pregunta": ' + pregunta.class
pregunta = '¿De qué color es el caballo ${color} de Santiago?'
println "$pregunta"
pregunta = "¿De qué color es el caballo ${color} de Santiago?"
println 'Clase del objeto "pregunta": ' + pregunta.class
println "\n$pregunta"
cs = new cowsay()
cs.main(color)