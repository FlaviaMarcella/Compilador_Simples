/*========================================================
| UNIFAL - Universidade Federal de Alfenas
| BACHARELADO EM CIENCIA DA COMPUTACAO
|
| Trabalho: Construcao Arvore Sintatica e Geracao de Codigo
| Disciplina: Teoria de Linguagens e Compiladores
| Professor: Luiz Eduardo da Silva
| 
| Arquivo: tree.h
| Descricao: Definicoes das estruturas de dados para
|            a arvore sintatica
========================================================*/

#ifndef TREE_H
#define TREE_H

#include <stdio.h>
#include <stdlib.h>

/* Tipos de nos da arvore sintatica */
#define PRG             1    /* Programa */
#define IDENT           2    /* Identificador */
#define DVR             3    /* Declaracao de variaveis */
#define TIPO            4    /* Tipo (inteiro/logica) */
#define LVR             5    /* Lista de variaveis */
#define LCM             6    /* Lista de comandos */
#define LET             7    /* Leitura */
#define ESC             8    /* Escrita */
#define SEL             9    /* Selecao (if) */
#define REP             10   /* Repeticao (while) */
#define ATR             11   /* Atribuicao */
#define EXP             12   /* Expressao */
#define NUM             13   /* Numero */
#define VAR             14   /* Variavel */
#define SOMA            15   /* Operador + */
#define SUBT            16   /* Operador - */
#define MULT            17   /* Operador * */
#define DIVI            18   /* Operador div */
#define MAI             19   /* Comparador > */
#define MEN             20   /* Comparador < */
#define IGU             21   /* Comparador = */
#define NEG             22   /* Negacao logica */
#define CONJ            23   /* Conjuncao (e) */
#define DISJ            24   /* Disjuncao (ou) */
#define VRD             25   /* Verdadeiro */
#define FLS             26   /* Falso */

typedef struct no *ptno;

struct no {
    int tipo;      /* Tipo do no */
    int valor;     /* Valor numerico (para numeros/tipos) */
    char *lexema;  /* Lexema (para identificadores) */
    ptno filho;    /* Primeiro filho */
    ptno irmao;    /* Proximo irmao */
};

/* Prototipos de funcoes */
ptno criaNo(int tipo, int valor);
ptno criaNoLexema(int tipo, char *lex);
void adicionaFilho(ptno pai, ptno filho);
void imprimeArvore(ptno raiz, FILE *saida);
void imprime_rec(ptno p, FILE *saida);
void libera(ptno p);
char* tipoParaString(int tipo);

#endif