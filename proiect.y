%{
    void yyerror (char *s);
    int yylex();
    #include <stdio.h>
    #include <stdlib.h>
    #include <ctype.h>
    int symbols[52];
    int symbolVal(char symbol);
    void updateSymbolVal(char symbol, int val);
%}

%union {int num; char character;}
%start linie
%token print
%token exit_command
%token <num> numar
%token <character> caracter
%type <num> linie expresie termen
%type <character> asignare
%%

linie   : asignare ';'                  {;}
            | exit_command ';'          {exit(EXIT_SUCCESS);}
            | print expresie ';'        {printf("%d\n", $2);}
            | linie asignare ';'        {;}
            | linie print expresie ';'  {printf("%d\n", $3);}
            | linie exit_command ';'    {exit(EXIT_SUCCESS);}
            ;

asignare: caracter '=' expresie         {updateSymbolVal($1, $3);}

expresie: termen                        {$$=$1;}
            | expresie '+' termen       {$$=$1+$3;}
            | expresie '-' termen       {$$=$1-$3;}
            | expresie '*' termen       {$$=$1*$3;}
            | expresie "/" termen       {$$=$1/$3;}
            ;

termen  : numar
            | caracter                      {$$=symbolVal($1);}
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
int symbolVal(char symbol)
{
	int bucket = computeSymbolIndex(symbol);
	return symbols[bucket];
}

/* updates the value of a given symbol */
void updateSymbolVal(char symbol, int val)
{
	int bucket = computeSymbolIndex(symbol);
	symbols[bucket] = val;
}

int main (void) {
	/* init symbol table */
	int i;
	for(i=0; i<52; i++) {
		symbols[i] = 0;
	}

	return yyparse ( );
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 