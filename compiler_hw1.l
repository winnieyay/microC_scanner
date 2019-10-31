/* Definition section */
%{
	#include <stdio.h>
	#include <stdlib.h>
	//#include <stdbool.h>

	int count = 0;
	int comment = 0;
%}

/* Define regular expression label */

letter [a-zA-Z]
digit [0-9]
id {letter}+({letter}|{digit})*
inumber {digit}+
fnumber ({digit}*\.{digit}+)

%x CMT
%x CPP_CMT
%x STR_CONST
%x STR_CONST_CHECK

/* Rules section */
%%

"+" 	{ printf("%s \t ADD\n", yytext); }
"-"	{ printf("%s \t SUB\n", yytext); }
{id}	{ printf("%s \t ID\n", yytext); }
"\n"	{ count++; }
"print"	{ printf("%s \t PRINT\n", yytext); }
"if"	{ printf("%s \t IF\n", yytext); }
"else"	{ printf("%s \t ELSE\n", yytext); }
"for"	{ printf("%s \t FOR\n", yytext); }
"while"	{ printf("%s \t WHILE\n", yytext); }
"string"	{ printf("%s \t STRING\n", yytext); }
"int"	{ printf("%s \t INT\n", yytext); }
"float"	{ printf("%s \t FLOAT\n", yytext); }
"void"	{ printf("%s \t VOID\n", yytext); }
"bool"	{ printf("%s \t BOOL\n", yytext); }
"true"	{ printf("%s \t TRUE\n", yytext); }
"false"	{ printf("%s \t FALSE\n", yytext); }
"return"	{ printf("%s \t RET\n", yytext); }
"continue"	{ printf("%s \t CONT\n", yytext); }
"break"	{ printf("%s \t BREAK\n", yytext); }
"="	{ printf("%s \t ASGN\n", yytext); }
"*"	{ printf("%s \t MUL\n", yytext); }
"/"	{ printf("%s \t DIV\n", yytext); }
"%"	{ printf("%s \t MOD\n", yytext); }
"=="	{ printf("%s \t EQ\n", yytext); }
"("	{ printf("%s \t LB\n", yytext); }
")"	{ printf("%s \t RB\n", yytext); }
"["	{ printf("%s \t LSB\n", yytext); }
"]"	{ printf("%s \t RSB\n", yytext); }
"{"	{ printf("%s \t LCB\n", yytext); }
"}"	{ printf("%s \t RCB\n", yytext); }
";"	{ printf("%s \t SEMICOLON\n", yytext); }
","	{ printf("%s \t COMMA\n", yytext); }
{inumber}	{ printf("%s \t I_CONST\n", yytext); }
{fnumber}	{ printf("%s \t F_CONST\n", yytext); }


"+="	{ printf("%s \t ADDASGN\n", yytext); }
"-="	{ printf("%s \t SUBASGN\n", yytext); }
"/="	{ printf("%s \t DIVASGN\n", yytext); }
"*="	{ printf("%s \t MULASGN\n", yytext); }
"%="	{ printf("%s \t MODASGN\n", yytext); }
"!="	{ printf("%s \t NE\n", yytext); }
">="	{ printf("%s \t MTE\n", yytext); }
"<="	{ printf("%s \t LTE\n", yytext); }
"<"	{ printf("%s \t LSS\n", yytext); }
">"	{ printf("%s \t GTR\n", yytext); }
"++"	{ printf("%s \t INC\n", yytext); }
"--"	{ printf("%s \t DEC\n", yytext); }
"&&"	{ printf("%s \t AND\n", yytext); }
"||"	{ printf("%s \t OR\n", yytext); }
"!"	{ printf("%s \t NOT\n", yytext); }
"\t"	{;}
" "	{;}

"\""	{ printf("%s \t QUOTA\n", yytext); BEGIN(STR_CONST); }
<CMT>"*/"	{ BEGIN(INITIAL); printf("*/ \t C Comment\n"); }
<CMT>"\n"	{ printf("\n"); count++; comment++; }
<CPP_CMT>"\n"	{ printf("\t C++ comment\n"); count ++; comment++; BEGIN(INITIAL); }


"//"	{ printf("//"); BEGIN(CPP_CMT); }


"/*"	{ comment++; BEGIN(CMT); printf("/*"); }


<STR_CONST>([^\\\"]|\\.)* { printf("%s \t STR_CONST \n", yytext); }
<STR_CONST>"\n" { count++; }
<STR_CONST>"\""	{ printf("%s \t QUOTA \n",yytext); BEGIN(INITIAL); }

%%

/*	C Code section */
int yywrap(void)
{
    return 1;
}

int main(int argc,char *argv[])
{
	yyin = fopen(argv[1],"r");
	yylex(); 
	printf("\nParse over, the line number is %d.\n\n", count);
	printf("comment: %d lines\n\n",comment);

	return 0;
}
