/*========================================================
| UNIFAL - Universidade Federal de Alfenas
| BACHARELADO EM CIENCIA DA COMPUTACAO
|
| Trabalho: Analisador Sintático e Gerador de Código MVS
| Disciplina: Teoria de Linguagens e Compiladores
| Professor: Luiz Eduardo da Silva
| 
| Arquivo: sintatico.y
| Descricao: Parser unificado para construção da AST e geração de código MVS
========================================================*/

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tree.h"
#include "utils.h"

extern void yyerror(char *);
extern int yylex();
extern char atomo[100];
extern FILE *yyin, *yyout;
extern void imprimeArvore(ptno p, FILE *arq);
extern void libera(ptno p);

ptno raiz = NULL;
int ROTULO = 0;

void gera_expressao(ptno p);

/**
 * Primeira passada: coleta tipos de variáveis declaradas
 */
void coleta_tipos(ptno p) {
    if (p == NULL) return;

    ptno p1;

    switch(p->tipo) {
        case PRG:
            p1 = p->filho;
            if (p1 && p1->tipo == IDENT) p1 = p1->irmao;

            if (p1 && p1->tipo == DVR) {
                coleta_tipos(p1);
            }
            break;

        case DVR:
            p1 = p->filho;
            int tipo_atual = INT;

            if (p1 && p1->tipo == TIPO) {
                tipo_atual = p1->valor;
                p1 = p1->irmao;
            }

            while (p1) {
                if (p1->tipo == LVR) {
                    ptno id = p1->filho;
                    while (id) {
                        if (id->tipo == IDENT && id->lexema) {
                            insereSimbolo(id->lexema, tipo_atual, NUM_VAR);
                            NUM_VAR++;
                        }
                        id = id->irmao;
                    }
                }
                p1 = p1->irmao;
            }
            break;

        default:
            p1 = p->filho;
            while (p1) {
                coleta_tipos(p1);
                p1 = p1->irmao;
            }
    }
}

/**
 * Segunda passada: propaga tipos de variáveis para nós de expressão
 */
void propaga_tipos(ptno p) {
    if (p == NULL) return;

    ptno p1;

    switch(p->tipo) {
        case ATR: {
            /* Atribuição: IDENT <- EXPR */
            /* Verifica se tipo da expressão bate com tipo da variável */
            ptno ident_node = p->filho;  /* IDENT */
            ptno expr_node = ident_node ? ident_node->irmao : NULL;  /* EXPR */
            
            if (expr_node) {
                propaga_tipos(expr_node);
                
                if (ident_node && ident_node->lexema) {
                    int var_tipo = buscaTipo(ident_node->lexema);
                    int expr_tipo = expr_node->tipo_expr;
                    
                    if (var_tipo != expr_tipo && var_tipo != UND && expr_tipo != UND) {
                        fprintf(stderr, "✗ Erro de tipo: atribuição incompatível\n");
                        fprintf(stderr, "  Variável '%s' é tipo %s, mas expressão é tipo %s\n",
                                ident_node->lexema,
                                var_tipo == INT ? "INT" : "LOG",
                                expr_tipo == INT ? "INT" : "LOG");
                        erro_tipo = 1;
                    }
                }
            }
            break;
        }

        case VAR:
            if (p->lexema) {
                p->tipo_expr = buscaTipo(p->lexema);
            }
            break;

        case NUM:
            p->tipo_expr = INT;
            break;

        case VRD:
        case FLS:
            p->tipo_expr = LOG;
            break;

        case SOMA:
        case SUBT:
        case MULT:
        case DIVI:
            p1 = p->filho;
            while (p1) {
                propaga_tipos(p1);
                p1 = p1->irmao;
            }
            if (p->filho && p->filho->irmao) {
                p->tipo_expr = verificaTipo(p->filho->tipo_expr, p->filho->irmao->tipo_expr, p->tipo);
            }
            break;

        case MAI:
        case MEN:
        case IGU:
            p1 = p->filho;
            while (p1) {
                propaga_tipos(p1);
                p1 = p1->irmao;
            }
            if (p->filho && p->filho->irmao) {
                p->tipo_expr = verificaTipo(p->filho->tipo_expr, p->filho->irmao->tipo_expr, p->tipo);
            }
            break;

        case CONJ:
        case DISJ:
            p1 = p->filho;
            while (p1) {
                propaga_tipos(p1);
                p1 = p1->irmao;
            }
            if (p->filho && p->filho->irmao) {
                p->tipo_expr = verificaTipo(p->filho->tipo_expr, p->filho->irmao->tipo_expr, p->tipo);
            }
            break;

        case NEG:
            p1 = p->filho;
            if (p1) {
                propaga_tipos(p1);
                p->tipo_expr = verificaUnaria(p1->tipo_expr, NEG);
            }
            break;

        default:
            p1 = p->filho;
            while (p1) {
                propaga_tipos(p1);
                p1 = p1->irmao;
            }
    }
}

