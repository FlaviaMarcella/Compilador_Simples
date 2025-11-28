/*========================================================
| UNIFAL - Universidade Federal de Alfenas
| BACHARELADO EM CIENCIA DA COMPUTACAO
|
| Arquivo: utils.h
| Descricao: Prototipos e definicoes para funcoes utilitarias
========================================================*/

#ifndef UTILS_H
#define UTILS_H

#include <stdio.h>
#include <stdlib.h>

#define INT 0    /* Tipo inteiro */
#define LOG 1    /* Tipo logico */
#define UND -1   /* Tipo indefinido */

extern int NUM_VAR;
extern int erro_tipo;

void insereSimbolo(char *nome, int tipo, int end);
int buscaSimbolo(char *nome);
int buscaTipo(char *nome);
void limpa_simbolos();

/* Verificacao de tipos */
int verificaTipo(int tipo1, int tipo2, int operador);
int verificaUnaria(int tipo, int operador);

/* Funcoes de pilha (para rotulos) */
void empilha(int valor);
int desempilha(void);
int vazio(void);

#endif
