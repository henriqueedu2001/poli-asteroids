# Chunk de transmissão FPGA -> PC 
- **[PT] Pontuação**: 1 byte de pontuação 
- **[G1] Grupo 1**: 1 byte de informações agrupadas, com
    - **G1[0:2]** = Direção da nave: 2 bits
    - **G1[2:5]** = Vidas: 3 bits
    - **G1[5:8]** = Dificuldade: 3 bits
- **[AS] Posição dos asteroides** 16 bytes de posições de asteroides
- **[DA] Direção dos asteroides** 4 bytes de direção dos asteroides
- **[TI] Posições dos tiros** 16 bytes de posições de tiros
- **[DT] Direções dos tiros** 4 bytes de direção dos tiros
- **[G2] Grupo 2**: 1 byte de informações agrupadas, com
    - **G2[0]** = Jogada Especial: 1 bit
    - **G2[1]** = Especial Disponível: 1 bit
    - **G2[2]** = Jogada Tiro: 1 bit
    - **G2[3]** = Tiro Disponível: 1 bit
    - **G2[4]** = Acabou vidas: 1 bit
    - **G2[5:8]** = blank_space: 3 bits
- [BP] **Break Point**: 8 bytes de fim de bloco, configurados para **SB = "AA AA AA AA"** (hexadecimal)

Formato do bloco:

|          | **00** | **01** | **03** | **04** | **05** | **06** | **07** | **08** | 
|----------|--------|--------|--------|--------|--------|--------|--------|--------|
| **0000** | PT     | G1     | AS[0]  | AS[1]  | AS[2]  | AS[3]  | AS[4]  | AS[5]  |
| **0008** | AS[6]  | AS[7]  | AS[8]  | AS[9]  | AS[10] | AS[11] | AS[12] | AS[13] |
| **0010** | AS[14] | AS[15] | DA[0]  | DA[1]  | DA[2]  | DA[3]  | TI[0]  | TI[1]  | 
| **0018** | TI[2]  | TI[3]  | TI[4]  | TI[5]  | TI[6]  | TI[7]  | TI[8]  | TI[9]  |
| **0020** | TI[10] | TI[11] | TI[12] | TI[13] | TI[14] | TI[15] | DT[0]  | DT[1]  |
| **0028** | DT[2]  | DT[3]  | G2     | BP[0]  | BP[1]  | BP[2]  | BP[3]  | BP[4]  |
| **0028** | BP[5]  | BP[6]  | BP[7]  |        |        |        |        |        |

Total: 51 bytes