void gera_codigo(ptno p) {
    if (p == NULL) return;
    
    ptno p1, p2;
    int aux, pos;
    
    switch(p->tipo) {
        case PRG:
            fprintf(yyout, "\tINPP\n");
            fprintf(yyout, "\tAMEM\t%d\n", NUM_VAR);
            
            p1 = p->filho;
            if (p1 && p1->tipo == IDENT) p1 = p1->irmao;  /* Pula o identificador do programa */
            
            if (p1 && p1->tipo == DVR) {
                gera_codigo(p1);
            }
            
            p2 = p1;
            while (p2 && p2->tipo != LCM) p2 = p2->irmao;
            if (p2) gera_codigo(p2);
            
            fprintf(yyout, "\tDMEM\t%d\n", NUM_VAR);
            fprintf(yyout, "\tFIMP\n");
            break;
            
        case DVR:
            /* DVR já foi processado em coleta_tipos() */
            /* Aqui apenas pulamos durante gera_codigo */
            break;
            
        case LCM:
            p1 = p->filho;
            while (p1) {
                if (p1->tipo != LVR && p1->tipo != TIPO && p1->tipo != DVR) {
                    gera_codigo(p1);
                }
                p1 = p1->irmao;
            }
            break;
            
        case LET:
            fprintf(yyout, "\tLEIA\n");
            p1 = p->filho;
            if (p1 && p1->tipo == IDENT && p1->lexema) {
                pos = buscaSimbolo(p1->lexema);
                fprintf(yyout, "\tARZG\t%d\n", pos);
            }
            break;
            
        case ESC:
            gera_expressao(p->filho);
            fprintf(yyout, "\tESCR\n");
            break;
            
        case ATR:
            p1 = p->filho;
            p2 = p1->irmao;
            gera_expressao(p2);
            if (p1 && p1->tipo == IDENT && p1->lexema) {
                pos = buscaSimbolo(p1->lexema);
                fprintf(yyout, "\tARZG\t%d\n", pos);
            }
            break;
            
        case REP:
            {
                int L1 = ++ROTULO;
                int L2 = ++ROTULO;
                fprintf(yyout, "L%d\tNADA\n", L1);
                gera_expressao(p->filho);
                fprintf(yyout, "\tDSVF\t%d\n", L2);
                gera_codigo(p->filho->irmao);
                fprintf(yyout, "\tDSVS\t%d\n", L1);
                fprintf(yyout, "L%d\tNADA\n", L2);
            }
            break;
            
        case SEL:
            {
                int L1 = ++ROTULO;
                int L2 = ++ROTULO;
                gera_expressao(p->filho);
                fprintf(yyout, "\tDSVF\t%d\n", L1);
                gera_codigo(p->filho->irmao);
                fprintf(yyout, "\tDSVS\t%d\n", L2);
                fprintf(yyout, "L%d\tNADA\n", L1);
                if (p->filho->irmao->irmao) {
                    gera_codigo(p->filho->irmao->irmao);
                }
                fprintf(yyout, "L%d\tNADA\n", L2);
            }
            break;
            
        default:
            p1 = p->filho;
            while (p1) {
                gera_codigo(p1);
                p1 = p1->irmao;
            }
    }
}

void gera_expressao(ptno p) {
    if (p == NULL) return;
    
    int pos;
    
    switch(p->tipo) {
        case NUM:
            fprintf(yyout, "\tCRCT\t%d\n", p->valor);
            break;
        case VAR:
            if (p->lexema) {
                pos = buscaSimbolo(p->lexema);
                fprintf(yyout, "\tCRVG\t%d\n", pos);
            }
            break;
        case VRD:
            fprintf(yyout, "\tCRCT\t1\n");
            break;
        case FLS:
            fprintf(yyout, "\tCRCT\t0\n");
            break;
        case SOMA:
            gera_expressao(p->filho);
            gera_expressao(p->filho->irmao);
            fprintf(yyout, "\tSOMA\n");
            break;
        case SUBT:
            gera_expressao(p->filho);
            gera_expressao(p->filho->irmao);
            fprintf(yyout, "\tSUBT\n");
            break;
        case MULT:
            gera_expressao(p->filho);
            gera_expressao(p->filho->irmao);
            fprintf(yyout, "\tMULT\n");
            break;
        case DIVI:
            gera_expressao(p->filho);
            gera_expressao(p->filho->irmao);
            fprintf(yyout, "\tDIVI\n");
            break;
        case MAI:
            gera_expressao(p->filho);
            gera_expressao(p->filho->irmao);
            fprintf(yyout, "\tCMMA\n");
            break;
        case MEN:
            gera_expressao(p->filho);
            gera_expressao(p->filho->irmao);
            fprintf(yyout, "\tCMME\n");
            break;
        case IGU:
            gera_expressao(p->filho);
            gera_expressao(p->filho->irmao);
            fprintf(yyout, "\tCMIG\n");
            break;
        case CONJ:
            gera_expressao(p->filho);
            gera_expressao(p->filho->irmao);
            fprintf(yyout, "\tCONJ\n");
            break;
        case DISJ:
            gera_expressao(p->filho);
            gera_expressao(p->filho->irmao);
            fprintf(yyout, "\tDISJ\n");
            break;
        case NEG:
            gera_expressao(p->filho);
            fprintf(yyout, "\tNEGA\n");
            break;
    }
}

