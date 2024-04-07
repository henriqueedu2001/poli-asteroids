# A S T R O G E N I U S
O **Astrogenius** é uma reprodução simplificada, para sintetização em uma **placa FPGA**, do clássico jogo de arcade "Asteroids", onde o jogador controla uma nave espacial em um campo de asteróides e deve destruí-los enquanto evita colisões.

**Autores**<br>
- [Felipe Luis Korbes](https://github.com/luis-fk)
- [Henrique S. Souza](https://github.com/henriqueedu2001)
- [João Felipe Souza Melo](https://github.com/jofe2003)

O game foi projetado para ser implementado na forma de um arcade, com um controle de jogador fixo na carcaça e um monitor que exibe a informação gráfica. A lógica do jogo é implementada integralmente numa **placa FPGA Cyclone V 5CEBA4F23C7N Device**.

- [Como usar este repositório?](#como-usar-este-repositório)
- [Teste com fitas binárias](#teste-com-fitas-binárias)
- [Transmissão serial de dados](#transmissão-serial-de-dados)
- [Decodificação das Slices](#decodificação-das-slices)
- [Decodificação das Posições](#decodificação-das-posições)
- [Decodificação da direção](#decodificação-da-direção)

## Como usar este repositório?
Esse repositório engloba três elementos:
- Descrição do hardware, que será utilizada na sintetização na placa FPGA, 
- Módulo de comunicação serial UART, para transmissão de dados FPGA ---> monitor
- Software gráfico, responsável por renderizar na tela os dados recebidos pela placa no monitor

O projeto está atualmente (07/04/2024) em sua versão v2.0. Recomenda-se baixar a versão mais recente desse repositório, que pode ser feito. Mas, há outras versões completas e funcionais, que podem ser também obtidas (veja [releases](https://github.com/henriqueedu2001/poli-asteroids/releases)). 

Escolhida a versão adequada, baixe o repositório no seu diretório. A forma mais direta é por meio de um clone do git:

```
git clone --branch <version> --depth 1 https://github.com/henriqueedu2001/poli-asteroids.git
```

Sendo \<version\> a versão escolhida por vocẽ. Por exemplo, para v2.0 (recomendado), o comando fica:

```
git clone --branch v2.0 --depth 1 https://github.com/henriqueedu2001/poli-asteroids.git
```

## Teste com fitas binárias
Os dados para renderização do jogo saem de uma placa FPGA, via transmissão serial. No entanto, para fins de teste e demonstração do software gráfico, esse projeto conta com um **modo de debug** capaz de ler os dados a partir de um arquivo pré-definido. Assim, é possível emular uma receção de dados sem necessariamente realizar a montagem física do projeto.

Cada arquivo desse tipo, que contém a informação é dito uma fita binária, que nada mais é que uma especificação de quais bytes serão enviados para o software. Elas são armazenadas no diretório `bytetapes`. Ao rodar o jogo em modo de debug, a fita binária recebida por padrão é a `in_default`, que demonstra uma navegação básica pelo menu do jogo e o gameplay.

Há fitas pré-configuradas nesse diretório, para rodar em modo de depuração. Mas, você pode criar suas próprias fitas binárias, para simular qualquer configuração de jogo. As fitas são escritas num formato `.bin`, que possui uma sintaxe projetada ad-hoc.

Para exemplificar, a fita `in_default.bin` está exibida abaixo.

```
# FITA PADRÃO DE TESTE
# para fazer comentários, utilize os símbolos # ou // 

input f0 # initial menu
input f4 # gameplay

input # bloco 01
01 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00 
00 00 00 41 41 41 41 41
41 41 41

input # bloco 02
02 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00 
00 00 00 41 41 41 41 41
41 41 41

# [...]

input # bloco 08
02 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00 
00 00 00 41 41 41 41 41
41 41 41
```

Para cada conjunto de recepção de dados, escreva o token `input`; para transmissão, use `output`. O compilador aceita também que esses tokens estejam em caixa alta. Portanto, `INPUT` e `OUTPUT` são tokens válidos. Em seguida, escreva o conteúdo do bloco em hexadecimal. O compilador dessa linguagem aceita hexadecimais escritos em diversas formas diferentes, com dígitos tanto maísculos como minúsculos. Algumas sequências hexadecimais válidas incluem:

- ```4f 5a 2b ff``` (dígitos minúsculos)

- ```B4 3C 2A 43 57``` (dígitos maísculos)

- ```B6 7A f3 5b``` (dígitos minúsculos e maísculos)

- ```B 6 7A f3d C5b``` (dígitos minúsculos e maísculos e espaçamento irregular)

- ```B 6 7A \n f3d C5b``` (dígitos minúsculos e maísculos e espaçamento irregular e quebra de linha)

Não há nenhuma preferência ou prejuízo em optar-se por dígitos hexadecimais maísculos ou minúsculos.
A condição mais importante para a leitura da fita é a garantia de que a quantidade total de dígitos hexadecimais seja um número par. Caso seja um número ímpar, o software fará uma leitura inadequada da fita. O compilador ignora espaços e quebras de linha, portanto não há necessidade de o bloco estar organizado em algum padrão específico. Mas, para fins de melhor visualização e manipulação das fitas, recomenda-se escrevê-las de forma organizada, com dígitos de um mesmo byte agrupados, espaçamento regular e uma estrutura de tabela

Além disso, o compilador de fitas binárias possui suporte para comentários no formato clássico do python e do C++. Para declarar um comentário, empregue uma das seguintes sintaxes:

```
# <comment>
```

ou 

```
// <comment>
```

O que está do lado à direita dos tokens de comentários ('#' e '//') será ignorado até a próxima quebra de linha. O que estiver do lado à esquerda do token será incorporado na fita binária. Por exemplo, em:

```
input
8f 45 1c 34 # primeiros bytes
```

A parte `8f 45 1c 34` será considerada, mas `# primeiros bytes` será ignorada.

O compilador não suporta comentários que começam numa linha e terminam em outra. Portanto, faça comentários de uma única linha.

## Transmissão serial de dados
A transmissão de dados da placa FPGA para a o software da interface gráfica se dá por meio de uma comunicação serial, mediada por uma UART. Como a recepção de dados ocorre byte a byte, desenvolveu-se um protocolo de comunicação próprio que permitiu a recepção de um conjunto de dados de 43 bytes de informação. Esse protocolo consistiu em criar um bloco de transmissão de 51 bytes, no qual os primeiros 43 bytes formam um bloco de dados, representativo da informação do estado do jogo, e os últimos 8 bytes representam o fim do bloco, sequência denominada do projeto de **break point**.

|          | **00** | **01** | **02** | **03** | **04** | **05** | **06** | **07** | 
|----------|--------|--------|--------|--------|--------|--------|--------|--------|
| **0000** | PT     | G1     | AS[0]  | AS[1]  | AS[2]  | AS[3]  | AS[4]  | AS[5]  |
| **0008** | AS[6]  | AS[7]  | AS[8]  | AS[9]  | AS[10] | AS[11] | AS[12] | AS[13] |
| **0010** | AS[14] | AS[15] | DA[0]  | DA[1]  | DA[2]  | DA[3]  | TI[0]  | TI[1]  | 
| **0018** | TI[2]  | TI[3]  | TI[4]  | TI[5]  | TI[6]  | TI[7]  | TI[8]  | TI[9]  |
| **0020** | TI[10] | TI[11] | TI[12] | TI[13] | TI[14] | TI[15] | DT[0]  | DT[1]  |
| **0028** | DT[2]  | DT[3]  | G2     | BP[0]  | BP[1]  | BP[2]  | BP[3]  | BP[4]  |
| **0038** | BP[5]  | BP[6]  | BP[7]  |        |        |        |        |        |

Total: 51 bytes

O bloco de transmissão esta dividido em secções de informação dispostas em ordem, denominadas de **slices**. A slice **[AS]**, por exemplo, representa a posição dos asteroides, enquanto que a slice **[G1]** agrupa a direção da nave, a quantidade de vidas e a dificuldade do jogo.

### Decodificação das Slices
Ao bloco completo de transmissão, dá-se o nome de **chunk**. Em cada chunk, os dados estão em posições fixadas. Por exemplo, o primeiro byte **[PT]** é o de pontuação. Os bytes **[BP]** são os bytes de break point. O conteúdo das slices está disposto abaixo:

- **[PT] Pontuação**: 1 byte de pontuação (inteiro)
- **[G1] Grupo 1**: 1 byte de informações agrupadas, com
    - **G1[0:2]** = Direção da nave: 2 bits (UP, DOWN, LEFT, RIGHT)
    - **G1[2:5]** = Vidas: 3 bits (inteiro)
    - **G1[5:8]** = Dificuldade: 3 bits (inteiro)
- **[AS] Posição dos asteroides** 16 bytes de posições de asteroides
- **[DA] Direção dos asteroides** 4 bytes de direção dos asteroides
- **[TI] Posições dos tiros** 16 bytes de posições de tiros
- **[DT] Direções dos tiros** 4 bytes de direção dos tiros
- **[G2] Grupo 2**: 1 byte de informações agrupadas, com
    - **G2[0]** = Jogada Especial: 1 bit (booleano)
    - **G2[1]** = Especial Disponível: 1 bit (booleano)
    - **G2[2]** = Jogada Tiro: 1 bit (booleano)
    - **G2[3]** = Tiro Disponível: 1 bit (booleano)
    - **G2[4]** = Acabou vidas: 1 bit (booleano)
    - **G2[5:8]** = blank_space: 3 bits (ignorar)
- [BP] **Break Point**: 8 bytes de fim de bloco, configurados para **SB = "AA AA AA AA"** (hexadecimal)


### Decodificação das Posições
Cada posição **P** é codificada como um byte, do qual os quatro primeiros bits **P[0:4]** e os quatro últimos bits **P[4:8]** representam a posição y. por exemplo, o byte

```
P = 0111 1101
```

Representa (x, y), sendo x = 0111 = 7 e y = 1101 = 13

### Decodificação da direção
Cada direção **D** é formada por dois bits, que juntos são decodificados em quatro direções primirivas, UP, DOWN, LEFT e RIGHT.

| D[0] | D[1] | Posição |
|------|------|---------|
|  0   |  0   |   RIGHT |
|  0   |  1   |   LEFT  |
|  1   |  0   |   UP    |
|  1   |  1   |   DOWN  |