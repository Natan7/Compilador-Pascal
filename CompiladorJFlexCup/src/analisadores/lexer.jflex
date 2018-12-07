/*------------- 1a Area: Codigo do Usuario -------------*/
/*--------------> Pacotes, Importacoes <----------------*/
package analisadores;
import java_cup.runtime.*;

/*------------ 2a Area: Opcoes e Declaracoes -----------*/
%%

%{
    /*-------> Codigo do usuario em sintaxe java <------*/

    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }

    private Symbol symbol(int type, Object val) {
        return new Symbol(type, yyline, yycolumn, val);
    }
%}

/*------ Diretivas ---------*/
%class Lexer%public
%cup
%column
%line

/*-------- Expressoes Regulares ------------*/
LineTerminator = \r|\n|\r\n
WhiteSpace     = {LineTerminator} | [ \t\f]

NUM = [0-9]+
IDENT = [A-Za-z_][A-Za-z_0-9]*
STRING = \"([^\\\"]|\\.)*\"
LETTER = [A-Za-z]

leftBrace          = \{
rightBrace         = \}
nonrightbrace      = [^}]
comment_body       = {nonrightbrace}*
comment            = {leftBrace}{comment_body}{rightBrace}

A = [aA]
B = [bB]
C = [cC]
D = [dD]
E = [eE]
F = [fF]
G = [gG]
H = [hH]
I = [iI]
J = [jJ]
K = [kK]
L = [lL]
M = [mM]
N = [nN]
O = [oO]
P = [pP]
Q = [qQ]
R = [rR]
S = [sS]
T = [tT]
U = [uU]
V = [vV]
W = [wW]
X = [xX]
Y = [yY]
Z = [zZ]
NQUOTE = [^']

keyword_external   = {E}{X}{T}{E}{R}{N} | {E}{X}{T}{E}{R}{N}{A}{L}

string_character   = '({NQUOTE}|'')+'

%%

/*------------- 3a Area: Codigo do Usuario -------------*/

<YYINITIAL> {
    /** Keywords. */
    "and"             { return symbol(sym.AND); }
    "or"              { return symbol(sym.OR); }
    "not"             { return symbol(sym.NOT); }
    "true"            { return symbol(sym.TRUE); }
    "false"           { return symbol(sym.FALSE); }

    "program"         { return symbol(sym.PROGRAM); }
    "begin"           { return symbol(sym.BEGIN); }
    "end"             { return symbol(sym.END); }
    "exit"            { return symbol(sym.EXIT); }
    "if"              { return symbol(sym.IF); }
    "then"            { return symbol(sym.THEN); }
    "else"            { return symbol(sym.ELSE); }
    "while"           { return symbol(sym.WHILE); }
    "do"              { return symbol(sym.DO); }

    "writeln"         { return symbol(sym.WRITELN); }

    ":="              {return symbol(sym.ASSIGN); }
    "="               { return symbol(sym.EQ); }
    "<"               { return symbol(sym.LT); }
    "<="              { return symbol(sym.LE); }
    ">"               { return symbol(sym.GT); }
    ">="              { return symbol(sym.GE); }
    "<>"              { return symbol(sym.NE); }

    "-"   { return symbol(sym.MINUS); }
    "+"   { return symbol(sym.PLUS); }
    "/"   { return symbol(sym.DIV); }
    "*"   { return symbol(sym.TIMES); }
    "mod" { return symbol(sym.MOD); }
    ":"   { return symbol(sym.COLON); }
    ".."  { return symbol(sym.DOUBLEDOT); }
    "in"  { return symbol(sym.IN); }
    "^"   { return symbol(sym.CIRCUNFLEX); }
    "'"   { return symbol(sym.SINGLEQUOTE); }
    \"	  { return symbol(sym.DOUBLEQUOTE); }

    "(" { return symbol(sym.LPARENT); }
    ")" { return symbol(sym.RPARENT); }
    "[" { return symbol(sym.LBRACKET); }
    "]" { return symbol(sym.RBRACKET); }
    ";" { return symbol(sym.SEMI); }
    "," { return symbol(sym.COMMA); }
    "." { return symbol(sym.DOT); }

    "program" { return symbol(sym.PROGRAM); }
    "label" { return symbol(sym.LABEL); }
    "const" { return symbol(sym.CONST); }
    "type" { return symbol(sym.TYPE); }
    "var" { return symbol(sym.VAR); }
    "forward" { return symbol(sym.FORWARD); }
    "begin" { return symbol(sym.BEGIN); }
    "end" { return symbol(sym.END); }
    "packed" { return symbol(sym.PACKED); }
    "of" { return symbol(sym.OF); }
    "while" { return symbol(sym.WHILE); }
    "do" { return symbol(sym.DO); }
    "to" { return symbol(sym.TO); }
    "then" { return symbol(sym.THEN); }
    "case" { return symbol(sym.CASE); }
    "with" { return symbol(sym.WITH); }
    "nil" { return symbol(sym.NIL); }
    "not" { return symbol(sym.NOT); }
    "div" { return symbol(sym.DIVEXTENSION); }
    "or" { return symbol(sym.OR); }
    "and" { return symbol(sym.AND); }
    "record" { return symbol(sym.RECORD); }
    "set" { return symbol(sym.SET); }
    "file" { return symbol(sym.FILE); }
    "true" { return symbol(sym.TRUE); }
    "false" { return symbol(sym.FALSE); }

    '({NQUOTE}|'')*' {return symbol(sym.STRINGCHARACTER);}
    {E} { return symbol(sym.SCALEFACTOR); }
    {keyword_external}	{return symbol(sym.EXTERNAL);}

    {NUM}         { return symbol(sym.NUM, new Integer(yytext())); } //DIGITSEQUENCE
    {IDENT}       { return symbol(sym.IDENTIFIER, new String(yytext()));}
    {STRING}      { return symbol(sym.STRING, new String(yytext())); }
    LETTER        { return symbol(sym.LETTER); }

    {comment}     { System.out.println("Comment: " + yytext()); }

    {WhiteSpace}       { /* do nothing */ }   
    <<EOF>> { return symbol(sym.EOF); }
}

/* error */ 
[^]                    { throw new Error("Illegal character <"+yytext()+">"); }