%}

%union {
    ptno ast;
    char* str;
}

%token T_PROGRAMA T_INICIO T_FIM T_LEIA T_ESCREVA
%token <str> T_IDENTIF
%token T_ENQTO T_FACA T_FIMEQTO T_SE T_ENTAO T_SENAO T_FIMSE
%token T_ATRIB T_VEZES T_DIV T_MAIS T_MENOS T_MAIOR T_MENOR
%token T_IGUAL T_E T_OU T_V T_F T_NUMERO T_NAO T_ABRE T_FECHA
%token T_LOGICO T_INTEIRO

%type <ast> programa cabecalho variaveis declaracao_variaveis tipo
%type <ast> lista_variaveis lista_comandos comando leitura escrita
%type <ast> selecao repeticao atribuicao expressao termo

%start programa

%left T_E T_OU
%left T_IGUAL
%left T_MAIOR T_MENOR
%left T_MAIS T_MENOS
%left T_VEZES T_DIV

%%

programa
    : cabecalho variaveis T_INICIO lista_comandos T_FIM
      {
          $$ = criaNo(PRG, -1);
          adicionaFilho($$, $1);
          if ($2 != NULL) adicionaFilho($$, $2);
          adicionaFilho($$, $4);
          raiz = $$;
      }
    ;

cabecalho : T_PROGRAMA T_IDENTIF { $$ = criaNoLexema(IDENT, $2); };
variaveis : declaracao_variaveis { $$ = $1; } | { $$ = NULL; };

declaracao_variaveis
    : tipo lista_variaveis
      {
          $$ = criaNo(DVR, -1);
          adicionaFilho($$, $1);
          adicionaFilho($$, $2);
      }
    | tipo lista_variaveis declaracao_variaveis
      {
          ptno dvr = criaNo(DVR, -1);
          adicionaFilho(dvr, $1);
          adicionaFilho(dvr, $2);
          adicionaFilho(dvr, $3);
          $$ = dvr;
      }
    ;

tipo : T_INTEIRO { $$ = criaNo(TIPO, 0); } | T_LOGICO { $$ = criaNo(TIPO, 1); };

lista_variaveis
    : T_IDENTIF { $$ = criaNo(LVR, -1); adicionaFilho($$, criaNoLexema(IDENT, $1)); }
    | lista_variaveis T_IDENTIF { adicionaFilho($1, criaNoLexema(IDENT, $2)); $$ = $1; }
    ;

lista_comandos
    : lista_comandos comando { adicionaFilho($1, $2); $$ = $1; }
    | { $$ = criaNo(LCM, -1); }
    ;

comando : leitura | escrita | atribuicao | selecao | repeticao;

leitura : T_LEIA T_IDENTIF { $$ = criaNo(LET, -1); adicionaFilho($$, criaNoLexema(IDENT, $2)); };
escrita : T_ESCREVA expressao { $$ = criaNo(ESC, -1); adicionaFilho($$, $2); };
atribuicao : T_IDENTIF T_ATRIB expressao { $$ = criaNo(ATR, -1); adicionaFilho($$, criaNoLexema(IDENT, $1)); adicionaFilho($$, $3); };
selecao : T_SE expressao T_ENTAO lista_comandos T_SENAO lista_comandos T_FIMSE { $$ = criaNo(SEL, -1); adicionaFilho($$, $2); adicionaFilho($$, $4); adicionaFilho($$, $6); };
repeticao : T_ENQTO expressao T_FACA lista_comandos T_FIMEQTO { $$ = criaNo(REP, -1); adicionaFilho($$, $2); adicionaFilho($$, $4); };

