% homework.cls
% LaTeX class for typesetting homework
% Author: Artem Mavrin
%
% The most recent version can be found here:
% https://github.com/artemmavrin/latex-homework/blob/master/homework.cls
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{homework}[2017/11/09 LaTeX class for typesetting homework]


%%%%%%%%%%%%%%%%%%%%%%%%%%
% Class base and options %
%%%%%%%%%%%%%%%%%%%%%%%%%%

% Support for key-value class options
\RequirePackage{kvoptions}
\SetupKeyvalOptions{
  family=HW,
  prefix=HW@,
}

% Options for 10pt, 11pt, or 12pt fonts
% We don't defer this to the article class because we want 12pt to be the
% default font size
\def\@fontsize{12pt}
\DeclareVoidOption{10pt}{\renewcommand{\@fontsize}{10pt}}
\DeclareVoidOption{11pt}{\renewcommand{\@fontsize}{11pt}}
\DeclareVoidOption{12pt}{\renewcommand{\@fontsize}{12pt}}

% True/False options. Defaults are False
\DeclareBoolOption{qed}             % End solutions with a QED tombstone symbol
\DeclareBoolOption{hidesolutions}   % Do not display solutions
\DeclareBoolOption{boxes}           % Wrap problems in boxes

% All other options get passed to the article class
\DeclareDefaultOption{\PassOptionsToClass{\CurrentOption}{article}}

% Process the options provided to the class and load the `article' class
\ProcessKeyvalOptions*
\LoadClass[\@fontsize,a4paper]{article}


%%%%%%%%%%%%%%%%%%%%
% Homework details %
%%%%%%%%%%%%%%%%%%%%

% Internal names for homework details

% The internal student name, course name, term, and HW number macros have no
% default value and will raise an error if used before being set by their
% corresponding defining macros.
\def\@name{\@latex@error{No \noexpand\name given}\@ehc}
\def\@id{\@latex@error{No \noexpand\id given}\@ehc}
\def\@course{\@latex@error{No \noexpand\course given}\@ehc}
\def\@term{\@latex@error{No \noexpand\term given}\@ehc}
\def\@hwnum{\@latex@error{No \noexpand\hwnum given}\@ehc}
% The following internal homework detail macros have default values and do not
% have to be specified manually.
\def\@hwname{Homework}
\def\@problemname{Problem}
\def\@solutionname{Solution}
% The homework title is determined by the course name, homework name, and
% homework number, and cannot be changed by the user (without redefining
% \@hwtitle).
\def\@hwtitle{\@hwname\ \@hwnum}

% The following macros let the user specify the values of the internal homework
% detail macros defined above.

% The following four macros must be used in the preamble.
\def\name#1{\renewcommand\@name{#1}}
\def\id#1{\renewcommand\@id{#1}}
\def\course#1{\renewcommand\@course{#1}}
\def\term#1{\renewcommand\@term{#1}}
\def\hwnum#1{\renewcommand\@hwnum{#1}}
% The following just redefine default values and are therefore optional
\def\hwname#1{\renewcommand\@hwname{#1}}
\def\solutionname#1{\renewcommand\@solutionname{#1}}
\def\problemname#1{\renewcommand\@problemname{#1}}


%%%%%%%%%%%%%%%%%%%
% Page formatting %
%%%%%%%%%%%%%%%%%%%

% Set up page headers and footers using the `fancyhdr' package
\RequirePackage{fancyhdr}
\renewcommand\headrulewidth{1pt}
% First page style
\fancypagestyle{firstpage}
{
  \fancyhf{}
  \fancyhead[L]{{\@course}\\{\@term}}
  \fancyhead[R]{{\@name}\\{\@id}}
  \fancyfoot[C]{\small\thepage}
}
% Subsequent page style
\fancypagestyle{runningpage}
{
  \fancyhf{}
  \fancyhead[L]{\small\@hwtitle}
  \fancyhead[R]{\small\@name}
  \fancyfoot[C]{\small\thepage}
}
\pagestyle{runningpage}

% Specify how the title is printed
\renewcommand\maketitle
{
  \thispagestyle{firstpage}
  \begingroup
  \hspace{.5em}
  \center
  \sffamily\bfseries\Large\@hwtitle
  \endcenter
  \endgroup
}
% The title is printed automatically, no need to type \maketitle manually
\AtBeginDocument{\maketitle}


