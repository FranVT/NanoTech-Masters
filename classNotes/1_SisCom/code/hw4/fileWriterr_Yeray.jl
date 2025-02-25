nc = 3 #Values to modify (number of chains)
n_at = 10 #Values to modify (number of atoms per chain)
m = [1.0, 1.0, 1.0] #Mass for depending on number of chains


np = n_at*nc
nb = (np - 1*nc)
na = (np - 2*nc)
#nd = np - 3

atom_types = 1*nc
bond_types = 1*nc
angle_types = 1*nc
#dihedral_types = 1

wall_dimension = 20.0
L = wall_dimension/2.0

ϵ = 1.0
σ = 1.0

function initial_positions_distribution()
    p_dist = 1.5*σ
    x = zeros(Float64, np, 3)
    first_x = -L + p_dist
    first_y = -L + p_dist
    first_z = -L + p_dist
    x[1, 1] = first_x
    x[1, 2] = first_y
    x[1, 3] = first_z
    for i=2:np
        if first_x < L - p_dist
            first_x += p_dist
            x[i, 1] = first_x
            x[i, 2] = first_y
            x[i, 3] = first_z
        else
            first_x = -L + p_dist
            first_z += p_dist
            #first_y += p_dist
            if first_z > L - p_dist
                first_x = -L + p_dist
                first_z = -L + p_dist
                first_y += p_dist

            elseif first_y > L - p_dist
                    println("No more space in system")
                    return x[1:i-1, :]
                # Return already filled positions if out of space
            end
            x[i, 1] = first_x
            x[i, 2] = first_y
            x[i, 3] = first_z
        end
    end
    return x
end

function write_file()

    pos = initial_positions_distribution()

    file = open("C:/Users/Haple/Documents/Polymer_LAMMPS/polymer_data.txt", "w")


    write(file, "# \n\n")
    write(file, "$np atoms\n")
    write(file, "$nb bonds\n")
    write(file, "$na angles\n")
    #write(file, "$nd dihedrals\n\n")

    write(file, "$atom_types atom types\n")
    write(file, "$bond_types bond types\n")
    write(file, "$angle_types angle types\n")
    #write(file, "$dihedral_types dihedral types\n\n")

    write(file, "$(-L-5) $(L+5) xlo xhi\n")
    write(file, "$(-L-5) $(L+5) ylo yhi\n")
    write(file, "$(-L-5) $(L+5) zlo zhi\n\n")

    write(file, "Masses\n\n")

    for i=eachindex(m)
        write(file, "$i $(m[i])\n")
    end

    write(file, "\n")
    write(file, "Atoms\n\n")

    saved_i = 1
    for j = 1:nc
        for i=1:n_at      
            write(file, "$saved_i 1 $j $(pos[i, 1]) $(pos[i, 2]+ 3*j) $(pos[i, 3] + 3*j)\n")
            saved_i += 1
        end
    end
    

    write(file, "\nBonds\n\n")


    current_chain_bond = 0 
    for i = 1:nb
        write(file, "$i $(current_chain_bond + 1) $(i+current_chain_bond) $((i + current_chain_bond)+1)\n")
        if (i)%(nb/nc) == 0 && (i) != 1
            current_chain_bond += 1
        end
    end

    write(file, "\nAngles\n\n")

    curren_chain_angle = 0
    for i = 1:na
        write(file, "$i 1 $(i+curren_chain_angle) $(i+curren_chain_angle+1) $(i+curren_chain_angle+2)\n")
        if (i)%(na/nc) == 0 && (i) != 1
            curren_chain_angle += 2
        end
    end

    #write(file, "\nDihedrals\n\n")
    #for i = 1:nd
    #    write(file, "$i 1 $(i) $(i+1) $(i+2) $(i+3)\n")
    #end


    write(file, "\nBond Coeffs\n\n")

    for i=1:nc
        write(file, "$i 1.0 100.0 1.0 1.0\n")
    end

    write(file, "\nAngle Coeffs\n\n")
    for i=1:nc
        write(file, "$i 100.0 180.0\n")
    end

    #write(file, "\nDihedral Coeffs\n\n")

    #write(file, "1 0.05 1 1\n")

    close(file)

end

function exe_lammps()

    lammps_file = "polymer.lmp"
    cmd = "cd C:\\Users\\Haple\\Documents\\Polymer_LAMMPS; lmp -in $(lammps_file)"

    run(`powershell -Command $cmd`)

end

write_file()
exe_lammps()