expressao
    : expressao T_MAIS expressao { ptno n = criaNo(SOMA, -1); adicionaFilho(n, $1); adicionaFilho(n, $3); $$ = n; }
    | expressao T_MENOS expressao { ptno n = criaNo(SUBT, -1); adicionaFilho(n, $1); adicionaFilho(n, $3); $$ = n; }
    | expressao T_VEZES expressao { ptno n = criaNo(MULT, -1); adicionaFilho(n, $1); adicionaFilho(n, $3); $$ = n; }
    | expressao T_DIV expressao { ptno n = criaNo(DIVI, -1); adicionaFilho(n, $1); adicionaFilho(n, $3); $$ = n; }
    | expressao T_MAIOR expressao { ptno n = criaNo(MAI, -1); adicionaFilho(n, $1); adicionaFilho(n, $3); $$ = n; }
    | expressao T_MENOR expressao { ptno n = criaNo(MEN, -1); adicionaFilho(n, $1); adicionaFilho(n, $3); $$ = n; }
    | expressao T_IGUAL expressao { ptno n = criaNo(IGU, -1); adicionaFilho(n, $1); adicionaFilho(n, $3); $$ = n; }
    | expressao T_E expressao { ptno n = criaNo(CONJ, -1); adicionaFilho(n, $1); adicionaFilho(n, $3); $$ = n; }
    | expressao T_OU expressao { ptno n = criaNo(DISJ, -1); adicionaFilho(n, $1); adicionaFilho(n, $3); $$ = n; }
    | T_NAO expressao { ptno n = criaNo(NEG, -1); adicionaFilho(n, $2); $$ = n; }
    | termo { $$ = $1; }
    ;

termo
    : T_NUMERO { $$ = criaNo(NUM, atoi(atomo)); }
    | T_IDENTIF { $$ = criaNoLexema(VAR, atomo); }
    | T_V { $$ = criaNo(VRD, 1); }
    | T_F { $$ = criaNo(FLS, 0); }
    | T_ABRE expressao T_FECHA { $$ = $2; }
    ;

%%

void yyerror(char *s) {
    fprintf(stderr, "Erro: %s\n", s);
    exit(1);
}

int main(int argc, char **argv) {
    FILE *entrada, *saida;
    char nome_entrada[256];
    int modo_ast = 0; // 0: MVS (default), 1: AST
    
    if (argc > 1 && strcmp(argv[1], "-ast") == 0) {
        modo_ast = 1;
        argv++;
        argc--;
    }

    if (argc < 2) {
        fprintf(stderr, "Uso: %s [-ast] <arquivo>\n", argv[0]);
        return 1;
    }
    
    strcpy(nome_entrada, argv[1]);
    if (strlen(nome_entrada) < 8 || strcmp(nome_entrada + strlen(nome_entrada) - 8, ".simples") != 0) {
        strcat(nome_entrada, ".simples");
    }
    
    entrada = fopen(nome_entrada, "r");
    if (!entrada) {
        fprintf(stderr, "Erro: arquivo não encontrado: %s\n", nome_entrada);
        return 1;
    }
    
    yyin = entrada;
    
    if (yyparse() == 0 && raiz != NULL) {
        /* Primeira passada: coleta tipos declarados */
        NUM_VAR = 0;
        coleta_tipos(raiz);
        
        /* Segunda passada: propaga tipos nas expressões */
        propaga_tipos(raiz);
        
        /* Verifica se houve erros de tipo */
        if (erro_tipo) {
            fprintf(stderr, "✗ ERRO DE TIPO DETECTADO!\n");
            fprintf(stderr, "  Corrija os erros acima antes de compilar.\n");
            return 1;
        }
        
        if (modo_ast) {
            // MODO AST (Etapa 1)
            char nome_dot[256];
            strcpy(nome_dot, argv[1]);
            strcat(nome_dot, ".dot");
            
            saida = fopen(nome_dot, "w");
            if (saida) {
                fprintf(stderr, "✓ Análise sintática concluída!\n");
                imprimeArvore(raiz, saida);
                fclose(saida);
                fprintf(stderr, "✓ Árvore salva em: %s\n", nome_dot);
                fprintf(stderr, "  Visualize com: dot -Tpng %s -o %s.png\n", nome_dot, argv[1]);
            }
        } else {
            // MODO MVS (Etapa 2)
            char nome_mvs[256];
            strcpy(nome_mvs, argv[1]);
            strcat(nome_mvs, ".mvs");
            
            saida = fopen(nome_mvs, "w");
            yyout = saida;
            
            fprintf(stderr, "✓ Gerando código MVS...\n");
            gera_codigo(raiz);
            fprintf(stderr, "✓ Código gerado em: %s\n", nome_mvs);
            fprintf(stderr, "  Execute com: ./mvs %s\n", argv[1]);
            
            fclose(saida);
        }
        libera(raiz);
    } else {
        fprintf(stderr, "Erro na compilação!\n");
    }
    
    fclose(entrada);
    return 0;
}
