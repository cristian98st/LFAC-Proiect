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
    #define true 1
    #define false 0
%}

%union {int num; char character;}
%start program
%token print
%token exit_command
%token TIP BEGN END IF THEN ELSE WHILE DO EQ NEQ LE ME
%token <num> numar
%token <character> caracter
%type <num> linie expresie termen
%type <character> asignare
%type <num> comparatie
%left EQ LE ME NEQ
%left '+''-'
%left '*''/'
%%

program : declaratii bloc   {printf("Compilare reusita\n");}
        ;

declaratii : declaratie ';'
            | declaratii declaratie ';'
            | declaratie ',' declaratii
            ;

declaratie: TIP caracter
            | TIP caracter '(' parametrii ')'
            | TIP caracter '(' ')'
            ;

parametrii: parametru
            | parametrii ',' parametru
            ;

parametru: TIP caracter
            ;

bloc    : BEGN instructiuni END
            ;

instructiuni: linie ';'
            | instructiuni linie ';'
            ;

operations  :operations operatie linie  {;}
            |operations linie operatie  {;}
            |operatie linie             {;}
            |linie operatie             {;}
            |operatie                   {;}
            |linie                      {;}
            ;

linie   : asignare                      {;}
            | exit_command              {exit(EXIT_SUCCESS);}
            | print expresie            {printf("%d", $2);}
            | operatie                  {;}
            | linie asignare            {;}
            | linie print expresie      {printf("%d", $3);}
            | linie exit_command        {exit(EXIT_SUCCESS);}
            | linie operatie            {;}
            ;

operatie: if_block
            | while_block
            ;

if_block: IF comparatie THEN bloc ELSE bloc 
            | IF comparatie THEN bloc       
            ;

while_block: WHILE comparatie DO bloc       
            ;

comparatie: termen {$$=$1;}
            | comparatie EQ comparatie {($1==$3)?($$=true):($$=false);}
            | comparatie NEQ comparatie {($1!=$3)?($$=true):($$=false);}
            | comparatie '<' comparatie {($1<$3)?($$=true):($$=false);}
            | comparatie '>' comparatie {($1>$3)?($$=true):($$=false);}
            | comparatie LE comparatie {($1<=$3)?($$=true):($$=false);}
            | comparatie ME comparatie {($1>=$3)?($$=true):($$=false);}
            ;


asignare: caracter '=' expresie         {updateVal($1, $3);}
            | caracter '=' caracter     {updateVal($1, getVal($3));}
            ;

expresie: termen                        {$$=$1;}
            | expresie '+' termen       {$$=$1+$3;}
            | expresie '-' termen       {$$=$1-$3;}
            | expresie '*' termen       {$$=$1*$3;}
            | expresie '/' termen       {if($3==0) {yyerror("Impartirea la 0 nu are sens");}
                                        else $$=$1/$3;}
            ;

termeni : termen
            | termeni ',' termen
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

void yyerror (char *s) {fprintf (stderr, "%s\n", s);
printf("La linia %d\n", yylineno);} 