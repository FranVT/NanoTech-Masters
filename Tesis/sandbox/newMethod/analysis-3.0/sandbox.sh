: '
    Script that creates a pdf with general information of the simulation results
'

#!/bin/bash

id=$1;
dir_system=$2;
path_system=$3;
path_reports=$4
file_name=$5;


parentdir=$(cd .. && pwd);

dir_home=$(pwd);
dir_method="bonds-3.0";
dir_report="reports";


path_system="$parentdir/$dir_method/data/$dir_system";
path_assemblyDat="$path_system";


# Read the assemblt data file
source $dir_report/src/load_parameters.sh $path_system/$file_name

filename="$path_reports/docs/main.tex";
cat > "$filename" << EOF
% Plantilla creada por Francisco Javier Vázquez Tavares
% Esta platilla se creo para facilitar la creación de documentos para tareas.

\documentclass{tareaClass}

\title{ System ID: $id }

\begin{document}
\lhead{ System ID: $id }\rhead{ \today }

\maketitle

\section{ Parameters}

\begin{table}[ht!]
\centering
\caption{General parameters for the simulation}
\begin{tabular}{|c|c|} 
\hline
Parameter & Value  \\\\ 
  \hline
    Packing fraction $\phi$ & $phi \\\\
    Crosslinker concentration & $CL_Con \\\\
    Total central particles & $Npart \\\\
    Temperature & $Temperature \\\\
    Time step & $time_step \\\\
    Box length (L) & $L \\\\
  \hline
\end{tabular}
\end{table}

\subfile{files/assembly.tex}

\end{document}
EOF

echo "Archivo LaTeX generado: $filename"


# Compile the document
cd $path_reports/docs
latexmk -pdf $filename

echo "LaTeX file Compiled"

