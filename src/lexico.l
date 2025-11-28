/*========================================================
| UNIFAL - Universidade Federal de Alfenas
| BACHARELADO EM CIENCIA DA COMPUTACAO
|
| Trabalho: Construcao Arvore Sintatica e Geracao de Codigo
| Disciplina: Teoria de Linguagens e Compiladores
| Professor: Luiz Eduardo da Silva
| 
| Arquivo: lexico.l (modificado)
| Descricao: Analisador lexico com suporte a arvore sintatica
========================================================*/

%{
      #include "tree.h"
      #include "sintatico.h"
      char atomo[100];
      void yyerror(char *);
      int nlin = 1;
%}

identificador [a-zA-z]([a-zA-Z0-9])*
numero        [0-9]+
espaco        [ \t]+
novalinha     [\n]

%x coment
%%

programa      { return T_PROGRAMA; }
inicio        { return T_INICIO; }
fimprograma   { return T_FIM; }
leia          { return T_LEIA; }
escreva       { return T_ESCREVA; }
se            { return T_SE; }
entao	        { return T_ENTAO; }
senao         { return T_SENAO; }
fimse         { return T_FIMSE; }
enquanto      { return T_ENQTO; }
faca          { return T_FACA; }
fimenquanto   { return T_FIMEQTO; }

"+"           { return T_MAIS; }
"-"           { return T_MENOS; }
"*"           { return T_VEZES; }
"div"         { return T_DIV; }

">"           { return T_MAIOR; }
"<"           { return T_MENOR; }
"="           { return T_IGUAL; }

"e"           { return T_E; }
"ou"          { return T_OU; }
"nao"         { return T_NAO; }
"V"           { return T_V; }
"F"           { return T_F; }

"<-"          { return T_ATRIB; }
"("           { return T_ABRE; }
")"           { return T_FECHA; }

inteiro       { return T_INTEIRO; }
logica        { return T_LOGICO; }

{identificador}  {
                    strcpy(atomo, yytext);
                    yylval.str = strdup(yytext);
                    return T_IDENTIF;
                 }

{numero}      {
                 strcpy(atomo, yytext);
                 return T_NUMERO;
              }

{espaco}      ;

{novalinha}   { nlin++; }

"/*"          { BEGIN coment; }
<coment>"*/"  { BEGIN 0; }
<coment>.     ;
<coment>{novalinha} { nlin++; }

"//".*        ;

.             { yyerror("Caracter invalido"); }

%%

int yywrap() {
    return 1;
}