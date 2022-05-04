%option noyywrap

DIG	[0-9]

%%

{DIG}+	{ printf("int(%d)  ",atoi(yytext)); }
[+*()]	{ printf("'%c'  ",*yytext); }
[ \n]   { /* ignore */ }

%%

int main (int argc, char **argv)
{
	if (argc > 1) yyin = fopen(argv[1],"r");
	yylex();
	puts("");
}
