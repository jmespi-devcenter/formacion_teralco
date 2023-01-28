new FileWriter("example.txt", true).with {
    write("Hello world\n")
    flush()
}

file = new File("example.txt") 
println file.text