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
[a-zA-Z]            {yylval.character = yytext[0]; return caracter;}
[0-9]+              {yylval.num = atoi(yytext); return numar;}
[ \t]               ;
[/n]                  {yylineno++;}
[-+=;\/\*,]              {return yytext[0];}
.                   {ECHO; yyerror("caracter invalid");}

%%

int yywrap (void) {return 1;}