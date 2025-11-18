/*========================================================
| UNIFAL - Universidade Federal de Alfenas
| BACHARELADO EM CIENCIA DA COMPUTACAO
|
| Trabalho: Construcao Arvore Sintatica e Geracao de Codigo
| Disciplina: Teoria de Linguagens e Compiladores
| Professor: Luiz Eduardo da Silva
| 
| Arquivo: tree.c
| Descricao: Implementacao das funcoes para manipulacao
|            da arvore sintatica
========================================================*/

#include "tree.h"
#include <string.h>

int contador_no = 0;

/* Cria um novo no sem lexema */
ptno criaNo(int tipo, int valor) {
    ptno n = (ptno) malloc(sizeof(struct no));
    n->tipo = tipo;
    n->valor = valor;
    n->lexema = NULL;
    n->filho = NULL;
    n->irmao = NULL;
    return n;
}

/* Cria um novo no com lexema */
ptno criaNoLexema(int tipo, char *lex) {
    ptno n = (ptno) malloc(sizeof(struct no));
    n->tipo = tipo;
    n->valor = -1;
    if (lex) {
        n->lexema = (char *) malloc(strlen(lex) + 1);
        strcpy(n->lexema, lex);
    } else {
        n->lexema = NULL;
    }
    n->filho = NULL;
    n->irmao = NULL;
    return n;
}

/* Adiciona filho a um no (insere no FINAL da lista de filhos) */
void adicionaFilho(ptno pai, ptno filho) {
    if (filho) {
        filho->irmao = NULL;  /* Garante que sera o ultimo */
        
        if (pai->filho == NULL) {
            /* Lista vazia - insere como primeiro filho */
            pai->filho = filho;
        } else {
            /* Percorre ate o ultimo irmao e insere no final */
            ptno ultimo = pai->filho;
            while (ultimo->irmao != NULL) {
                ultimo = ultimo->irmao;
            }
            ultimo->irmao = filho;
        }
    }
}

/* Converte tipo para string descritiva */
char* tipoParaString(int tipo) {
    static char buffer[50];
    
    switch(tipo) {
        case PRG: return "programa";
        case IDENT: return "identificador";
        case DVR: return "declaracao de\nvariaveis";
        case TIPO: 
            return "tipo";
        case LVR: return "lista\nvariaveis";
        case LCM: return "lista\ncomandos";
        case LET: return "leitura";
        case ESC: return "escrita";
        case SEL: return "selecao";
        case REP: return "repeticao";
        case ATR: return "atribuicao";
        case NUM: return "numero";
        case VAR: return "variavel";
        case SOMA: return "soma";
        case SUBT: return "subtrai";
        case MULT: return "multiplica";
        case DIVI: return "divisao";
        case MAI: return "compara maior";
        case MEN: return "compara menor";
        case IGU: return "compara igual";
        case NEG: return "negacao (NAO)";
        case CONJ: return "conjuncao (E)";
        case DISJ: return "disjuncao (OU)";
        case VRD: return "verdadeiro";
        case FLS: return "falso";
        default: return "desconhecido";
    }
}

void imprime_rec(ptno p, FILE *saida) {
    if (p == NULL) return;

    /* Imprime o nó atual */
    fprintf(saida, "  n%p [label=\"%s", (void *)p, tipoParaString(p->tipo));
    
    /* Adiciona valor ou lexema se houver */
    if (p->lexema) {
        fprintf(saida, "|%s", p->lexema);
    } else if (p->valor >= 0) {
        fprintf(saida, "|%d", p->valor);
    }
    fprintf(saida, "\"];\n");
    
    /* Imprime arestas para filhos */
    ptno filho = p->filho;
    while (filho) {
        fprintf(saida, "  n%p -> n%p;\n", (void *)p, (void *)filho);
        filho = filho->irmao;
    }
    
    /* Recursivamente imprime os filhos */
    filho = p->filho;
    while (filho) {
        imprime_rec(filho, saida);
        filho = filho->irmao;
    }
}

void imprimeArvore(ptno raiz, FILE *saida) {
    fprintf(saida, "digraph {\n");
    fprintf(saida, "  node [shape=record, height=.1];\n");
    
    imprime_rec(raiz, saida);
    
    fprintf(saida, "}\n");
}

/* Libera memoria da arvore */
void libera(ptno p) {
    if (p == NULL) return;
    
    ptno filho = p->filho;
    while (filho) {
        ptno temp = filho->irmao;
        libera(filho);
        filho = temp;
    }
    
    if (p->lexema) free(p->lexema);
    free(p);
}
