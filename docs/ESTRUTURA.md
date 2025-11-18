# 📁 ESTRUTURA DO PROJETO - Compilador Simples

```
compilador_simpless/
│
├── 📄 Makefile              # Build system (renovado e organizado)
├── 📋 README.md             # Documentação do projeto
│
├── 🔧 FERRAMENTAS E UTILITÁRIOS
│   ├── lexico_ast.l         # Analisador léxico (Flex)
│   ├── sintatico1.y         # Parser - ETAPA 1 (Bison)
│   ├── sintatico2.y         # Parser - ETAPA 2 (Bison)
│   ├── tree.c/tree.h        # Estrutura de árvore sintática
│   ├── utils.c              # Funções utilitárias
│   └── mvs.c                # Máquina virtual
│
├── 📝 PROGRAMAS DE TESTE
│   ├── dobro.simples        # Programa de teste 1
│   ├── fatorial.simples     # Programa de teste 2
│   └── maior.simples        # Programa de teste 3
│
├── 🏗️ GERADOS AUTOMATICAMENTE (após compilação)
│   ├── compilador_ast       # Executável - ETAPA 1
│   ├── compilador_mvs       # Executável - ETAPA 2
│   ├── mvs                  # Executável - MVS
│   ├── lexico.c             # Gerado por Flex
│   ├── lexico2.c            # Gerado por Flex
│   ├── sintatico.c/h        # Gerado por Bison
│   ├── sintatico2.c/h       # Gerado por Bison
│   ├── *.o                  # Arquivos objeto
│   └── *.output             # Arquivos de debug do Bison
│
└── 📊 SAÍDAS (arquivos gerados pelos programas)
    ├── *.dot                # Árvore sintática (GraphViz)
    ├── *.mvs                # Código MVS intermediário
    └── *.svg/png            # Visualizações gráficas
```

---

## 📊 FLUXO DE EXECUÇÃO

```
┌──────────────────────────────────────────────────────────────┐
│  PROGRAMA FONTE (arquivo.simples)                            │
└──────────────────┬───────────────────────────────────────────┘
                   │
                   ▼
┌──────────────────────────────────────────────────────────────┐
│  ETAPA 1: ANÁLISE SINTÁTICA                                  │
│  ./compilador_ast arquivo.simples                            │
│  ├─ Análise léxica (lexico_ast.l)                           │
│  ├─ Análise sintática (sintatico1.y)                        │
│  └─ Construção de árvore (tree.c)                           │
└──────────────────┬───────────────────────────────────────────┘
                   │
                   ▼
         ┌─────────────────┐
         │ arquivo.dot     │ ◄─── Árvore sintática (GraphViz)
         └─────────────────┘
                   │
                   ▼
┌──────────────────────────────────────────────────────────────┐
│  ETAPA 2: GERAÇÃO DE CÓDIGO                                  │
│  ./compilador_mvs arquivo.simples                            │
│  ├─ Análise léxica (lexico_ast.l)                           │
│  ├─ Análise sintática (sintatico2.y)                        │
│  └─ Geração de código (gera_codigo)                         │
└──────────────────┬───────────────────────────────────────────┘
                   │
                   ▼
      ┌────────────────────────┐
      │ arquivo.simples.mvs    │ ◄─── Código MVS intermediário
      └────────────────────────┘
                   │
                   ▼
┌──────────────────────────────────────────────────────────────┐
│  ETAPA 3: EXECUÇÃO                                           │
│  ./mvs arquivo.simples                                       │
│  ├─ Carrega código MVS                                      │
│  ├─ Aloca memória (AMEM)                                    │
│  ├─ Executa instruções                                      │
│  └─ Dealoca memória (DMEM)                                  │
└──────────────────┬───────────────────────────────────────────┘
                   │
                   ▼
        ┌──────────────────────┐
        │  SAÍDA DO PROGRAMA   │
        └──────────────────────┘
```

---

## 🚀 COMMANDS RÁPIDOS

| Comando | Descrição |
|---------|-----------|
| `make help` | Exibe ajuda |
| `make all` | Compila tudo |
| `make etapa1` | Etapa 1 (análise) |
| `make etapa2` | Etapa 2 (código) |
| `make mvs` | Máquina virtual |
| `make clean` | Limpa temporários |
| `make distclean` | Remove tudo |
| `make info` | Mostra config |

---

## 📋 EXEMPLO DE USO COMPLETO

```bash
# 1. Compilar tudo
make all

# 2. Teste 1: Gerar árvore sintática
./compilador_ast dobro
dot -Tpng dobro.dot -o dobro.png
start dobro.png

# 3. Teste 2: Gerar código MVS
./compilador_mvs dobro
cat dobro.simples.mvs

# 4. Teste 3: Executar programa
echo "3" | ./mvs dobro.simples

# 5. Limpar
make clean
```

---

## 🔍 ARQUIVOS PRINCIPAIS

### **Entrada**
- `lexico_ast.l` - Definição de tokens
- `sintatico1.y` - Gramática (etapa 1)
- `sintatico2.y` - Gramática (etapa 2)
- `tree.c/h` - Estrutura de dados

### **Gerados**
- `compilador_ast` - Analisador sintático
- `compilador_mvs` - Gerador de código
- `mvs` - Máquina virtual

### **Testes**
- `dobro.simples` - Calcula dobro de um número
- `fatorial.simples` - Calcula fatorial
- `maior.simples` - Encontra maior entre dois números

---

## 📦 DEPENDÊNCIAS

- `win_flex.exe` (Flex) - Gerador de analisadores léxicos
- `win_bison.exe` (Bison) - Gerador de parsers
- `gcc` - Compilador C
- `make` - Build automation

**Instale com:**
```bash
# WinFlexBison
# https://github.com/lexxmark/winflexbison/releases

# MinGW (gcc, make)
choco install mingw
```
