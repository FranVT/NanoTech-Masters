: '
    Script to create shear report file
'

#!bin/bash

id=$1;
dir_system=$2;
path_system=$3;
path_reports=$4
file_name=$5;
shear=$6;

parentdir=$(cd .. && pwd);

dir_home=$(pwd);
dir_method="bonds-3.0";
dir_report="reports";


path_system="$parentdir/$dir_method/data/$dir_system";
path_assemblyDat="$path_system";

# Read the assemblt data file
source $dir_report/src/load_parameters.sh $path_system/$file_name

filename="$path_reports/docs/files/shear-$shear.tex";
cat > "$filename" << EOF
% Plantilla creada por Francisco Javier Vázquez Tavares
% Esta platilla se creo para facilitar la creación de documentos para tareas.

\documentclass[../main.tex]{tareaClass}

\begin{document}

\section{ Parameters}

\begin{table}[ht!]
\begin{minipage}[c]{0.45\textwidth}
\centering
\caption{Assembly parameters simulation}
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

\end{minipage}
\hfill
\begin{minipage}[c]{0.45\textwidth}
\centering
\caption{Shear parameters?}
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
\end{minipage}
\end{table}


\section{Figures}

\subsection{Assembly}

\begin{figure}[ht!]
\centering
\includegraphics[width=\textwidth]{imgs/$id-system_assembly.png}
\end{figure}

\subsection{Shear}


\end{document}
EOF

echo "Archivo LaTeX generado: $filename"

