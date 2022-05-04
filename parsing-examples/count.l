%{
/* exemple pathologique avec temps quadratique */
%}

%%

a	{ printf("A"); }
a*b	{ printf("B"); } 
.       { }
\n      { }

%%

int yywrap() { return 1; }
int main()
{
        yylex();
        printf("\n");
}
