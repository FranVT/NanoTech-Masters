#!/bin/bash

 # Move data files to system directory

cd sysFiles/auxscp parameters.jl parameters_copy.jl; mv parameters_copy.jl /home/franvtdebian/GitRepos/NanoTech-Masters/Tesis/lammps/inSilicoHydroGels/experiments/TotalFree/dataFiles/systemCL200MO1800ShearRate2000Cycles4;
cd /home/franvtdebian/GitRepos/NanoTech-Masters/Tesis/lammps/inSilicoHydroGels/experiments/TotalFree/dataFiles/systemCL200MO1800ShearRate2000Cycles4; mv parameters_copy.jl parameters.jl;
cd /home/franvtdebian/GitRepos/NanoTech-Masters/Tesis/lammps/inSilicoHydroGels/experiments/TotalFree;
mv data.hydrogel /home/franvtdebian/GitRepos/NanoTech-Masters/Tesis/lammps/inSilicoHydroGels/experiments/TotalFree/dataFiles/systemCL200MO1800ShearRate2000Cycles4;
cd info;
mv energy_assembly.fixf /home/franvtdebian/GitRepos/NanoTech-Masters/Tesis/lammps/inSilicoHydroGels/experiments/TotalFree/dataFiles/systemCL200MO1800ShearRate2000Cycles4;
mv bondlenPatch_shear.fixf /home/franvtdebian/GitRepos/NanoTech-Masters/Tesis/lammps/inSilicoHydroGels/experiments/TotalFree/dataFiles/systemCL200MO1800ShearRate2000Cycles4;
mv bondlenPatch_shear.fixf /home/franvtdebian/GitRepos/NanoTech-Masters/Tesis/lammps/inSilicoHydroGels/experiments/TotalFree/dataFiles/systemCL200MO1800ShearRate2000Cycles4;
mv energy_shear.fixf /home/franvtdebian/GitRepos/NanoTech-Masters/Tesis/lammps/inSilicoHydroGels/experiments/TotalFree/dataFiles/systemCL200MO1800ShearRate2000Cycles4;
mv stressVirial_shear.fixf /home/franvtdebian/GitRepos/NanoTech-Masters/Tesis/lammps/inSilicoHydroGels/experiments/TotalFree/dataFiles/systemCL200MO1800ShearRate2000Cycles4;
mv bondlenPatch_shear.fixf /home/franvtdebian/GitRepos/NanoTech-Masters/Tesis/lammps/inSilicoHydroGels/experiments/TotalFree/dataFiles/systemCL200MO1800ShearRate2000Cycles4;
mv bondlenPatch_shear.fixf /home/franvtdebian/GitRepos/NanoTech-Masters/Tesis/lammps/inSilicoHydroGels/experiments/TotalFree/dataFiles/systemCL200MO1800ShearRate2000Cycles4;
