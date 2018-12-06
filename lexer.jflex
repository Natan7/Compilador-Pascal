package cup.example;
import java_cup.runtime.ComplexSymbolFactory;
import java_cup.runtime.ComplexSymbolFactory.Location;
import java_cup.runtime.Symbol;
import java_cup.runtime.Scanner;
import java.lang.*;
import java.io.InputStreamReader;

%%

%class Lexer
%implements sym
%public

%unicode
%line
%column

%cup
%char

%{
	

    public Lexer(ComplexSymbolFactory sf, java.io.InputStream is){
		this(is);
        symbolFactory = sf;
    }
	public Lexer(ComplexSymbolFactory sf, java.io.Reader reader){
		this(reader);
        symbolFactory = sf;
    }
    
    private StringBuffer sb;
    private ComplexSymbolFactory symbolFactory;
    private int csline,cscolumn;

    public Symbol symbol(String name, int code){
		return symbolFactory.newSymbol(name, code,
						new Location(yyline+1,yycolumn+1, yychar), // -yylength()
						new Location(yyline+1,yycolumn+yylength(), yychar+yylength())
				);
    }
    
    public Symbol symbol(String name, int code, String lexem){
	return symbolFactory.newSymbol(name, code, 
						new Location(yyline+1, yycolumn +1, yychar), 
						new Location(yyline+1,yycolumn+yylength(), yychar+yylength()), lexem);
    }
    
    protected void emit_warning(String message){
    	System.out.println("Scanner warning: " + message + " at : 2 "+ 
    			(yyline+1) + " " + (yycolumn+1) + " " + yychar);
    }
    
    protected void emit_error(String message){
    	System.out.println("Scanner error: " + message + " at : 2" + 
    			(yyline+1) + " " + (yycolumn+1) + " " + yychar);
    }
%}

%eof{
%eof}

Digit      = [0-9]
Letter     = [a-zA-Z]

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

nQuote     = [^']
Newline    = \r | \n | \r\n
Whitespace = [ \t\f] | {Newline}

/* ========== Comentarios Pascal ========== */

leftBrace       = \{
rightBrace      = \}
nonRightBracket   = [^}]
commentContent    = ( [^*] | \*+[^*/] )*
comment           = {leftBrace}{commentContent}{rightBrace}

keywordExternal  = {E}{X}{T}{E}{R}{N} | {E}{X}{T}{E}{R}{N}{A}{L}
stringChar       = '({nQuote}|'')+'

%eofval{
    return symbolFactory.newSymbol("EOF",sym.EOF);
%eofval}

%%  

