# Chunk de transmissão FPGA -> PC 
- [PT] Pontuação: 1 byte de pontuação 
- [G1] Grupo 1: 1 byte de informações agrupadas {direção, vidas, dificuldade}
    - G1[0:2] = Direção da nave: 2 bits
    - G1[2:5] = Vidas: 3 bits
    - G1[5:8] = Dificuldade: 3 bits
- [AS] 16 bytes de posições de asteroides
- [DA] 4 bytes de direção dos asteroides (OBS: verificar a ordem dos opcodes)
- [TI] 16 bytes de posições de tiros
- [DT] 4 bytes de direção dos tiros (OBS: verificar a ordem dos opcodes)
- [G2] Grupo 2 de {jogada_especial, especial_disponível,  jogada_tiro, acabou_vidas, 2'b00}
    - G2[0] = Jogada Especial: 1 bit
    - G2[1] = Especial Disponível: 1 bit
    - G2[2] = Jogada Tiro: 1 bit
    - G2[3] = Tiro Disponível: 1 bit
    - G2[4] = Acabou vidas: 1 bit
    - G2[5:8] = blank_space: 3 bits
- [BP] 2 bytes de break point

ordem:
* 1 byte de pontuação
* 1 byte de {opcode_nave (2 bits), vidas (3 bits), dificuldade (3 bits)}
- 16 bytes de posições de asteroides
- 4 bytes de opcode dos asteroides (OBS: verificar a ordem dos opcodes)
- 16 bytes de posições de tiros
* 4 bytes de opcode dos tiros (OBS: verificar a ordem dos opcodes)
- 1 byte de {jogada_especial (1 bit), especial_disponível (1 bit),  jogada_tiro (1 bit), tiro_disponivel (1 bit), acabou_vidas (1 bit), 3'b0}
- 2 bytes de caracteres 'A' (indica o fim do bloco de dados)

Formato do bloco:

|        | **1**  | **2**  | **3**  | **4**  | **5**  | **6**  | **7**  | **8**    
|--------|--------|--------|--------|--------|--------|--------|--------|--------|
| **1**  | PT     | G1     | AS[0]  | AS[1]  | AS[2]  | AS[3]  | AS[4]  | AS[5]  |
| **2**  | AS[6]  | AS[7]  | AS[8]  | AS[9]  | AS[10] | AS[11] | AS[12] | AS[13] |
| **3**  | AS[14] | AS[15] | DA[0]  | DA[1]  | DA[2]  | DA[3]  | TI[0]  | TI[1]  | 
| **4**  | TI[2]  | TI[3]  | TI[4]  | TI[5]  | TI[6]  | TI[7]  | TI[8]  | TI[9]  |
| **5**  | TI[10] | TI[11] | TI[12] | TI[13] | TI[14] | TI[15] | DT[0]  | DT[1]  |
| **6**  | DT[2]  | DT[3]  | G2     | BP     |        |        |        |        |

Total: 44 bytes