%{
#include <stdio.h>
#include <ctype.h>
#include <math.h>
#include <string.h>
char *argval;
%}

%token NUMBER
%token NUMBERi
%union {
        double val;
        char op;
        int vali;}

%type <val> exp term term2 term3 term4 factor NUMBER
%type <op> '+' '-' '*' '/' '^' '%' '(' ')'
%type <vali> expi termi term2i term3i term4i factori NUMBERi

%%



command : exp	{printf("%lf\n",$1);}
        | expi  {printf("%d\n",$1);}
	;

exp	: exp '+' term	{$$ = $1 + $3;}
	| exp "-" term	{$$ = $1 - $3;}
        | '-' term      {$$ = -$2;} 
	| term	{$$ = $1;}
	;

term	: term '*' term2	{$$ = $1 * $3;}
	| term2 	{$$ = $1;}
	;

term2	: term2 '/' term3 	{$$ = $1 / $3;}
        | term3                 {$$ = $1;}
	;

term3   : term4 '^' term3       {$$ = pow($1,$3);}
        | term4                 {$$ = $1;}
	;

term4   : term4 '%' factor      {$$ = ((int) $1 %(int) $3);}
	| factor 	{$$ = $1;}
 	;

factor  : NUMBER 	{$$ = $1;}
        |'(' exp ')'    {$$ = $2;}
	;

expi    : expi '+' termi        {$$ = $1 + $3;}
        | expi '-' termi        {$$ = $1 - $3;}
        | '-' termi      {$$ = -$2;}
        | termi {$$ = $1;}
        ;

termi   : termi '*' term2i        {$$ = $1 * $3;}
        | term2i         {$$ = $1;}
        ;

term2i  : term2i '/' term3i       {$$ = $1 / $3;}
        | term3i                 {$$ = $1;}
        ;

term3i  : term4i '^' term3i       {$$ = pow($1,$3);}
        | term4i                 {$$ = $1;}
        ;

term4i  : term4i '%' factori      {$$ = ((int) $1 %(int) $3);}
        | factori        {$$ = $1;}
        ;

factori : NUMBERi        {$$ = $1;}
        |'(' expi ')'    {$$ = $2;}
        ;

%%
main(int argc, char *argv[])
{
        argval = argv[1];
        return yyparse();
}
int yylex(void)
{
         int c;
        while((c = getchar()) == ' ')   ;      /* delete all spaces */
        if(strcmp(argval, "-i")==0){
                if ( isdigit(c) ) {
                        ungetc(c, stdin);                 /* put c back */
                        scanf("%d",&yylval);
                        return(NUMBERi);
                }
        }
        if(strcmp(argval, "-f")==0){
                if ( isdigit(c)|| c=='.' ) {
                        ungetc(c, stdin);                 /* put c back */
                        scanf("%lf",&yylval);
                        return(NUMBER);
                }
        }
  if ( c == '\n') return 0;
        return(c);
}
int yyerror(char * s)
{ fprintf(stderr,"%s\n",s);
  return 0;
}