<YYINITIAL> {

  [ \n\t\r]+       { }
  [/][/].*?[\n]    { }
  {Whitespace} {                              }
  
  ''''|'[^']'      { return symbolFactory.newSymbol("CHAR_CONST", CHAR_CONST); }
  /*"true"|"false"   { return symbolFactory.newSymbol("BOOL_CONST", BOOL_CONST); }*/
  '({nQuote}|'')*' { return symbolFactory.newSymbol("STRING_CHAR", STRING_CHAR);}
  "nil"            { return symbolFactory.newSymbol("NIL", NIL); }
  "true"           { return symbolFactory.newSymbol("TRUE", TRUE); }
  "false"   { return symbolFactory.newSymbol("FALSE", FALSE); }
  
  /* TIPOS DE DADOS */
  "array"          { return symbolFactory.newSymbol("ARRAY", ARRAY); }
  "boolean"        { return symbolFactory.newSymbol("BOOLEAN", BOOLEAN); }
  "char"           { return symbolFactory.newSymbol("CHAR", CHAR); }
  "integer"        { return symbolFactory.newSymbol("INTEGER", INTEGER); }
  "object"         { return symbolFactory.newSymbol("OBJECT", OBJECT); }
  "record"         { return symbolFactory.newSymbol("RECORD", RECORD); }
  "string"         { return symbolFactory.newSymbol("STRING", STRING); }

  /* OUTRAS PALAVRAS RESERVADAS DO PASCAL */
  "asm"            { return symbolFactory.newSymbol("ASM", ASM); }
  "constructor"    { return symbolFactory.newSymbol("CONSTRUCTOR", CONSTRUCTOR); }
  "destructor"     { return symbolFactory.newSymbol("DESTRUCTOR", DESTRUCTOR); }
  "downto"         { return symbolFactory.newSymbol("DOWNTO", DOWNTO); }
  "file"           { return symbolFactory.newSymbol("FILE", FILE); }
  "foward"         { return symbolFactory.newSymbol("FOWARD", FOWARD); }
  "goto"           { return symbolFactory.newSymbol("GOTO", GOTO); }
  "implementation" { return symbolFactory.newSymbol("IMPLEMENTATION", IMPLEMENTATION); }
  "in"             { return symbolFactory.newSymbol("IN", IN); }
  "inline"         { return symbolFactory.newSymbol("INLINE", INLINE); }
  "interface"      { return symbolFactory.newSymbol("INTERFACE", INTERFACE); }
  "label"          { return symbolFactory.newSymbol("LABEL", LABEL); }
  "packed"         { return symbolFactory.newSymbol("PACKED", PACKED); }
  "repeat"         { return symbolFactory.newSymbol("REPEAT", REPEAT); }
  "set"            { return symbolFactory.newSymbol("SET", SET); }
  "shl"            { return symbolFactory.newSymbol("SHL", SHL); }
  "shr"            { return symbolFactory.newSymbol("SHR", SHR); }
  "unit"           { return symbolFactory.newSymbol("UNIT", UNIT); }
  "until"          { return symbolFactory.newSymbol("UNTIL", UNTIL); }
  "uses"           { return symbolFactory.newSymbol("USES", USES); }
  "with"           { return symbolFactory.newSymbol("WITH", WITH); }
  
  /* OPERADORES ARITMETICOS */
  "+"              { return symbolFactory.newSymbol("PLUS", PLUS); }             /* Adição */
  "-"              { return symbolFactory.newSymbol("MINUS", MINUS); }           /* Subtração */
  "*"              { return symbolFactory.newSymbol("TIMES", TIMES); }           /* Multiplicação */
  "/"              { return symbolFactory.newSymbol("DIV", DIV); }               /* Divisão real*/
  "div"            { return symbolFactory.newSymbol("DIVINT", DIVINT); }         /* Divisão inteira (truncada) */
  "mod"            { return symbolFactory.newSymbol("MOD", MOD); }               /* Resto da divisão inteira */
  "^"              { return symbolFactory.newSymbol("PTR", PTR); } 
  
  /* OPERADORES RELACIONAIS */
  ">"              { return symbolFactory.newSymbol("GTH", GTH); }               /* MAIOR QUE - GREATER THAN */
  "<"              { return symbolFactory.newSymbol("LTH", LTH); }               /* MENOR QUE - LESS THAN */
  ">="             { return symbolFactory.newSymbol("GEQ", GEQ); }               /* MAIOR OU IGUAL - GREATER THAN OR EQUAL TO */
  "<="             { return symbolFactory.newSymbol("LEQ", LEQ); }               /* MENOR OU IGUAL - LESS THAN OR EQUAL TO */
  "<>"             { return symbolFactory.newSymbol("NEQ", NEQ); }  			 /* DIFERENTE - NOT EQUAL */
  "="              { return symbolFactory.newSymbol("EQU", EQU); }  			 /* IGUAL - EQUAL */
  
  /* OPERADORES LOGICOS */
  "and"            { return symbolFactory.newSymbol("AND", AND); }
  "or" | "|"       { return symbolFactory.newSymbol("OR", OR); }
  "not"            { return symbolFactory.newSymbol("NOT", NOT); }
  "xor"            { return symbolFactory.newSymbol("XOR", XOR); }
  
  "var"            { return symbolFactory.newSymbol("VAR", VAR); }
  "const"          { return symbolFactory.newSymbol("CONST", CONST); }
  ".."             { return symbolFactory.newSymbol("DOTS", DOTS); }
  "of"             { return symbolFactory.newSymbol("OF", OF); }
  "type"           { return symbolFactory.newSymbol("TYPE", TYPE); }
  
  "begin"	       { return symbolFactory.newSymbol("BEGIN", BEGIN); }
  "end"            { return symbolFactory.newSymbol("END", END); }
  
  "if"             { return symbolFactory.newSymbol("IF", IF); }
  "then"           { return symbolFactory.newSymbol("THEN", THEN); }
  "else"           { return symbolFactory.newSymbol("ELSE", ELSE); }
  "for"            { return symbolFactory.newSymbol("FOR", FOR); }
  "to"             { return symbolFactory.newSymbol("TO", TO); }
  "do"             { return symbolFactory.newSymbol("DO", DO); }
  "while"          { return symbolFactory.newSymbol("WHILE", WHILE); }
  "case"		   { return symbolFactory.newSymbol("CASE", CASE); }
  
  "function"       { return symbolFactory.newSymbol("FUNCTION", FUNCTION); }
  "procedure"      { return symbolFactory.newSymbol("PROCEDURE", PROCEDURE); }
  "program"        { return symbolFactory.newSymbol("PROGRAM", PROGRAM); }
  
  /* Operador de atribuição */
  ":="             { return symbolFactory.newSymbol("ASSIGN", ASSIGN); } 
  
  /* Separadores */
  ":"              { return symbolFactory.newSymbol("COLON", COLON); } 
  ";"              { return symbolFactory.newSymbol("SEMICOLON", SEMICOLON); }           
  ","              { return symbolFactory.newSymbol("COMMA", COMMA); }
  "."              { return symbolFactory.newSymbol("DOT", DOT); }
  "["              { return symbolFactory.newSymbol("LBRACKET", LBRACKET); }
  "]"              { return symbolFactory.newSymbol("RBRACKET", RBRACKET); }
  "("              { return symbolFactory.newSymbol("LPARENTHESIS", LPARENTHESIS); }
  ")"              { return symbolFactory.newSymbol("RPARENTHESIS", RPARENTHESIS); }  
  "'"              { return symbolFactory.newSymbol("SINGLEQUOTE", SINGLEQUOTE); }
  \"               { return symbolFactory.newSymbol("DOUBLEQUOTE", DOUBLEQUOTE); }
  
  {E}			   { return symbolFactory.newSymbol("SCALEFACTOR", SCALEFACTOR); }
  
  Letter           { return symbolFactory.newSymbol("LETTER", LETTER); }
  
  {Digit}+         { return symbolFactory.newSymbol("DIGIT", DIGIT, Integer.parseInt(yytext())); }
  /*[a-zA-Z][a-zA-Z0-9_]*    { return symbolFactory.newSymbol("IDENTIFIER", IDENTIFIER); } */
  {Letter} ({Letter}|Digit})* {return symbolFactory.newSymbol("IDENTIFIER", IDENTIFIER, new String(yytext())); }
  {comment}        { System.out.println("Comment: " + yytext()); }
  
  {keywordExternal} { return symbolFactory.newSymbol("EXTERNAL", EXTERNAL); }
   
  

}

// error fallback
.|\n          { emit_warning("Unrecognized character '" +yytext()+"' -- ignored"); }

<<EOF>> { return symbolFactory.newSymbol("EOF", EOF); }
