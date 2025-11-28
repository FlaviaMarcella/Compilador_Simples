![](Aspose.Words.c9cdfb38-712a-425a-9397-24ec9dd48750.001.jpeg)![](Aspose.Words.c9cdfb38-712a-425a-9397-24ec9dd48750.002.png)**Universidade Federal de Alfenas - UNIFAL-MG**

Bacharelado em Ciˆencia da Computa¸ca˜o

Prof. Luiz Eduardo da Silva
# **Trabalho de Compiladores**
**Constru¸c˜ao da Arvore Sint´atica e Gera¸c˜ao de C´odigo´**
## **Objetivo**
Essa pra´tica pode ser dividade em duas etapas: (1) objetivo da primeira etapa do projeto do compilador ´e construir a a´rvore sinta´tica para o programa em linguagem Simples. (2) Em sequˆencia, a partir da ´arvore gerada, atrav´es do percurso na Arvore Sint´atica (AS) constru´ıda´ na etapa anterior, gerar o c´odigo MVS correspondente.
## **Problema**
A ana´lise sinta´tica ´e a fase da compila¸ca˜o respons´avel por verificar se a sequˆencia de tokens, retornados pelo analisador l´exico, segue as regras sinta´ticas da linguagem de programa¸c˜ao. Como resultado final da etapa de ana´lise sinta´tica pode-se construir uma estrutura de dados denominada ´arvore sinta´tica que ´e uma simplifica¸ca˜o da a´rvore de deriva¸ca˜o e que representa a estrutura do programa. A a´rvore sint´atica possibilita que o mesmo programa possa ser percorrido v´arias vezes para realiza¸c˜ao de diversas tarefas como verifica¸ca˜o de tipo, gera¸ca˜o de co´digo, etc.
## **Descri¸c˜ao**
### **Primeira Etapa**
1\. Nessa primeira etapa da constru¸ca˜o do compilador para linguagem Simples, vocˆe devera´, a partir do programa fonte, construir a ´arvore sint´atica conforme ilustrado nas Figuras 1, 2 e 3.

Programa 1: Programa para calcular o dobro

![ref1]

1. programa dobro
1. inteiro n
1. inicio
1. leia n
1. escreva 2 \* n
1. fimprograma

![ref1]

2\. Para a implementa¸c˜ao desse trabalho sugere-se modificar o projeto do compilador (parte 3) para gerar a a´rvore sint´atica, ao inv´es de gerar o co´digo MVS das estruturas do programa.

Programa 2: Programa para calcular o fatorial

![ref1]

1. programa	fatorial
1. inteiro n fat
1. inicio

programa



identificador

dobro

declaracao de variaveis



lista comandos



tipo

inteiro

lista variaveis



identificador

n

leitura



lista comandos



identificador

n

escrita



multiplica



numero

2

variavel

n

![](Aspose.Words.c9cdfb38-712a-425a-9397-24ec9dd48750.004.png)

Figura 1: Arvore sinta´tica do programa para calcular o dobro´

1. leia n
1. fat *<*<sup>=</sup> 1
1. enquanto n *>* 0 faca
1. fat *<*<sup>=</sup> fat \* n
1. n *<*<sup>=</sup> n <sup>=</sup> 1
1. fimenquanto
1. escreva	fat
1. fimprograma

![ref1]

![](Aspose.Words.c9cdfb38-712a-425a-9397-24ec9dd48750.005.png)

Figura 2: Arvore sinta´tica do programa Fatorial´

Programa 3: Programa para calcular o maior

![ref1]

1. programa maior
1. inteiro a b
1. inicio
1. leia a 5	leia b
6. se nao (a *<* b)
6. entao	escreva a 8	senao escreva b
9. fimse
9. fimprograma

![ref1]

![](Aspose.Words.c9cdfb38-712a-425a-9397-24ec9dd48750.006.png)

Figura 3: Arvore sinta´tica do programa Maior´

3\. Dever´a ser utilizada a estrutura de a´rvore n-a´ria, conforme declara¸co˜es seguintes:

![ref1]

`	`1	typedef	struct no \*ptno ;

2

