% resume.cls
%
%    Copyright 2005 Daniel Burrows
%
% You may use, modify, and redistribute this file in any way you please, so
% long as this copyright notice is maintained.


\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{resume}

\LoadClassWithOptions{article}

% No page numbers by default.
\pagestyle{empty}

\RequirePackage{calc}
\RequirePackage{ifthen}
\RequirePackage{url}
\RequirePackage{tabularx}
\RequirePackage{pgf}
\RequirePackage{pgfshade}
\RequirePackage{xxcolor}
\RequirePackage{auto-pst-pdf,pst-barcode}
\RequirePackage{float}
\RequirePackage{wrapfig}

\RequirePackage{times}
\RequirePackage[T1]{fontenc}

\RequirePackage[tmargin=1in,bmargin=1in]{geometry}

\definecolor{rulestartcolor}{rgb}{0,0,0}
\definecolor{ruleendcolor}{rgb}{0,0,1}

\newlength{\headerbuffer}
\setlength{\headerbuffer}{2pt}
\newlength{\secskip}
\setlength{\secskip}{6pt}

\newlength{\@headerscratch}

% Usage: \@setupshading{width}{height}{start}{end}
\newcommand{\@setupshading}[4]{%
  \pgfdeclarehorizontalshading{@ruleshading}{#2}{%
    color(0pt)=(#3); color(#1)=(#4)%
  }
}

\newcommand{\pgfrule}[4]{%
  \begin{pgfpicture}{0pt}{0pt}{#1}{#2}%
    \pgfdeclarehorizontalshading{@ruleshading}{#2}{%
      color(0pt)=(#3); color(#1)=(#4)%
    }
    \pgfputat{\pgfxy(0,0)}{\pgfbox[left,bottom]{\pgfuseshading{@ruleshading}}}
  \end{pgfpicture}%
}

\newcommand{\lrule}[2]{\pgfrule{#1}{#2}{rulestartcolor}{ruleendcolor}}
\newcommand{\rrule}[2]{\pgfrule{#1}{#2}{ruleendcolor}{rulestartcolor}}

\newcommand{\@authorname}{}
\newcommand{\@email}{}
\newcommand{\@streetaddress}{}
\newcommand{\@citystatezip}{}
\newcommand{\@phone}{}
\newcommand{\@webpage}{}
\newcommand{\@qrtitle}{}

\renewcommand{\author}[1]{\renewcommand{\@authorname}{#1}}
\newcommand{\email}[1]{\urldef{\@email}{\url}{#1}}
\newcommand{\streetaddress}[1]{\renewcommand{\@streetaddress}{#1}}
\newcommand{\citystatezip}[1]{\renewcommand{\@citystatezip}{#1}}
\newcommand{\phone}[1]{\renewcommand{\@phone}{#1}}
\newcommand{\webpage}[1]{\urldef{\@webpage}{\url}{#1}}
\newcommand{\qrtitle}[1]{\renewcommand{\@qrtitle}{#1}}

\newcommand{\maketopaddr}{
      \ifthenelse{\equal{\@webpage}{}}{
        \ifthenelse{\equal{\@streetaddress}{}}{}{\@streetaddress\par\noindent}
      }
      {
        \ifthenelse{\equal{\@streetaddress}{}}{\@webpage\par\noindent}{
          \begin{tabular*}{\linewidth}{l@{\extracolsep{\fill}}r}
            \@streetaddress & \@webpage
          \end{tabular*}
          \par\noindent
        }
      }
}

\newcommand{\makebotaddr}{
      \ifthenelse{\equal{\@citystatezip}{} \and \equal{\@phone}{}}{
      }{
        \ifthenelse{\equal{\@citystatezip}{} \or \equal{\@phone}{}}{
          \ClassError{resume}{
            Only one of \protect\streetaddress and \protect\citystatezip given
          }{
            You must either define both \protect\streetaddress and \protect\citystatezip,
            or define neither of them.
          }
        }{
          \begin{tabular*}{\linewidth}{l@{\extracolsep{\fill}}r}
                      \@citystatezip & \@phone
                                \end{tabular*}
        }
      }
}

\newcommand{\makeqrcode}{
  \begin{wrapfigure}{r}{1in}
    \includegraphics[width=20mm]{qrcode.png}
%    \vspace{-12pt}
%    \begin{pspicture}(-5mm,-3mm)(3in,3in)
%    \psbarcode{\@qrtitle}{eclevel=L}{qrcode}
%    \end{pspicture}
%    \@qrtitle
  \end{wrapfigure}
}

\renewcommand{\maketitle}{{%
  \makeqrcode
  \setlength{\@headerscratch}{\linewidth*2/3}%
  \noindent \rrule{\@headerscratch}{1.5pt}%
  \vspace{\headerbuffer}%
  \ifthenelse{\equal{\@email}{}}{%
    \par\nointerlineskip\noindent\makebox[\linewidth]{\textbf{\Large{\@authorname}}}%
  } {%
    \par\nointerlineskip\noindent\makebox[\linewidth]{\textbf{\Large{\@authorname\ \@email}}}%
  }%
  \vspace{\headerbuffer}%
  \par\nointerlineskip\noindent%
  \hspace{\linewidth}%
  \hspace{-\@headerscratch}%
  \lrule{\@headerscratch}{1.5pt}%
  \par\nointerlineskip\noindent%
  % Typeset webpage/phone in columns if both are specified, or
  % just on the LHS if only one is.
  \begin{small}
    \maketopaddr
    \makebotaddr
    \vspace{0.4in}
  \end{small}
}}

\renewcommand{\section}[1]{%
  \goodbreak\vspace{\secskip}%
  \par\nointerlineskip\noindent\textbf{\textsc{\large\makebox[\linewidth][l]{#1}}}\vspace{\headerbuffer}\par\nointerlineskip\noindent%
  \rule{\linewidth}{0.4pt}%
  \vspace{\headerbuffer}\par\nointerlineskip}

\renewcommand{\subsection}[1]{%
  \goodbreak\vspace{\secskip}\par\nointerlineskip%
  \textbf{#1}\vspace{\headerbuffer}\par\nointerlineskip%
  \noindent\rule{\linewidth}{0.4pt}%
  \vspace{\headerbuffer}\par\nointerlineskip
}

% General catch-all for either educational or job affiliation.
%
%  Usage:
% \affiliation[title]{institution}{years}
\newcommand{\affiliation}[3][]{%
  \goodbreak\vspace{\secskip}\par\noindent\begin{tabularx}{\linewidth}{Xr}%
    {\bfseries #2} & \textit{#3}%
    \ifthenelse{\equal{#1}{}}{}{%
      \\ \textbf{#1}%
    }%
  \end{tabularx}%
}%

