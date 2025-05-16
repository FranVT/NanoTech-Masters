: '
    Script that creates a pdf with general information of the simulation results
'

#!/bin/bash

parentdir=$(cd .. && pwd);

dir_home=$(pwd);
dir_method="bonds-3.0";
dir_system="system-2025-05-15-230326-CL-0.5";
dir_report="reports";


path_system="$parentdir/$dir_method/data/$dir_system";
path_reports="$dir_home/$dir_report";
path_assemblyDat="$path_system";


# Read the assemblt data file
source $dir_report/src/load_parameters.sh $path_system/dataAssembly.dat

echo "Path to the data of the system: ${path_system}";
echo "Path to the data file of the system assembly: ${path_assemblyDat}";
echo "Path to the report directory: ${path_reports}";


# Ejemplo de cómo acceder a los datos
echo "----------------------------------------"
echo "Parámetros de simulación:"
echo "----------------------------------------"
echo "- Fracción de polímero (phi): $phi"
echo "- Crosslinker/Con (CL_Con): $CL_Con"
echo "- Número de partículas (Npart): $Npart"
echo "- Temperatura: $Temperature"
echo "- Paso temporal (time_step): $time_step"


filename="$path_reports/docs/test.tex";
cat > "$filename" << EOF
% Plantilla creada por Francisco Javier Vázquez Tavares
% Esta platilla se creo para facilitar la creación de documentos para tareas.

\documentclass{tareaClass}
%\selectlanguage{spanish} 
%\usepackage[spanish,onelanguage]{algorithm2e} %for psuedo code
\usepackage{listings}

\title{ System ID: $dir_system }

\begin{document}
\lhead{ System ID: $dir_system }\rhead{ \today }

\maketitle

\section{General Parameters}

\begin{longtable}{|c|c|} 
\hline
Parameter & Value  \endfirsthead 
  \hline
  Packing fraction $\phi$ & $phi \\
  Crosslinker concentration & $CL_Con \\
  Total central particles & $Npart \\
  Temperature & $Temperature \\
  time step & $time_step \\
  Box length (L) & $L \\
  \hline
\end{longtable}

\section{Assembly}

\begin{longtable}{|c|c|} 
\hline
Parameter & Value  \endfirsthead 
  \hline
    Damp value & $damp \\
    Time steps for heat up process & $N_heat \\
    Time steps for isothermic process & $N_isot \\
    Fix saving frequency  & $save_fix \\
    Stress saving frequency & $save_stress \\
    Dump saving frquency  & $save_dump \\
  \hline
\end{longtable}



\section{Shear}

\end{document}
EOF

echo "Archivo LaTeX generado: $filename"


# Compile the document
cd $path_reports/docs
latexmk -pdf $filename


