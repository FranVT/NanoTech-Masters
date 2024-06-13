
"""
    File to create all permutations of the sw file
"""

# Define the file path
file_path = "output.txt"
aux = vec(Iterators.product(Iterators.repeated(("PA ","PB ","CL ","MO "),3)...)|>collect);
aux2 = map(s->(*(aux[s]...))*"\n",eachindex(aux))


# Open the file in write mode
open(file_path, "w") do file
    # Write some content into the file
    map(s-> write(file,aux2[s]),eachindex(aux2))
end


println("File '$file_path' has been created and written to.")
