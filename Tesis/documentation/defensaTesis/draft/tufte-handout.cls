\NeedsTeXFormat{LaTeX2e}[1994/06/01]

\ProvidesClass{tufte-handout}[2015/06/21 v3.5.2 Tufte-handout class]

%%
% Declare we're tufte-handout
\newcommand{\@tufte@class}{article}% the base LaTeX class (defaults to the article/handout style)
\newcommand{\@tufte@pkgname}{tufte-handout}% the name of the package (defaults to tufte-handout)

%%
% Load the common style elements
\input{tufte-common.def}


%%
% Set up any handout-specific stuff now

%%
% Abstract

% TODO The abstract should be printed on its own page of the `titlepage'
% option was specified.
\renewenvironment{abstract}
  {\begin{quotation}\if@tufte@sfsidenotes\begin{sffamily}\fi}
  {\if@tufte@sfsidenotes\end{sffamily}\fi\end{quotation}}


%%
% If there is a `tufte-handout-local.tex' file, load it.

\IfFileExists{tufte-handout-local.tex}{%
  \input{tufte-handout-local}%
  \@tufte@info@noline{Loading tufte-handout-local.tex}%
}{}

% Paquetes de notación matemática y física
\RequirePackage{amsmath,amsthm,amsfonts,amssymb,amscd,latexsym}
\RequirePackage{physics}
\RequirePackage{siunitx} 		% Permite utilizar el sistema internacional de unidades
\RequirePackage{mathptmx}
\RequirePackage{mathtools}
\RequirePackage{cancel}
\RequirePackage{centernot} 		% Notacion matematica
\RequirePackage{empheq}			% Recuadros para ecuaciones
\RequirePackage[most]{tcolorbox}

% Recursos Visuales
\RequirePackage{graphics} 		% for pdf, bitmapped graphics files
\RequirePackage{graphicx} 		% Insertar imágenes
\RequirePackage{caption} 		% Figure
\RequirePackage{subcaption} 	% Subfigure
\RequirePackage{float}          % Alineación de la figura
\RequirePackage{rotating} 		% Rotar imagenes
\RequirePackage{tikz}   		% To create graphics in LaTeX
\RequirePackage{multicol} 		% Formato doble columna
\RequirePackage{multirow} 		% Multi row is for tables with multiple rows within one cell.
\RequirePackage{booktabs} 		% For even nicer tables.
\RequirePackage{svg}
\RequirePackage{cleveref}

\crefformat{tcb@cnt@note}{note~#2#1#3}
\newtcbtheorem[]{definition}{Definition}%
    {enhanced,
    colback = black!5, %white,
    colbacktitle = black!5,
    coltitle = black,
    boxrule = 0pt,
    frame hidden,
    borderline west = {0.5mm}{0.0mm}{black},
    fonttitle = \bfseries\sffamily,
    breakable,
    before skip = 3ex,
    after skip = 3ex
}{def}

\newtcbtheorem[]{example}{Example}%
    {enhanced,
    colback = black!5, %white,
    colbacktitle = black!5,
    coltitle = black,
    boxrule = 0pt,
    frame hidden,
    borderline west = {0.5mm}{0.0mm}{black},
    fonttitle = \bfseries\sffamily,
    breakable,
    before skip = 3ex,
    after skip = 3ex
}{exa}

\newtcbtheorem[]{note}{Note}%
    {enhanced,
    colback = black!5, %white,
    colbacktitle = black!5,
    coltitle = black,
    boxrule = 0pt,
    frame hidden,
    borderline west = {0.5mm}{0.0mm}{black},
    fonttitle = \bfseries\sffamily,
    breakable,
    before skip = 3ex,
    after skip = 3ex
}{note}


\tcbuselibrary{skins, breakable}




%%
% End of file
\endinput
