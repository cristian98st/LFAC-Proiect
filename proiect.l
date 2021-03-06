%{
    #include <stdio.h>
    #include "y.tab.h"
    void yyerror (char *s);
    int yylex();
%}
%%
"numar"|"caracter"|"cuvant" {return TIP;}
"incepe" {return BEGN;}
"sfarsit" {return END;}
"afiseaza"          {return print;}
"termina"           {return exit_command;}
"daca"              {return IF;}
"atunci"            {return THEN;}
"acad"             {return EIF;}
"altfel"            {return ELSE;}
"cattimp"           {return WHILE;}
"executa"           {return DO;}
"main"              {return MAIN;}
"clasa"             {return CLASS;}
"=="                {return EQ;}
"!="                {return NEQ;}
"<="                {return LE;}
"=<"                {return LE;}
">="                {return ME;}
"=>"                {return ME;}
"%i"                {return INT;}
"%c"                {return CHAR;}
"->"                {return ACCES;}
[(]                 {return BL;}
[)]                 {return BR;}
[A-Z]*              {return caractere;}
[a-zA-Z]            {yylval.character = yytext[0]; return caracter;}
[0-9]+              {yylval.num = atoi(yytext); return numar;}
[ \t]               ;
[\n]                  {yylineno++;}
[-+=;*,<>/]              {return yytext[0];}
.                   {ECHO; yyerror("caracter invalid");}

%%

int yywrap (void) {return 1;}