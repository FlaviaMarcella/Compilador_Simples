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

extern int NUM_VAR;

void insereSimbolo(char *nome, int end);
int buscaSimbolo(char *nome);
void limpa_simbolos();

/* Funcoes de pilha (para rotulos) */
void empilha(int valor);
int desempilha(void);
int vazio(void);

#endif