3. struct no {
3. int	tipo ;
3. int	valor ;

![](Aspose.Words.c9cdfb38-712a-425a-9397-24ec9dd48750.007.png)	ptno	filho ,	irmao ;

;

8

9. ptno criaNo ( int	tipo ,	int	valor ) {
9. ptno n = (ptno) malloc ( sizeof	( struct no ));
9. n=*>*valor = valor ;
9. n=*>*tipo = tipo ;
9. n=*>*filho = NULL;
9. n=*>*irmao = NULL;

`	`![](Aspose.Words.c9cdfb38-712a-425a-9397-24ec9dd48750.008.png)	return n;

18. void	adicionaFilho	(ptno pai ,	ptno	filho ) {
18. i f	( filho ) {
18. filho =*>*irmao = pai=*>*filho ;
18. pai=*>*filho = filho ;

![](Aspose.Words.c9cdfb38-712a-425a-9397-24ec9dd48750.009.png)

4. A sa´ıda dessa etapa do projeto devera´ ser a sequˆencia de comandos para desenhos degra´ficos no formato .DOT (graphViz). Uma descri¸ca˜o completa da ferramenta usada para gerar ilustra¸co˜es pode ser obtida em ”https://www.graphviz.org/pdf/dotguide.pdf”. Por exemplo, a sequˆencia de comandos para constru¸ca˜o da a´rvore sinta´tica do programa DOBRO ´e:

   ![ref1]

   1. digraph {
   1. node [ shape=record ,	height =.1];

|3|n0x600086260|[ label = ”programa |	”];||||
| :- | :- | :- | :- | :- | :- |
|4|n0x600085e20|[ label = ” identificador	|	dobro ”];||||
|5|n0x600085f40|[ label = ”declaracao de variaveis|||”];||
|6|n0x600085e50|[ label = ”tipo	|	inteiro ”];||||
|7|n0x600085ef0|[ label = ” lista	variaveis||	”];|||
|8|n0x600085ea0|[ label = ” identificador	||n ”];|||
|9|n0x600086210|[ label = ” lista	comandos ||”];|||
|10|n0x600085fe0|[ label = ” leitura	|	”];||||
|11|n0x600085f90|[ label = ” identificador	||n ”];|||
|12|n0x6000861c0|[ label = ” lista	comandos ||”];|||
|13|n0x600086170|[ label = ” escrita	|	”];||||
|14|n0x600086120|[ label = ” multiplica	|	”];||||
|15|n0x600086030|[ label = ”numero |	2”];||||
|16|n0x6000860d0|[ label = ” variavel	| n ”];||||
|17|n0x600086260 =*>* n0x600085e20 ;|||||
|18|n0x600086260 =*>* n0x600085f40 ;|||||
|19|n0x600085f40 =*>* n0x600085e50 ;|||||
|20|n0x600085f40 =*>* n0x600085ef0 ;|||||
|21|n0x600085ef0 =*>* n0x600085ea0 ;|||||
|22|n0x600086260 =*>* n0x600086210 ;|||||
|23|n0x600086210 =*>* n0x600085fe0 ;|||||
|24|n0x600085fe0 =*>* n0x600085f90 ;|||||
|25|n0x600086210 =*>* n0x6000861c0 ;|||||
![](Aspose.Words.c9cdfb38-712a-425a-9397-24ec9dd48750.010.png)n0x6000861c0 =*>* n0x600086170 ; n0x600086170 =*>* n0x600086120 ; n0x600086120 =*>* n0x600086030 ; ![](Aspose.Words.c9cdfb38-712a-425a-9397-24ec9dd48750.011.png)n0x600086120 =*>* n0x6000860d0 ;

![ref1]

4. Para compor o nome dos no´s utilizou-se, nesse exemplo, o endere¸co hexadecimal dosponteiros dos no´s. Neste caso, n0x600086260 foi gerado com o seguinte comando:

   ![ref1]

`	`1	printf	(”\tn%p” ,	raiz );

![ref1]

6\. Para verificar graficamente a a´rvore constru´ıda, pode-se usar o comando, como por exemplo, ”dot -Tsvg dobro.dot -o dobro.svg”. Neste exemplo, o arquivo *dobro.dot* ´e o arquivo texto que cont´em a sequˆencia apresentada anteriormente. O gr´afico gerado pode ser aberto num navegador, pois o formato SVG (Scalable Vector Graphic) ´e um formato de imagens vetoriais que podem ser utilizadas em p´aginas HTML.
### **Segunda Etapa**
1. Nessa segunda etapa da constru¸ca˜o do compilador para linguagem Simples, vocˆe devera´, apartir da a´rvore sinta´tica constru´ıda na etapa anterior, gerar o c´odigo correspondente para MVS do programa fonte representado na ´arvore sinta´tica. As Figuras 4 e 5 representam trechos da ´arvore sinta´tica referente a um programa simples qualquer.
1. Para o percurso na a´rvore sugere-se a implementa¸c˜ao da rotina recursiva *geracod*, que recebe como paraˆmetro um ponteiro de n´o da a´rvore sint´atica. Para cada tipo de no´ devera˜o ser feitas as tradu¸co˜es e as chamadas recursivas correspondentes para aquele trecho da ´arvore. Por exemplo, para os trechos da AS das Figuras 4 e 5, a rotina *geracod* que gera co´digo MVS (ma´quina virtual simples) tem o seguinte tratamento:

![](Aspose.Words.c9cdfb38-712a-425a-9397-24ec9dd48750.012.png)

Figura 4: Trecho da ´arvore referente a estrutura principal do programa

![](Aspose.Words.c9cdfb38-712a-425a-9397-24ec9dd48750.013.png)

Figura 5: Trecho da ´arvore referente a repeti¸ca˜o

![ref1]

1. void geracod (ptno p) {
1. i f	(p == NULL) return ;
1. ptno p1 , p2 , p3 ; 4 switch (p=*>*tipo ) {
5. case PRG:
5. p1 = p=*>*filho ;
5. p2 = p1=*>*irmao ;
5. p3 = p2=*>*irmao ;
5. printf	(”\tINPP\n”);
5. NUMVAR = 0;
5. geracod (p2 );
5. geracod (p3 );
5. printf	(”\tFIMP\n”);
5. break ;
5. ( . . . )
5. case REP:
5. p1 = p=*>*filho ;
5. p2 = p1=*>*irmao ;
5. printf	(”L%d\tNADA\n” , ++ROTULO);
5. empilha (ROTULO);
5. geracod (p1 );
5. printf	(”\tDSVF\tL%d\n”,++ROTULO);
5. empilha (ROTULO);
5. geracod (p2 );
5. aux = desempilha ();
5. printf	(”\tDSVS\tL%d\n” , desempilha ());
5. printf	(”L%d\tNADA\n” , aux );
5. break ;

![](Aspose.Words.c9cdfb38-712a-425a-9397-24ec9dd48750.014.png)( . . . )

3. Observe na Figura 4 que o no´ do tipo PRG (Programa) tem trˆes filhos: o nome doprograma para a qual n˜ao ´e necess´aria nenhuma tradu¸ca˜o, a declarac¸˜ao de varia´veis (DVR) e a lista de comandos do corpo principal do programa (LCM). As chamadas recursivas para tradu¸ca˜o de DVR e LCM s˜ao colocadas entre a gera¸ca˜o dos co´digo INPP e FIMP da MVS para o in´ıcio e o fim do programa.
3. O no´ do tipo REP (repeti¸ca˜o) da Figura 5 tem dois filhos: uma express˜ao (condi¸ca˜o darepeti¸ca˜o, que no exemplo ´e a compara¸c˜ao maior, MAI) e a lista de comandos (LCM) da repeti¸ca˜o. A gera¸ca˜o dos r´otulos e os comandos de desvio (DSVS e DSVF) esta˜o colocados nos locais apropriados para a traduc¸˜ao.
3. A sa´ıda dessa etapa do projeto devera´ ser o co´digo MVS correspondente ao programafonte em linguagem Simples.
3. Como uma etapa adicional, pode-se percorrer a ´arvore novamente para realizar as verifica¸co˜es de tipo.
## **Entrega**
1\. Incluir um comenta´rio no cabe¸calho de cada programa fonte com o seguinte formato:

![ref1]

1. /\*+=============================================================
1. | UNIFAL = Universidade Federal de Alfenas . 3 | BACHARELADO EM CIENCIA DA COMPUTACAO.

|4|`	`|	Trabalho . . :|Construcao Arvore	Sintatica e Geracao de Codigo|
| :- | :- | :- |
|5|`	`|	Disciplina :|Teoria de Linguagens e Compiladores|
|6|`	`|	Professor . :|Luiz Eduardo da Silva|
|7|| Aluno . . . . . :|Fulano da Silva|
|8|| Data . . . . . . :|99/99/9999|

`	`<sub>9</sub>	+=============================================================\*/

![ref1]

2\. A pasta com o projeto dever´a incluir o seguinte arquivo Makefile:

![ref1]

1. simples	:	utils . c	lexico . l	sintatico . y ;
1. @flex =o lexico . c	lexico . l
1. @bison =v =d sintatico . y =o sintatico . c
1. @gcc lexico . c	sintatico . c =o simples
1. limpa	:	;
1. @echo ”limpando . . . ”
1. @rm lexico . c	sintatico . c	sintatico .h sintatico . output simples

![ref1]

3\. O compilador devera´ ter o nome ”simples”(linux) ou ”simples.exe”(windows) e ser chamado atrav´es da seguinte linha de comando:

![ref1]

`	`1	./ simples *<*nomeprograma *>*[. simples ]

![ref1]

A partir deste comando devera˜o ser gerados os arquivos ¡nomeprograma¿.dot, ¡nomeprograma¿.svg e ¡nomeprograma¿.mvs.

4\. Enviar num arquivo u´nico (.ZIP), a pasta do projeto com somente os arquivos fontes (lexico.l, sintatico.y, tree.c, tree.h, utils.c e makefile), atrav´es do Envio de Arquivo do

MOODLE.
8

[ref1]: Aspose.Words.c9cdfb38-712a-425a-9397-24ec9dd48750.003.png
