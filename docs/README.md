# 🎓 Compilador para Linguagem Simples - UNIFAL-MG

## 📝 Trabalho de Compiladores
**Construção da Árvore Sintática e Geração de Código MVS**

---

## 👥 Informações do Projeto

- **Universidade**: UNIFAL - Universidade Federal de Alfenas
- **Curso**: Bacharelado em Ciência da Computação
- **Disciplina**: Teoria de Linguagens e Compiladores
- **Professor**: Luiz Eduardo da Silva

---

## 📋 Descrição

Este projeto implementa um compilador completo para a linguagem **Simples**, com duas funcionalidades principais:

1. **Análise Sintática e Construção da AST**: Gera a árvore sintática abstrata em formato DOT (GraphViz)
2. **Geração de Código MVS**: Produz código intermediário para a Máquina Virtual Simples

---

## 📂 Estrutura do Projeto

```
compilador_simpless/
├── src/                    # Código-fonte
│   ├── tree.c / tree.h     # Estrutura de árvore sintática
│   ├── utils.c / utils.h   # Tabela de símbolos e utilitários
│   ├── sintatico.y         # Parser (Bison)
│   ├── lexico_ast.l        # Analisador léxico (Flex)
│   └── mvs.c               # Máquina Virtual Simples
│
├── build/                  # Arquivos compilados
│   ├── compilador          # Executável do compilador
│   ├── mvs                 # Executável da MVS
│   └── *.o                 # Arquivos objeto
│
├── tests/                  # Programas de teste
│   ├── dobro.simples       # Calcula o dobro de um número
│   ├── fatorial.simples    # Calcula o fatorial
│   └── maior.simples       # Encontra o maior entre dois números
│
├── docs/                   # Documentação
│   ├── README.md           # Este arquivo
│   └── ESTRUTURA.md
│
└── Makefile                # Sistema de build
```

---

## 🚀 Como Usar

### **Compilação**

```bash
# Compilar o projeto completo
make all

# Limpar arquivos de build
make clean

# Executar todos os testes
make test

# Mostrar ajuda
make help
```

### **Execução (Modo Simplificado - Recomendado)**

O projeto inclui um script wrapper `simples` que automatiza todo o processo:

```bash
# Compilar e executar automaticamente
echo "5" | ./simples tests/dobro

# Gerar apenas a árvore sintática
./simples -ast tests/fatorial

# Gerar apenas o código MVS
./simples -mvs tests/maior

# Ver ajuda
./simples --help
```

**Vantagens do script `simples`:**
- ✅ Compila automaticamente se necessário
- ✅ Busca arquivos em `tests/` automaticamente
- ✅ Gera PNG da árvore automaticamente (se GraphViz estiver instalado)
- ✅ Output colorido e organizado
- ✅ Tratamento de erros inteligente

### **Execução (Modo Manual)**

#### **Modo 1: Gerar Árvore Sintática (AST)**
```bash
./build/compilador -ast tests/dobro
# Gera: tests/dobro.dot
```

Visualizar árvore:
```bash
dot -Tpng tests/dobro.dot -o tests/dobro.png
```

#### **Modo 2: Gerar Código MVS**
```bash
./build/compilador tests/dobro
# Gera: tests/dobro.mvs
```

#### **Modo 3: Executar Programa**
```bash
echo "5" | ./build/mvs tests/dobro
# Saída: 10
```

---

## 📊 Testes

### **Programa: dobro.simples**
Calcula o dobro de um número.

```
Entrada: 5
Saída: 10
Status: ✅ PASSOU
```

### **Programa: fatorial.simples**
Calcula o fatorial de um número.

```
Entrada: 5
Saída: 120
Status: ✅ PASSOU
```

### **Programa: maior.simples**
Encontra o maior entre dois números.

```
Entrada: 10, 20
Saída: 20
Status: ✅ PASSOU
```

---

## 🛠️ Dependências

- **GCC** - Compilador C
- **Flex** - Gerador de analisadores léxicos
- **Bison** - Gerador de parsers
- **GraphViz** (opcional) - Para visualizar árvores sintáticas
- **Make** - Sistema de build

### Instalação no Ubuntu/Debian:
```bash
sudo apt-get install gcc make flex bison graphviz
```

---

## 📖 Documentação Adicional

- **[ESTRUTURA.md](ESTRUTURA.md)** - Descrição detalhada da estrutura do projeto
---

## 📄 Licença

Este projeto foi desenvolvido para fins educacionais como parte do curso de Teoria de Linguagens e Compiladores da UNIFAL-MG.

---

**Data de Entrega**: Novembro/2025  
**Status**: ✅ Completo e Funcional
