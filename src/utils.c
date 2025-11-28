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
#include "utils.h"

int NUM_VAR = 0;
int erro_tipo = 0;

#define MAX_SIMBOLOS 100

typedef struct {
    char id[100];
    int tipo;
    int endereco;
} Simbolo;

Simbolo tabela[MAX_SIMBOLOS];
int num_simbolos = 0;

void insereSimbolo(char *identificador, int tipo, int end) {
    if (num_simbolos < MAX_SIMBOLOS) {
        strcpy(tabela[num_simbolos].id, identificador);
        tabela[num_simbolos].tipo = tipo;
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

/**
 * Busca o tipo de um símbolo
 * Retorna INT, LOG ou UND (não encontrado)
 */
int buscaTipo(char *identificador) {
    int i;
    for (i = 0; i < num_simbolos; i++) {
        if (strcmp(tabela[i].id, identificador) == 0) {
            return tabela[i].tipo;
        }
    }
    return UND;  /* Nao encontrado */
}

void limpa_simbolos() {
    num_simbolos = 0;
}

/**
 * Verifica compatibilidade de tipos em operação binária
 * Retorna INT para operações aritméticas, LOG para comparações/lógicas, UND se erro
 */
int verificaTipo(int tipo1, int tipo2, int operador) {
    char *op_nome = "";
    
    /* Operadores aritméticos: ambos INT */
    if (operador == 15 || operador == 16 || operador == 17 || operador == 18) {  /* SOMA, SUBT, MULT, DIVI */
        if (operador == 15) op_nome = "+";
        else if (operador == 16) op_nome = "-";
        else if (operador == 17) op_nome = "*";
        else op_nome = "/";
        
        if (tipo1 == INT && tipo2 == INT) {
            return INT;
        } else {
            fprintf(stderr, "✗ Erro de tipo: operador '%s' requer dois inteiros (INT %s INT)\n", op_nome, op_nome);
            erro_tipo = 1;
            return UND;
        }
    }
    
    /* Operadores comparação e igualdade: ambos INT */
    if (operador == 19 || operador == 20 || operador == 21) {  /* MAI, MEN, IGU */
        if (operador == 19) op_nome = ">";
        else if (operador == 20) op_nome = "<";
        else op_nome = "=";
        
        if (tipo1 == INT && tipo2 == INT) {
            return LOG;
        } else {
            fprintf(stderr, "✗ Erro de tipo: operador comparação '%s' requer dois inteiros (INT %s INT)\n", op_nome, op_nome);
            erro_tipo = 1;
            return UND;
        }
    }
    
    /* Operadores lógicos: ambos LOG */
    if (operador == 23 || operador == 24) {  /* CONJ, DISJ */
        op_nome = (operador == 23) ? "e" : "ou";
        
        if (tipo1 == LOG && tipo2 == LOG) {
            return LOG;
        } else {
            fprintf(stderr, "✗ Erro de tipo: operador '%s' requer dois lógicos (LOG %s LOG)\n", op_nome, op_nome);
            erro_tipo = 1;
            return UND;
        }
    }
    
    return UND;
}

/**
 * Verifica compatibilidade de tipos em operação unária
 * Negação: LOG → LOG
 */
int verificaUnaria(int tipo, int operador) {
    if (operador == 22) {  /* NEG */
        if (tipo == LOG) {
            return LOG;
        } else {
            fprintf(stderr, "✗ Erro de tipo: operador 'nao' requer um lógico (nao LOG)\n");
            erro_tipo = 1;
            return UND;
        }
    }
    return UND;
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
