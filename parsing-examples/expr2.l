%{
#define INT 260
#define ID  261
%}

%%

[()+*]	{ return *yytext; }
[0-9]+  { return INT; }
[a-z]+  { return ID; }

.       { }
\n      { }

%%

int yywrap() { return 1; }
int main()
{
	int c;

	while ((c = yylex()))
	{
		switch (c)
		{
			case INT: printf("int "); break;
			case ID: printf("id "); break;
			default: printf("%c ",*yytext); break;
		}
	}
        printf("\n");
}
