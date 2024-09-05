#!/bin/bash

# Script that runs the deformation experiment

julia sysFiles/auxs/createBashDeformation.jl

echo -e 'Bash script created \n'
echo -e 'Run the bash script \n'

bash deformationSimulation.sh

bash runAnalysis.sh

#echo -e 'Move the files into directory: \n'

#cd info;

#if [[ -f energy_assembly.fixf ]]; then
#    echo -e 'Assembly in /info \n'
#    EnergyAssembly=1
#else
#    echo -e 'Assembly not in /info \n'
#    EnergyAssembly=0
#fi

#if [[ -f energy_shear.fixf ]]; then
#    echo -e 'Shear in /info \n'
#    EnergyShear=1
#else
#    echo -e 'Shear not in /info \n'
#    EnergyShear=0
#fi


#if [[ -f stressVirial_shear.fixf ]] && [[ -f energy_assembly.fixf ]]; then
#    cd ..;
#    echo -e 'Move Assembly and shear fix files'
    #julia info/analysis.jl 1 1
#elif [[ -f stressVirial_shear.fixf ]] && [[ ! -f energy_assembly.fixf ]]; then
#    cd ..;
#    echo -e 'Move the shear fix files to the system directory \n'
    #julia info/analysis.jl 0 1
#else
#    cd ..;
#    echo -e 'Running the julia script \n'
    #julia info/analysis.jl 0 0
#fi

#cd ..;
