/*========================================================
| UNIFAL - Universidade Federal de Alfenas
| BACHARELADO EM CIENCIA DA COMPUTACAO
|
| Arquivo: utils.c
| Descricao: Tabela de simbolos e funcoes utilitarias
========================================================*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int NUM_VAR = 0;

#define MAX_SIMBOLOS 100

typedef struct {
    char id[100];
    int endereco;
} Simbolo;

Simbolo tabela[MAX_SIMBOLOS];
int num_simbolos = 0;

void insereSimbolo(char *identificador, int end) {
    if (num_simbolos < MAX_SIMBOLOS) {
        strcpy(tabela[num_simbolos].id, identificador);
        tabela[num_simbolos].endereco = end;
        num_simbolos++;
    }
}

int buscaSimbolo(char *identificador) {
    int i;
    for (i = 0; i < num_simbolos; i++) {
        if (strcmp(tabela[i].id, identificador) == 0) {
            return tabela[i].endereco;
        }
    }
    return -1;  /* Nao encontrado */
}

void limpa_simbolos() {
    num_simbolos = 0;
}

/* Pilha para gerenciar rotulos */
#define MAX_PILHA 100
int pilha[MAX_PILHA];
int topo = -1;

void empilha(int valor) {
    if (topo < MAX_PILHA - 1) {
        pilha[++topo] = valor;
    }
}

int desempilha(void) {
    if (topo >= 0) {
        return pilha[topo--];
    }
    return -1;
}

int vazio(void) {
    return topo == -1;
}
