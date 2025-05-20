: '
    Script that creates a pdf with general information of the simulation results
'

#!/bin/bash

parentdir=$(cd .. && pwd);

id=2025-05-15-230326;
dir_home=$(pwd);
dir_method="bonds-3.0";
dir_system="system-$id-CL-0.5";
dir_report="reports";


path_system="$parentdir/$dir_method/data/$dir_system";
path_reports="$dir_home/$dir_report";
path_assemblyDat="$path_system";


# Read the assemblt data file
source $dir_report/src/load_parameters.sh $path_system/dataAssembly.dat

filename="$path_reports/docs/test.tex";
cat > "$filename" << EOF
% Plantilla creada por Francisco Javier Vázquez Tavares
% Esta platilla se creo para facilitar la creación de documentos para tareas.

\documentclass{tareaClass}

\title{ System ID: $dir_system }

\begin{document}
\lhead{ System ID: $dir_system }\rhead{ \today }

\maketitle

\section{General Parameters}

\begin{table}[ht!]
\centering
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



\section{Assembly}

\begin{table}[ht!]
\centering
\begin{tabular}{|c|c|} 
\hline
Parameter & Value  \\\\ 
  \hline
    Damp value & $damp \\\\
    Time steps for heat up process & \num{$N_heat} \\\\
    Time steps for isothermic process & \num{$N_isot} \\\\
    Fix saving frequency  & \num{$save_fix} \\\\
    Stress saving frequency & \num{$save_stress} \\\\
    Dump saving frquency  & \num{$save_dump} \\\\
  \hline
\end{tabular}
\end{table}

\begin{figure}[ht!]
\centering
\includegraphics[width=\textwidth]{imgs/$id-system_assembly.png}
\end{figure}

\newpage

\section{Shear}

\end{document}
EOF

echo "Archivo LaTeX generado: $filename"


# Compile the document
cd $path_reports/docs
latexmk -pdf $filename


# Obtener directorios
get_file_paths() {
    local dir="$1"
    local pattern="$2"
    
    find "$dir" -type f -name "$pattern" -print0 | 
    xargs -0 -I{} realpath "{}"
}

paths_shearDat=$(get_file_paths "$dir_system/shear*" "*.dat");


