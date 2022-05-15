%option noyywrap

DIG	[0-9]

%%

"var"	{ return VAR; }

"proc"	{ return PROC; }
"end"   { return END; }

"do"	{ return DO; }
"od"	{ return OD; }

"if"    { return IF; }
"fi"    { return FI; }

"break" { return BREAK; }
"reach" { return REACH; }
"skip"  { return SKIP; }
"else"  { return ELSE; }
{DIG}+  { yylval.e = make_expr(Int,atoi(yytext),NULL,NULL, NULL); return INT; }


"->"    { return ALORS; }
">"     { return PG; }
";"     { return PV; }
","     { return V;}
"::"    { return CHOIX;}
"=="    { return EGAL; }
":="	{ return ASSIGN; }
"^"	    { return XOR; }
"||"	{ return OR; }
"&&"	{ return AND; }
"!"	    { return NOT; }
"+"     { return PLUS; }
"-"     { return MOINS; }
"*"     { return FOIS; }
[a-z_][a-z0-9_]* { yylval.i = strdup(yytext); return IDENT; }
"//".*"\n"  { /* commentaire, ignorer */}
[	 \n]   { /* ignore */ }

.	{ return *yytext; }

%%