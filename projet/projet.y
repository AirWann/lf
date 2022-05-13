%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

enum exprtyp {Pg,Xor,Or,And,Not,Plus,Moins,Fois,Int,Ident};
enum stmttyp {Assign, Pv, Do, If, Skip, Break};
enum choicetyp {Choice, Else}
int yylex();

void yyerror(char *s)
{
	fflush(stdout);
	fprintf(stderr, "%s\n", s);
}

/***************************************************************************/
/* Data structures for storing a programme.                                */

typedef struct var	// une variable
{
	char *nom;
	int valeur;
} var;

typedef struct varlist // liste de variables
{
    var *var;
    struct varlist *next;
} varlist;

typedef struct expr	// expression
{
	enum exprtyp type;          // pg,xor,or,and,not,plus,moins,fois,int,ident
	var *var;                   // pour les ident
	struct expr *left, *right;  // pour les binop
} expr;

typedef struct stmt	// commande
{
	enum stmttyp type;	        // ASSIGN, ';', DO, IF, SKIP, BREAK
	var *var;                   // pour assign
	expr *expr;                 // pour assign, if, when
	struct stmt *left, *right;  // pour when, ;
} stmt;

typedef struct choice
{
    enum choicetyp type;
    expr *cond;
    stmt *commande;
} choice;

typedef struct spec
{
    expr *expr;
    struct spec *next;
} spec;

typedef struct proc
{
    char *name;
    struct stmt *commande;
    struct proc *next;
    struct varlist *vars;

} proc ;


varlist *program_vars;
proc *program_procs;
spec *program_specs;
/* fonction pour créer les structures pendant qu'on parse */

var* make_id (char *s)
{
    var *v = malloc(sizeof(var));
    v->nom = s;
    v->valeur = 0;
    return v;
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

stmt* make_stmt (stmttyp type, var *var, expr *expr, stmt *right, stmt *left)
{
    stmt *s = malloc(sizeof(stmt));
	s->type = type;
	s->var = var;
	s->expr = expr;
	s->left = left;
	s->right = right;
	return s;
}

choice* make_choice (choicetyp type, expr *cond, stmt *commande)
{
    choice *c = malloc(sizeof(choice));
    c->type = type;
    c->cond = cond;
    c->commande = commande;
    return c;
}

spec* make_spec (expr *expr)
{
    spec *sp = malloc(sizeof(spec));
    sp->expr = expr;
    sp->next = NULL;
    return sp;
}

proc* make_proc (char *name, varlist *vars, stmt *commande)
{
    proc *p = malloc(sizeof(proc));
    p->name = name;
    p->commande = commande;
    p->next = NULL;
    p->vars = vars;
    return p;
}

%}

/* types pour le yylval */

%union {
    char *i;
    var *v;
    expr *e;
    stmt *s;
    spec *sp;
    proc *p;
}

%type <e> expr
%type <s> stmt assign choice
%type <v> decls
%type <sp> specs
%type <p> procs

%token VAR PROC END DO OD IF FI BREAK REACH SKIP INT ALORS PG PV V CHOIX EQUAL ASSIGN XOR OR AND NOT PLUS MOINS FOIS
%token <i> IDENT

/* TODO priorités */

%%

/* TODO grammaire */

prog    : varlist procs specs                   { program_specs = $3; }

procs   : %empty                                { $$ = NULL; }
    | PROC IDENT varlist stmt END procs         { ($$ = make_proc($2,$3,$4))->next = $6; }

specs   : REACH expr specs                      { ($$ = make_spec($2))->next = $3 }

varlist : VAR decls PV                          { program_vars = $2; } /* TODO pas exactement ça ; si c'est local ??? */

decls   : IDENT                                 { $$ = make_ident($1); }
    | decls V IDENT                             { ($$ = make_ident($3))->next = $1; }

%%

#include "projetlex.c"

int eval (expr *e)
{
    /* switch (e->type)
    {

    } */
    return 0;
}

void execute (stmt *s)
{
    /* switch (s->type)
    {
        /* blabla selon les types de statement 
    } */
}

int main (int argc, char **argv)
{
	if (argc <= 1) { yyerror("no file specified"); exit(1); }
	yyin = fopen(argv[1],"r");
	if (!yyparse()) execute(program_stmts);
}