%%%%%%%%%%%%%%%%%
% Miscellaneous %
%%%%%%%%%%%%%%%%%

\RequirePackage{lmodern}            % Use the Latin Modern font
\RequirePackage[utf8]{inputenc}     % Use UTF-8 encoding
\RequirePackage[T1]{fontenc}        % Use Type 1 fonts
\RequirePackage{microtype}          % Microtypography package

% Insert hyperlinks to internal or external links
\RequirePackage[bookmarks=true, hidelinks]{hyperref}

% Add student name and homework title to the PDF document metadata
\AtBeginDocument{
  \hypersetup{
    pdfauthor={\@name},
    pdftitle={\@hwtitle},
  }
}

% Mathematics packages
\RequirePackage{amsmath, amsthm, amssymb}
\RequirePackage{mathtools}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Problem, parts, solution, and claim environments %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Problem environment
\ifHW@boxes
  \RequirePackage{framed}
\fi
\theoremstyle{definition}
\newtheorem{@problem}{\sffamily\@problemname}
\numberwithin{equation}{@problem}
\numberwithin{table}{@problem}
\numberwithin{figure}{@problem}
\newenvironment{problem}[1][]
{
  \ifHW@boxes
    \framed
    \vspace{-1.5ex}
  \fi
  \def\@arg{#1}
  \ifx\@arg\empty
    \@problem
  \else
    \@problem[\normalfont\@arg\sffamily]
  \fi
  \pdfbookmark{\@problemname\ \arabic{@problem}}{\arabic{@problem}}
}
{
  \end@problem
  \ifHW@boxes
    \vspace{-1.5ex}
    \endframed
  \fi
}

% Problems are numbered 1, 2, 3, ... by default
% If a custom problem number is desired for a particular problem, use the
% following macro before the problem.
\def\problemnumber#1{\setcounter{@problem}{#1}\addtocounter{@problem}{-1}}

% Parts environment
% By default, parts are labeled by lowercase letters.
% The parts environment provides options for other labels:
% `a' (default) lowercase letters
% `A' uppercase letters
% `r' lowercase Roman numerals
% `R' uppercase Roman numerals
% `n' numbers
\RequirePackage{enumitem}

% Define parts environment option actions
\@namedef{partlabel@a}{\def\@partlabel{\textup{(\alph*)}}}
\@namedef{partlabel@A}{\def\@partlabel{\textup{(\Alph*)}}}
\@namedef{partlabel@r}{\def\@partlabel{\textup{(\roman*)}}}
\@namedef{partlabel@R}{\def\@partlabel{\textup{(\Roman*)}}}
\@namedef{partlabel@n}{\def\@partlabel{\textup{(\arabic*)}}}

% Actual parts environment
\newenvironment{parts}[1][a]
{
  % Process option (default is `a')
  \@ifundefined{partlabel@#1}
  {
    \@latex@error{Invalid parts environment option: #1}\@ehc
  }
  {
    \@nameuse{partlabel@#1}
  }
  \renewcommand\part\item
  \ % Make the list always starts on a new line
  \enumerate
  [ label=\@partlabel,
  , itemsep=1pt
  , parsep=1pt
  , topsep=0pt
  , partopsep=100pt
  , labelindent=0pt
  , labelwidth=4.5em
  , labelsep=0.5em
  , resume
  ]
}
{
  \endenumerate
}
\def\unresume{\setcounter{enumi}{0}}

% Solution environment
\ifHW@hidesolutions
  % Hide solutions if the `hidesolutions' class option is enabled
  \RequirePackage{comment}
  \excludecomment{solution}
\else
  % This is a modification of the `proof' environment from the amsthm package
  \newenvironment{solution}[1][\@solutionname]
  {
    \par
    \ifHW@qed
      \pushQED{\qed}
    \else
      \renewcommand\qedhere{}
    \fi
    \normalfont \topsep6\p@\@plus6\p@\relax
    \trivlist
    \item[\hskip\labelsep
          \sffamily\bfseries#1\@addpunct{.}]\ignorespaces
  }
  {
    \ifHW@qed
      \popQED
    \fi
    \endtrivlist\@endpefalse
    \hspace{.5em}
  }
\fi

% 'claim' environment for better organization of claims made within a problem
% solution.
\def\@defaultclaimname{Claim}
\newenvironment{claim}[1][\@defaultclaimname]{
    \begin{quote}
    \textsf{\textbf{#1\@addpunct{.}}}
}
{
    \end{quote}\noindent
}

% Some common alternative uses of the 'claim' environment
\newcommand{\newclaim}[2]{\newenvironment{#1}{\begin{claim}[#2]}{\end{claim}}}
\newclaim{lemma}{Lemma}
\newclaim{proposition}{Proposition}
\newclaim{theorem}{Theorem}
\newclaim{corollary}{Corollary}
\newclaim{remark}{Remark}

% The 'proof' environment is re-defined to serve as a proof environment for
% claims made within a problem
\let\proof\@undefined
\let\endproof\@undefined
\newclaim{proof}{Proof}

% Remove indentation after 'claim' and all the related environments
%\RequirePackage{noindentafter}
% \NoIndentAfterEnv{claim}
% \NoIndentAfterEnv{lemma}
% \NoIndentAfterEnv{proposition}
% \NoIndentAfterEnv{theorem}
% \NoIndentAfterEnv{corollary}
% \NoIndentAfterEnv{remark}
% \NoIndentAfterEnv{proof}

\RequirePackage{cleveref}
\RequirePackage{xspace}

% Macros

\newcommand{\microspace}{\mspace{.5mu}} %
\newcommand{\ket}[1]{\ensuremath{\lvert\microspace#1%
    \microspace\rangle}} %
\newcommand{\bigket}[1]{\bigl\lvert\microspace#1%
  \microspace\bigr\rangle} %
\newcommand{\Bigket}[1]{\Bigl\lvert\microspace#1%
  \microspace\Bigr\rangle} %
\newcommand{\biggket}[1]{\biggl\lvert\microspace#1%
  \microspace\biggr\rangle} %
\newcommand{\Biggket}[1]{ \Biggl\lvert\microspace#1%
  \microspace\Biggr\rangle} %
\newcommand{\bra}[1]{\ensuremath{\langle\microspace#1%
    \microspace\rvert}} %
\newcommand{\bigbra}[1]{\bigl\langle\microspace#1%
  \microspace\bigr\rvert} %
\newcommand{\Bigbra}[1]{\Bigl\langle\microspace#1%
  \microspace\Bigr\rvert} %
\newcommand{\biggbra}[1]{\biggl\langle\microspace#1%
  \microspace\biggr\rvert} %
\newcommand{\Biggbra}[1]{\Biggl\langle\microspace#1%
  \microspace\Biggr\rvert} %

\newcommand{\ip}[2]{\ensuremath{\left\langle#1,#2\right\rangle}} % inner product
\newcommand{\norm}[1]{\ensuremath{\left\lVert #1 \right\rVert}} %
\newcommand{\abs}[1]{\ensuremath{\left\lvert #1 \right\rvert}} %
\newcommand{\ceil}[1]{\ensuremath{\left\lceil #1 \right\rceil}} %
\newcommand{\floor}[1]{\ensuremath{\left\lfloor #1 \right\rfloor}} %
\newcommand{\defeq}{\stackrel{\smash{\text{\tiny\rm def}}}{=}} %
\newcommand{\complex}{\mathbb{C}} %
\newcommand{\real}{\mathbb{R}} %
\renewcommand{\natural}{\mathbb{N}} %
\renewcommand{\Re}{\operatorname{Re}} %
\renewcommand{\Im}{\operatorname{Im}} %

\newcommand{\setft}[1]{\mathrm{#1}} %
\newcommand{\Density}{\setft{D}} %
\newcommand{\Pos}{\setft{Pos}} %
\newcommand{\Pd}{\setft{Pd}} %
\newcommand{\Unitary}{\setft{U}} %
\newcommand{\Herm}{\setft{Herm}} %
\newcommand{\Lin}{\setft{L}} %

\newcommand{\poly}{\mathit{poly}} %
\newcommand{\negl}{\mathit{negl}} %
\newcommand{\yes}{\text{yes}} %
\newcommand{\no}{\text{no}} %

\DeclareMathOperator{\tr}{tr} %
\DeclareMathOperator{\Tr}{Tr} %
\DeclareMathOperator{\SWAP}{SWAP} %
\DeclareMathOperator{\CNOT}{CNOT} %
\DeclareMathOperator{\TOFFOLI}{TOFFOLI} %
\DeclareMathOperator*{\argmin}{argmin} %
\DeclareMathOperator*{\argmax}{argmax} %
\DeclareMathOperator{\supp}{supp} %
\DeclareMathOperator{\eig}{eig} %
\def\e{e} % exp
\def\E{\mathop{\mathbb{E}}\displaylimits} % Expectation
\def\H{\mathcal{H}} % Space

\newcommand{\church}[1]{\overline{#1}}
\newcommand{\pair}[2]{\langle#1, #2\rangle}
\newcommand{\tuple}[1]{\langle#1\rangle}
\newcommand{\red}{\rightarrow}
\newcommand{\reds}{\twoheadrightarrow}
\newcommand{\betared}{\rightarrow_{\beta}}
\newcommand{\betareds}{\twoheadrightarrow_{\beta}}
\newcommand{\betaeq}{=_{\beta}}
\newcommand{\betaetared}{\rightarrow_{\beta\eta}}
\newcommand{\betaetareds}{\twoheadrightarrow_{\beta\eta}}
\newcommand{\parared}{\rightarrow_{\|}}
\newcommand{\parareds}{\twoheadrightarrow_{\|}}
\newcommand{\desc}[1]{\langle#1 \rangle}
\renewcommand{\natural}{\mathbb{N}}
\renewcommand{\real}{\mathbb{R}}


\newcommand{\class}[1]{\textup{#1}\xspace} %

\newcommand\TIME{\class{TIME}}
\newcommand\SPACE{\class{SPACE}}
\newcommand\SIZE{\class{SIZE}}
\newcommand\NTIME{\class{NTIME}}
\newcommand\NSPACE{\class{NSPACE}}
\newcommand\BQP{\class{BQP}}
\newcommand\BPP{\class{BPP}}
\newcommand\QMA{\class{QMA}}
\renewcommand\P{\class{P}}
\newcommand\Ppoly{\class{P{/}poly}}
\newcommand\NP{\class{NP}}
\newcommand\NPC{\class{NP}\text{-complete}}
\newcommand\coNP{\class{coNP}}
\newcommand\MA{\class{MA}}
\newcommand\AM{\class{AM}}
\newcommand\QCMA{\class{QCMA}}
\newcommand\EXP{\class{EXP}}
\newcommand\NEXP{\class{NEXP}}
\newcommand\PP{\class{PP}}
\newcommand\GapP{\class{GapP}}
\newcommand\IP{\class{IP}}
\newcommand\QIP{\class{QIP}}
\newcommand\PSPACE{\class{PSPACE}}
\newcommand\MIP{\class{MIP}}
\newcommand\RE{\class{RE}}
\newcommand\QMAM{\class{QMAM}}
\newcommand\PH{\class{PH}}
\renewcommand\L{\class{L}}
\newcommand\NL{\class{NL}}
\newcommand\PPAD{\class{PPAD}}

\newcommand{\problemsty}[1]{\mathrm{#1}}
\newcommand\SELF{\problemsty{SELF}}
\newcommand\HALT{\problemsty{HALT}}
\newcommand\MINTM{\problemsty{MIN}_\text{TM}}
\newcommand\ACCTM{\problemsty{ACC}_\text{TM}}
\newcommand\TQBF{\problemsty{TQBF}}
\newcommand\PAL{\problemsty{PAL}}
\newcommand\LONGPATH{\problemsty{LONGEST\text{-}PATH}}
\newcommand\SHORTPATH{\problemsty{SHORTEST\text{-}PATH}}
\newcommand\HAMPATH{\problemsty{HAMPATH}}
\newcommand\MINCUT{\problemsty{MIN\text{-}CUT}}
\newcommand\MAXFLOW{\problemsty{MAX\text{-}FLOW}}
\newcommand\MAXCUT{\problemsty{MAX\text{-}CUT}}
\newcommand\SAT{\problemsty{SAT}}
\newcommand\PERM{\problemsty{PERMANENT}}
\newcommand\THREESAT{3\text{-}\problemsty{SAT}}
\newcommand\TWOSAT{2\text{-}\problemsty{SAT}}
\newcommand\THREECOL{3\text{-}\problemsty{COLORING}}
\newcommand\CLIQUE{\problemsty{CLIQUE}}
\newcommand\COL{\problemsty{COLORING}}
\newcommand\COMPOSITE{\problemsty{COMPOSITE}}
\newcommand\PRIME{\problemsty{PRIME}}
\newcommand\TSP{\problemsty{TSP}}
\newcommand\VC{\problemsty{VERTEX\text{-}COVER}}
\newcommand\FACTOR{\problemsty{FACTOR}}
