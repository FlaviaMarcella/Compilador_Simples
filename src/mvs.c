/*========================================================
| UNIFAL - Universidade Federal de Alfenas
| BACHARELADO EM CIENCIA DA COMPUTACAO
|
| Simulador da Maquina Virtual Simples (MVS)
| Por Luiz Eduardo da Silva
|
| Arquivo: mvs.c
| Descricao: Máquina Virtual que executa código intermediário
========================================================*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

/* Conjunto de instruções mnemonicas da MVS */
#define TOTALINST 31

char *inst[TOTALINST] = {
    "CRVG", "CRCT", "SOMA", "SUBT", "MULT", "DIVI",
    "CMIG", "CMMA", "CMME", "CONJ", "DISJ", "NEGA",
    "ARZG", "DSVS", "DSVF", "NADA", "ESCR", "LEIA",
    "INPP", "FIMP", "AMEM", "DMEM", "ENSP", "RTSP",
    "PARA", "CRCT", "CRVG", "ARZG", "DSVF", "DSVS", "NADA"
};

/* Códigos das instruções */
#define CRVG  0
#define CRCT  1
#define SOMA  2
#define SUBT  3
#define MULT  4
#define DIVI  5
#define CMIG  6
#define CMMA  7
#define CMME  8
#define CONJ  9
#define DISJ  10
#define NEGA  11
#define ARZG  12
#define DSVS  13
#define DSVF  14
#define NADA  15
#define ESCR  16
#define LEIA  17
#define INPP  18
#define FIMP  19
#define AMEM  20
#define DMEM  21

typedef struct {
    int r;
    int i;
    int o;
} prog;

prog P[500];
int M[500];
int L[50];
int i = 0;
int s = -1;
int d = -1;
int pc = 0;
int debug = 0;

void mostra_pilha(int topo) {
    printf("[Pilha]: ");
    if (topo < 0) {
        printf("(vazia)\n");
        return;
    }
    for (int k = 0; k <= topo; k++) {
        printf("%d ", M[k]);
    }
    printf("\n");
}

int buscainst(char *nome) {
    int j;
    for (j = 0; j < TOTALINST; j++) {
        if (strcmp(nome, inst[j]) == 0) {
            return j;
        }
    }
    return -1;
}

void carrega(char *nome) {
    FILE *arq;
    char linha[200];
    char inst_nome[20];
    int rot, oper;
    
    arq = fopen(nome, "r");
    if (!arq) {
        fprintf(stderr, "Erro ao abrir arquivo: %s\n", nome);
        exit(1);
    }
    
    pc = 0;
    while (fgets(linha, 200, arq)) {
        if (strlen(linha) == 0 || linha[0] == '\n') continue;
        
        P[pc].r = -1;
        P[pc].o = -1;
        
        /* Verifica se tem rótulo */
        if (linha[0] != '\t' && (linha[0] < '0' || linha[0] > '9')) {
            /* Tem rótulo */
            if (sscanf(linha, "L%d", &rot) == 1) {
                L[rot] = pc;
                P[pc].r = rot;
            }
        }
        
        /* Procura a instrução */
        char *p = strchr(linha, '\t');
        if (p) {
            sscanf(p + 1, "%s %d", inst_nome, &oper);
            int idx = buscainst(inst_nome);
            if (idx >= 0) {
                P[pc].i = idx;
                P[pc].o = oper;
            }
        } else {
            /* Tenta sem operando */
            char *end = strchr(linha, '\n');
            if (end) *end = '\0';
            int idx = buscainst(linha);
            if (idx >= 0) {
                P[pc].i = idx;
            }
        }
        
        pc++;
    }
    
    fclose(arq);
}

void mostra_programa() {
    int j;
    printf("\n=== PROGRAMA CARREGADO ===\n");
    for (j = 0; j < pc; j++) {
        if (P[j].r >= 0) {
            printf("L%d\t", P[j].r);
        } else {
            printf("\t");
        }
        printf("%s", inst[P[j].i]);
        if (P[j].o >= 0) {
            printf("\t%d", P[j].o);
        }
        printf("\n");
    }
    printf("===========================\n\n");
}

void executa() {
    i = 0;
    s = -1;
    d = -1;
    
    while (i < pc) {
        if (debug) {
            printf("--------------------------------\n");
            printf("PC=%-5d s=%-5d ", i, s);
            if (P[i].r != -1) printf("L%d:", P[i].r);
            printf("\t%s", inst[P[i].i]);
            if (P[i].o != -1) printf("\t%d", P[i].o);
            printf("\n");
            mostra_pilha(s);
        }
        
        switch (P[i].i) {
            case INPP:
                s = -1;
                d = -1;
                break;
                
            case AMEM:
                s += P[i].o;
                break;
                
            case DMEM:
                s -= P[i].o;
                break;
                
            case CRCT:
                M[++s] = P[i].o;
                break;
                
            case CRVG:
                M[++s] = M[P[i].o];
                break;
                
            case ARZG:
                M[P[i].o] = M[s--];
                break;
                
            case SOMA:
                M[s-1] = M[s-1] + M[s];
                s--;
                break;
                
            case SUBT:
                M[s-1] = M[s-1] - M[s];
                s--;
                break;
                
            case MULT:
                M[s-1] = M[s-1] * M[s];
                s--;
                break;
                
            case DIVI:
                if (M[s] != 0) {
                    M[s-1] = M[s-1] / M[s];
                }
                s--;
                break;
                
            case CMMA:
                M[s-1] = (M[s-1] > M[s]) ? 1 : 0;
                s--;
                break;
                
            case CMME:
                M[s-1] = (M[s-1] < M[s]) ? 1 : 0;
                s--;
                break;
                
            case CMIG:
                M[s-1] = (M[s-1] == M[s]) ? 1 : 0;
                s--;
                break;
                
            case CONJ:
                M[s-1] = M[s-1] && M[s];
                s--;
                break;
                
            case DISJ:
                M[s-1] = M[s-1] || M[s];
                s--;
                break;
                
            case NEGA:
                M[s] = (M[s] == 0) ? 1 : 0;
                break;
                
            case LEIA:
                scanf("%d", &M[++s]);
                break;
                
            case ESCR:
                printf("%d\n", M[s--]);
                break;
                
            case DSVS:
                i = L[P[i].o];
                continue;
                
            case DSVF:
                if (M[s--] == 0) {
                    i = L[P[i].o];
                    continue;
                }
                break;
                
            case NADA:
                break;
                
            case FIMP:
                return;
        }
        
        i++;
    }
}

int main(int argc, char **argv) {
    char nome_arquivo[256];
    
    if (argc > 1 && strcmp(argv[1], "-d") == 0) {
        debug = 1;
        argv++;
        argc--;
    }

    if (argc < 2) {
        fprintf(stderr, "Uso: %s <arquivo>\n", argv[0]);
        return 1;
    }
    
    strcpy(nome_arquivo, argv[1]);
    if (strlen(nome_arquivo) < 4 || strcmp(nome_arquivo + strlen(nome_arquivo) - 4, ".mvs") != 0) {
        strcat(nome_arquivo, ".mvs");
    }
    
    carrega(nome_arquivo);
    executa();
    
    return 0;
}
