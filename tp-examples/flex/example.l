%option noyywrap

%{
	int nblignes = 0;
%}

%%

[0-9]+	{ printf("int(%d)  ",atoi(yytext)); }
[+*()]	{ printf("'%c'  ",*yytext); }
[\n]    {++nblignes; }
.		{ }

%%

int main (int argc, char **argv)
{
	if (argc > 1) yyin = fopen(argv[1],"r");
	yylex();
	printf("\n%d lignes", nblignes);
	puts("");
}