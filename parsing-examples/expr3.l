%{
#include <string.h>

#define INT 260
#define ID  261

union {
        int i;
        char *s;
} data; 
%}

%%

[()+*]	{ return *yytext; }
[0-9]+  { data.i = atoi(yytext); return INT; }
[a-z]+  { data.s = strdup(yytext); return ID; }

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
			case INT: printf("int(%d) ",data.i); break;
			case ID: printf("id(%s) ",data.s); break;
			default: printf("%c ",*yytext); break;
		}
	}
        printf("\n");
}
