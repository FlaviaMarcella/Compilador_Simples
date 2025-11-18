# ============================================================
# Makefile - Compilador para Linguagem Simples
# UNIFAL - Universidade Federal de Alfenas
# ============================================================

.PHONY: all clean help test

# ============ CONFIGURAÇÕES ============
CC = gcc
CFLAGS = -Wall -g
LEX = flex
YACC = bison
YFLAGS = -v -d

# ============ DIRETÓRIOS ============
SRC_DIR = src
BUILD_DIR = build
TESTS_DIR = tests
DOCS_DIR = docs

# ============ ARQUIVOS DE SAÍDA ============
COMPILADOR = $(BUILD_DIR)/compilador
MVS = $(BUILD_DIR)/mvs

# ============ ARQUIVOS FONTE ============
TREE_SRC = $(SRC_DIR)/tree.c
UTILS_SRC = $(SRC_DIR)/utils.c
MVS_SRC = $(SRC_DIR)/mvs.c
LEXICO_L = $(SRC_DIR)/lexico_ast.l
SINTATICO_Y = $(SRC_DIR)/sintatico.y

# ============ ARQUIVOS INTERMEDIÁRIOS ============
LEXICO_C = $(BUILD_DIR)/lexico.c
SINTATICO_C = $(BUILD_DIR)/sintatico.c
SINTATICO_H = $(BUILD_DIR)/sintatico.h

# ============ OBJETOS ============
TREE_O = $(BUILD_DIR)/tree.o
UTILS_O = $(BUILD_DIR)/utils.o
LEXICO_O = $(BUILD_DIR)/lexico.o
SINTATICO_O = $(BUILD_DIR)/sintatico.o

OBJETOS = $(TREE_O) $(UTILS_O) $(LEXICO_O) $(SINTATICO_O)

# ============ REGRA PADRÃO ============
all: $(COMPILADOR) $(MVS)
	@echo ""
	@echo "===================================================="
	@echo "  ✓ Compilação concluída com sucesso!"
	@echo "===================================================="
	@echo ""
	@echo "Uso:"
	@echo "  $(COMPILADOR) -ast <programa>  - Gera árvore sintática (.dot)"
	@echo "  $(COMPILADOR) <programa>       - Gera código MVS (.mvs)"
	@echo "  $(MVS) <programa>              - Executa código MVS"
	@echo ""

# ============ COMPILADOR ============
$(COMPILADOR): $(OBJETOS) | $(BUILD_DIR)
	@echo "[5/5] Linkando compilador..."
	$(CC) $(OBJETOS) -o $(COMPILADOR) -lm
	@echo "✓ Compilador construído: $(COMPILADOR)"

# ============ MÁQUINA VIRTUAL ============
$(MVS): $(MVS_SRC) | $(BUILD_DIR)
	@echo "[MVS] Compilando máquina virtual..."
	$(CC) $(CFLAGS) $(MVS_SRC) -o $(MVS)
	@echo "✓ MVS construída: $(MVS)"

# ============ OBJETOS ============
$(TREE_O): $(TREE_SRC) $(SRC_DIR)/tree.h | $(BUILD_DIR)
	@echo "[1/5] Compilando tree.c..."
	$(CC) $(CFLAGS) -c $(TREE_SRC) -o $(TREE_O)

$(UTILS_O): $(UTILS_SRC) $(SRC_DIR)/utils.h | $(BUILD_DIR)
	@echo "[2/5] Compilando utils.c..."
	$(CC) $(CFLAGS) -c $(UTILS_SRC) -o $(UTILS_O)

$(SINTATICO_O): $(SINTATICO_C) | $(BUILD_DIR)
	@echo "[4/5] Compilando sintatico.c..."
	$(CC) $(CFLAGS) -I$(BUILD_DIR) -I$(SRC_DIR) -c $(SINTATICO_C) -o $(SINTATICO_O)

$(LEXICO_O): $(LEXICO_C) | $(BUILD_DIR)
	@echo "[5/5] Compilando lexico.c..."
	$(CC) $(CFLAGS) -I$(BUILD_DIR) -I$(SRC_DIR) -c $(LEXICO_C) -o $(LEXICO_O)

# ============ GERAÇÃO DE CÓDIGO ============
$(SINTATICO_C) $(SINTATICO_H): $(SINTATICO_Y) $(SRC_DIR)/tree.h $(SRC_DIR)/utils.h | $(BUILD_DIR)
	@echo "[3/5] Gerando analisador sintático..."
	$(YACC) $(YFLAGS) $(SINTATICO_Y) -o $(SINTATICO_C)
	@mv $(BUILD_DIR)/sintatico.output $(BUILD_DIR)/ 2>/dev/null || true

$(LEXICO_C): $(LEXICO_L) $(SINTATICO_H) | $(BUILD_DIR)
	@echo "[4/5] Gerando analisador léxico..."
	$(LEX) -o $(LEXICO_C) $(LEXICO_L)

# ============ DIRETÓRIOS ============
$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

# ============ LIMPEZA ============
clean:
	@echo "Limpando arquivos de build..."
	@rm -rf $(BUILD_DIR)
	@echo "✓ Limpeza concluída!"

# ============ TESTES ============
test: all
	@echo ""
	@echo "===================================================="
	@echo "  Executando testes..."
	@echo "===================================================="
	@echo ""
	@echo "=== TESTE 1: DOBRO ==="
	@$(COMPILADOR) -ast $(TESTS_DIR)/dobro
	@$(COMPILADOR) $(TESTS_DIR)/dobro
	@echo "5" | $(MVS) $(TESTS_DIR)/dobro
	@echo ""
	@echo "=== TESTE 2: FATORIAL ==="
	@$(COMPILADOR) -ast $(TESTS_DIR)/fatorial
	@$(COMPILADOR) $(TESTS_DIR)/fatorial
	@echo "5" | $(MVS) $(TESTS_DIR)/fatorial
	@echo ""
	@echo "=== TESTE 3: MAIOR ==="
	@$(COMPILADOR) -ast $(TESTS_DIR)/maior
	@$(COMPILADOR) $(TESTS_DIR)/maior
	@echo -e "10\n20" | $(MVS) $(TESTS_DIR)/maior
	@echo ""
	@echo "✓ Todos os testes concluídos!"

# ============ AJUDA ============
help:
	@echo "===================================================="
	@echo "  Compilador para Linguagem Simples - UNIFAL"
	@echo "===================================================="
	@echo ""
	@echo "Targets disponíveis:"
	@echo "  make all    - Compila o compilador e a MVS"
	@echo "  make clean  - Remove arquivos de build"
	@echo "  make test   - Executa todos os testes"
	@echo "  make help   - Mostra esta mensagem"
	@echo ""
	@echo "Script wrapper (recomendado):"
	@echo "  ./simples <programa>     - Compila e executa"
	@echo "  ./simples -ast <prog>    - Gera apenas AST"
	@echo "  ./simples -mvs <prog>    - Gera apenas MVS"
	@echo "  ./simples --help         - Ajuda do script"
	@echo ""
	@echo "Estrutura do projeto:"
	@echo "  src/    - Código-fonte (.c, .h, .y, .l)"
	@echo "  build/  - Arquivos compilados (.o, executáveis)"
	@echo "  tests/  - Programas de teste (.simples)"
	@echo "  docs/   - Documentação (.md)"
	@echo ""
