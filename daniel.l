%{
    #include <stdio.h>
    #include "y.tab.h"
    void yyerror (char *s);
    int yylex();
%}
%%
"afiseaza"          {return print;}
"termina"           {return exit_command;}
"return"			{return return;}
"define"			{return define;}
"class "[a-zA-Z]+	{return class_definition;}
"public"			{return acces_specifier;}
"private"			{return acces_specifier;}
"protected"			{return acces_specifier;}
"int "[a-zA-Z]+		{return function_definition;}
"char "[a-zA-Z]+	{return function_definition;}
"bool "[a-zA-Z]+	{return function_definition;}
"float "[a-zA-Z]+	{return function_definition;}
"int main"			{return main_definition;}
"void main"			{return main_definition;}
[a-zA-Z]            {yylval.character = yytext[0]; return caracter;}
[0-9]+              {yylval.num = atoi(yytext); return numar;}
[ \t\n]             ;
[-+=;\/\*{}:<>]       {return yytext[0];}
.                   {ECHO; yyerror("caracter invalid");}

%%
 
int yywrap (void) {return 1;}