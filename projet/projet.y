%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int yylex();

void yyerror(char *s)
{
	fflush(stdout);
	fprintf(stderr, "%s\n", s);
}

/***************************************************************************/
/* Data structures for storing a programme.                                */


typedef enum exprtyp {Pg,Xor,Or,And,Not,Plus,Moins,Fois,Int,Ident,Egal} exprtyp;
typedef enum stmttyp {Assign, Pv, Do, If, Skip, Break} stmttyp;
typedef enum choicetyp {Choice, Else} choicetyp;

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
    int valeur;
	var *var;                   // pour les ident
	struct expr *left, *right;  // pour les binop
} expr;


typedef struct choice
{
    enum choicetyp type;
    struct expr *cond;
    struct stmt *commande;
    struct choice *next;
} choice;

typedef struct stmt	// commande
{
	enum stmttyp type;	        // ASSIGN, ';', DO, IF, SKIP, BREAK
	struct var *var;            // pour assign
	struct expr *expr;          // pour assign, if, when
	struct stmt *left, *right;  // pour when, ;
    struct choice *choice;
} stmt;

typedef struct spec
{
    struct expr *expr;
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

int print_var(var *var) {
	if(var != NULL){
		printf("%s",var->nom);
	} else printf(" nil ");
	return 0;
}

int print_varlist(varlist *vl)
{
    printf("[");
    while (vl)
    {
        print_var(vl->var);
        printf(",");
        vl = vl->next;
    }
    printf("]");
    printf("\n");
}


int print_expr(expr *expr) 
{
	if(expr != NULL){
		switch (expr->type)
		{
			case Ident:
				printf("%s", expr->var->nom);
			break;

			case Int:
				printf("%d", expr->valeur);
			break;

			case Or:
				print_expr(expr->left);
				printf(" || ");
				print_expr(expr->right);
			break;

			case And:
				print_expr(expr->left);
				printf(" && ");
				print_expr(expr->right);
			break;

			case Xor:
				print_expr(expr->left);
				printf(" ^ ");
				print_expr(expr->right);
			break;

			case Pg:
				print_expr(expr->left);
				printf(" > ");
				print_expr(expr->right);
			break;

			case Egal:
				print_expr(expr->left);
				printf(" == ");
				print_expr(expr->right);
			break;

			case Plus:
				print_expr(expr->left);
				printf(" + ");
				print_expr(expr->right);
			break;

			case Moins:
				print_expr(expr->left);
				printf(" - ");
				print_expr(expr->right);
			break;

			case Fois:
				print_expr(expr->left);
				printf(" * ");
				print_expr(expr->right);
			break;

			case Not:
				printf("~");
				print_expr(expr->left);
			break;
		}
	}	
	return 0;
}
char* n_tab(int n) 
{
	if (n == 0) {return "";} else {
	int fullsize = n * strlen("  ") + 1;
	char* fullword;
	fullword = (char *) malloc( fullsize );
    strcpy( fullword, "" );
	strcat(fullword,"  ");
	strcat(fullword,n_tab(n-1));
	fullword;
	}
	
}
int print_stmt(stmt *stmt, int dec);
int print_choix(choice *choix, int dec)
{
    if(choix)
    {
        switch (choix->type)
        {
            case Choice:
                printf("%ssi ",n_tab(dec));
                print_expr(choix->cond);
                printf("-> \n");
                print_stmt(choix->commande, dec+1);
                printf("\n");
                print_choix(choix->next,dec);
            break;
            case Else:
                printf("%selse -> \n",n_tab(dec));
                print_stmt(choix->commande, dec+1);
            break;
        }
    }
    return 0;
}
int print_stmt(stmt *stmt, int dec) 
{
	if(stmt)
    {
		switch (stmt->type)
        {
			case Assign:
				printf("%s%s := ",n_tab(dec),stmt->var->nom);
				print_expr(stmt->expr);
			break;

			case Pv:
				print_stmt(stmt->left,dec);
				printf(";\n");
				print_stmt(stmt->right,dec);
			break;	

			case Do:
				printf("%sdo \n",n_tab(dec));
				print_choix(stmt->choice,dec+1);
				printf("%sod\n",n_tab(dec));
			break;

			case If:
				printf("%sif \n",n_tab(dec));
				print_choix(stmt->choice,dec+1);
				printf("%sfi \n",n_tab(dec));
			break;

			case Skip:
				printf("%sskip",n_tab(dec));
			break;

			case Break:
				printf("%sbreak",n_tab(dec));
			break;
		}
	}
	return 0;
}
int print_procs(proc *proc) 
{
    printf("processus : %s\n", proc->name);
    printf("ses variables :");
    print_varlist(proc->vars);
    print_stmt(proc->commande,1);
    if (proc->next) 
    {
        printf("\nPROCESSUS SUIVANT \n");
        print_procs(proc->next);
    }
}
int print_specs(spec *spec)
{
    if(spec)
    {
        printf("- ");
        print_expr(spec->expr);
        printf("\n");
        print_specs(spec->next);
    }
}




var* make_id (char *s)
{
    var *v = malloc(sizeof(var));
    v->nom = s;
    v->valeur = 0;
    return v;
}
varlist* make_vlist (var *v)
{
    varlist *vl = malloc(sizeof(varlist));
    vl->var = v;
    vl->next = NULL;
    return vl;
}
var* find_id (char *s)
{
    varlist *v = program_vars;
    printf("on cherche %s\n",s);
    while (v && strcmp(v->var->nom,s)) v=v->next;
    if (!v) 
    {
        printf("%s pas trouvée dans :",s);
        printf("\n");
        print_varlist(program_vars);
        yyerror("variable inconnue"); exit(1);
     }
    return v->var;
}

expr* make_expr (enum exprtyp type, int n, var *var, expr *left, expr *right)
{
    expr *e = malloc(sizeof(expr));
    e->type = type;
    e->valeur = n;
    e->var = var;
    e->left = left;
    e->right = right;
    return e;
}

stmt* make_stmt (enum stmttyp type, var *var, expr *expr, stmt *right, stmt *left, choice *choice)
{
    stmt *s = malloc(sizeof(stmt));
	s->type = type;
	s->var = var;
	s->expr = expr;
	s->left = left;
	s->right = right;
    s->choice = choice;
	return s;
}

choice* make_choice (enum choicetyp type, expr *cond, stmt *commande)
{
    choice *c = malloc(sizeof(choice));
    c->type = type;
    c->cond = cond;
    c->commande = commande;
    c->next = NULL;
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
    varlist *vl;
    expr *e;
    stmt *s;
    spec *sp;
    proc *p;
    choice *c;
}

%type <e> expr
%type <s> stmt assign
%type <c> choix
%type <vl> varlist decls
%type <sp> specs
%type <p> procs

%token VAR PROC END DO OD IF FI BREAK REACH SKIP ALORS ELSE PG PV V CHOIX EGAL ASSIGN XOR OR AND NOT PLUS MOINS FOIS 
%token <i> IDENT
%token <e> INT


%left PV
%left EGAL PG PLUS MOINS FOIS 
%left OR XOR
%left AND
%right NOT


%start prog
%%


prog    : varlist procs specs                   { program_vars = $1; program_procs = $2; program_specs = $3; }

procs   :                                       { $$ = NULL; }
    | PROC IDENT varlist stmt END procs         { ($$ = make_proc($2,$3,$4))->next = $6; }

specs   :                                       { $$ =NULL; }
    | REACH expr specs                          { ($$ = make_spec($2))->next = $3; }

varlist :                                       { $$ = NULL; }
    | VAR decls PV                              { $$ = $2; } 

decls   : IDENT                                 { $$ = make_vlist((make_id($1))); }
    | decls V IDENT                             { ($$ = make_vlist((make_id($3))))->next = $1; }

stmt    : assign                                
    | stmt PV stmt                              { $$ = make_stmt(Pv, NULL, NULL, $3, $1, NULL); }
    | DO choix OD                               { $$ = make_stmt(Do, NULL, NULL, NULL, NULL, $2); }
    | IF choix FI                               { $$ = make_stmt(If, NULL, NULL, NULL, NULL, $2); }
    | SKIP                                      { $$ = make_stmt(Skip, NULL, NULL, NULL, NULL, NULL); }
    | BREAK                                     { $$ = make_stmt(Break, NULL, NULL, NULL, NULL, NULL); }

assign  : IDENT ASSIGN expr                     { $$ = make_stmt(Assign,make_id($1),$3, NULL, NULL, NULL); }

choix   : CHOIX expr ALORS stmt                 { $$ = make_choice(Choice,$2,$4); }
    | CHOIX ELSE ALORS stmt                     { $$ = make_choice(Else,NULL,$4); }
    | CHOIX expr ALORS stmt choix               { ($$ = make_choice(Choice,$2,$4))->next = $5; }

expr    : IDENT                                 { $$ = make_expr(Ident, 0, make_id($1), NULL, NULL); }
    | expr XOR expr                             { $$ = make_expr(Xor, 0, NULL, $1, $3); }
    | expr OR expr                              { $$ = make_expr(Or, 0, NULL, $1, $3); }
    | expr AND expr                             { $$ = make_expr(And, 0, NULL, $1, $3); }
    | NOT expr                                  { $$ = make_expr(Not, 0, NULL, $2, NULL); }
    | expr PLUS expr                            { $$ = make_expr(Plus, 0, NULL, $1, $3); }
    | expr MOINS expr                           { $$ = make_expr(Moins, 0, NULL, $1, $3); }
    | expr FOIS expr                            { $$ = make_expr(Fois, 0, NULL, $1, $3); }
    | expr PG expr                              { $$ = make_expr(Pg, 0, NULL, $1, $3); }
    | expr EGAL expr                            { $$ = make_expr(Egal, 0, NULL, $1, $3); }
    | '(' expr ')'                              { $$ = $2; }
    | INT                                       { $$ = $1; }

%%

#include "projetlex.c"



int main (int argc, char **argv)
{
	if (argc <= 1) { yyerror("no file specified"); exit(1); }
	yyin = fopen(argv[1],"r");
    yyparse();
    printf("VARIABLES GLOBALES : \n");
    print_varlist(program_vars);
    printf("\nPROCESSUS :\n");
    print_procs(program_procs);
    printf("\n");
    printf("SPECIFICATIONS : \n");
    print_specs(program_specs);
}