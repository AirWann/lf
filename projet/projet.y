%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

enum exprtyp {pg,xor,or,and,not,plus,moins,fois,int,ident};
enum stmttyp {assign, pv, do, if, skip, break};
int yylex();

void yyerror(char *s)
{
	fflush(stdout);
	fprintf(stderr, "%s\n", s);
}

/***************************************************************************/
/* Data structures for storing a programme.                                */

typedef struct var	// a variable
{
	char *nom;
	int valeur;
    struct var *next;
} var;


typedef struct expr	//expression
{
	enum exprtyp type;          // pg,xor,or,and,not,plus,moins,fois,int,ident
	var *var;                   // pour les ident
	struct expr *left, *right;  // pour les binop
} expr;

typedef struct stmt	// command
{
	enum stmttyp type;	        // ASSIGN, ';', DO, IF, SKIP, BREAK
	var *var;                   // pour assign
	expr *expr;                 // pour assign, if, when
	struct stmt *left, *right;  // pour when, ;
} stmt;

var *program_vars;
stmt *program_stmts;

/* fonction pour créer les structures pendant qu'on parse */

var* make_id (char *s)
{
    var *v = malloc(sizeof(var));
    v->nom = s;
    v->valeur = 0;
}

var* find_id (char *s)
{
    var *v = program_vars;
    while (v && strcmp(v->name,s)) v=v->next;
    if (!v) {yyerror("variable inconnue"); exit(1);}
    return v;
}

expr* make_expr (exprtyp type, var *var, expr *left, expr *right)
{
    expr *e = malloc(sizeof(expr));
    e->type = type;
    e->var = var;
    e->left = left;
    e->right = right;
    return e;
}













%}