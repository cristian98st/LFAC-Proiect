%{
    void yyerror (char *s);
    int yylex();
    #include <stdio.h>
    #include <stdlib.h>
    #include <ctype.h>
    int symbols[52];
    int getVal(char symbol);
    void updateVal(char symbol, int val);
    extern FILE* yyin;
    extern char* yytext;
    extern int yylineno;
%}
%union {int num; char character;}
%start program
%token print
%token exit_command
%token return
%token define
%token class_definition
%token acces_specifier
%token function_definition
%token <num> numar
%token <character> caracter
%type <num> linie expresie termen
%type <character> asignare
%%
program :defines classes functions main
        |defines functions main
        |classes functions main
        |defines classes main
        |defines main
        |classes main
        |functions main
        |main
        ;

defines :defines define
        |define
        ;

classes :classes class
        |class
        ;
functions   :functions function
            |function
            ;

class   :class_definition '{' acces_specifier ':' linie functions '}' ';'
        ;

function    :function_definition '(' parameters ')' '{' linie operations return termen '}'
            |function_definition '('  ')' '{' linie operations return termen '}'
            ;

parameters  :parameters termen
            |termen
            ;

operations  :operations operatie linie
            |operations linie operatie
            |operatie linie
            |linie operatie
            |operatie
            |linie
            ;

main    :main_definiton '(' parameters ')' '{' linie operations return termen '}'
        |main_definiton '('  ')' '{' linie operations return termen '}'
        ; 




linie   : asignare ';'                  {;}
            | exit_command ';'          {exit(EXIT_SUCCESS);}
            | print expresie ';'        {printf("%d\n", $2);}
            | linie asignare ';'        {;}
            | linie print expresie ';'  {printf("%d\n", $3);}
            | linie exit_command ';'    {exit(EXIT_SUCCESS);}
            ;

asignare: caracter '=' expresie         {updateVal($1, $3);}

expresie: termen                        {$$=$1;}
            | expresie '+' termen       {$$=$1+$3;}
            | expresie '-' termen       {$$=$1-$3;}
            | expresie '*' termen       {$$=$1*$3;}
            | expresie '/' termen       {if($3==0) {yyerror("Impartirea la 0 nu are sens");}
                                        else $$=$1/$3;}
            ;

termen  : numar
            | caracter                      {$$=getVal($1);}
            ;

%%

int computeSymbolIndex(char token)
{
	int idx = -1;
	if(islower(token)) {
		idx = token - 'a' + 26;
	} else if(isupper(token)) {
		idx = token - 'A';
	}
	return idx;
} 

/* returns the value of a given symbol */
int getVal(char symbol)
{
	int bucket = computeSymbolIndex(symbol);
	return symbols[bucket];
}

/* updates the value of a given symbol */
void updateVal(char symbol, int val)
{
	int bucket = computeSymbolIndex(symbol);
	symbols[bucket] = val;
}

int main(int argc, char** argv){
	/* init symbol table */
	int i;
	for(i=0; i<52; i++) {
		symbols[i] = 0;
	}
    yyin=fopen(argv[1],"r");
	return yyparse ( );
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 