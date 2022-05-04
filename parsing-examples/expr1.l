
%%

[()+*]	{ printf("%c ",*yytext); }
[0-9]+  { printf("int "); }
[a-z]+  { printf("id "); }

.       { }
\n      { }

%%

int yywrap() { return 1; }
int main()
{
        yylex();
        printf("\n");
}
