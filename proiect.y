%{
    void yyerror (char *s);
    int yylex();
    #include <stdio.h>
    #include <stdlib.h>
    #include <ctype.h>
    int symbols[52];
    int getVal(char symbol);
    void updateVali(char symbol, int val);
    void updateValc(char symbol, int val);
    int checkVal(char symbol);
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
%token TIP BEGN END IF THEN ELSE EIF WHILE DO EQ NEQ LE ME INT CHAR MAIN CLASS BR BL COMMENT ACCES
%token <num> numar
%token <character> caracter caractere
%type <num> expresie termen
%type <character> asignare
%type <num> comparatie
%type <num> operatie
%left EQ LE ME NEQ
%left '+''-'
%left '*''/'
%%

program : declaratii functions class functions inmain bloc   {printf("Compilare reusita\n");}
        ;

declaratii : declaratie ';' 
            | declaratii declaratie ';'
            | declaratie ',' declaratii
            ;

inmain      : MAIN
            | MAIN declaratii
            | MAIN functions
            ;

class      : CLASS caractere bloc
            |
            ;

declaratie: TIP caracter       {if(checkVal($2)) {yyerror("Variabila deja in uz."); exit(1);}
                                    else if(TIP==numar) updateVali($2, -1);
                                        else updateValc($2, -1);}
            ;
            
functions   : TIP caractere BL parametrii BR bloc
            | TIP caractere BL BR bloc
            |
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


linie   : asignare                      
            | exit_command              {exit(EXIT_SUCCESS);}
            | print expresie ', ' INT            {if($2!=0) printf("%d\n", $2);
                                                    else {yyerror("Variabila este nedeclarata."); exit(1);}}  
            | print expresie ', ' CHAR            {if($2!=0) printf("%c\n", $2);
                                                    else {yyerror("Variabila este nedeclarata."); exit(1);}}                          
            | linie asignare            
            | linie print expresie      {printf("%d", $3);}
            | linie exit_command        {exit(EXIT_SUCCESS);}
            | comparatie
            | operatie
            ;

operatie : IF linie
            | THEN linie
            | ELSE linie
            | EIF linie
            | WHILE linie
            | DO linie
            ;

comparatie: termen {$$=$1;}
            | comparatie EQ comparatie {($1==$3)?($$=true):($$=false);}
            | comparatie NEQ comparatie {($1!=$3)?($$=true):($$=false);}
            | comparatie '<' comparatie {if($1<$3) $$=true; else $$=false;}
            | comparatie '>' comparatie {($1>$3)?($$=true):($$=false);}
            | comparatie LE comparatie {($1<=$3)?($$=true):($$=false);}
            | comparatie ME comparatie {($1>=$3)?($$=true):($$=false);}
            ;


asignare: caracter '=' expresie         {updateVali($1, $3);}
            | caracter '=' caracter     {updateValc($1, $3);}
            | caractere ACCES asignare
            ;

expresie: termen                        {$$=$1;}
            | expresie '+' termen       {$$=$1+$3;}
            | expresie '-' termen       {$$=$1-$3;}
            | expresie '*' termen       {$$=$1*$3;}
            | expresie '/' termen        {if($3==0) {yyerror("Impartirea la 0 nu are sens"); exit(1);}
                                        else $$=$1/$3;}
            ;

termeni : termen
            | termeni ',' termen
            ;

termen  : numar
            | caracter                      {$$=getVal($1);}
            | caractere ACCES termen
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

int getVal(char symbol)
{
	int bucket = computeSymbolIndex(symbol);
	return symbols[bucket];
}

void updateVali(char symbol, int val)
{
	int bucket = computeSymbolIndex(symbol);
	symbols[bucket] = val;
}

void updateValc(char symbol, int val)
{
    char c=val;
	int bucket = computeSymbolIndex(symbol);
	symbols[bucket] = val;
}
int checkVal(char symbol)
{
    int bucket = computeSymbolIndex(symbol);
    return symbols[bucket];
}

int main(int argc, char** argv){
	int i;
	for(i=0; i<52; i++) {
		symbols[i] = 0;
	}
    yyin=fopen(argv[1],"r");
	return yyparse ( );
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);
printf("La linia %d\n", yylineno);} 