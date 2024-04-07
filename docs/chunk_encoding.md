# Chunk de transmissão FPGA -> PC 
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

## Decodificação das Slices
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


## Decodificação das Posições
Cada posição **P** é codificada como um byte, do qual os quatro primeiros bits **P[0:4]** e os quatro últimos bits **P[4:8]** representam a posição y. por exemplo, o byte

```
P = 0111 1101
```

Representa (x, y), sendo x = 0111 = 7 e y = 1101 = 13

## Decodificação da direção
Cada direção **D** é formada por dois bits, que juntos são decodificados em quatro direções primirivas, UP, DOWN, LEFT e RIGHT.

| D[0] | D[1] | Posição |
|------|------|---------|
|  0   |  0   |   RIGHT |
|  0   |  1   |   LEFT  |
|  1   |  0   |   UP    |
|  1   |  1   |   DOWN  |