# Chunk de transmissão FPGA -> PC 
- [PT] Pontuação: 1 byte de pontuação 
- [G1] Grupo 1: 1 byte de informações agrupadas {direção, vidas, dificuldade}
- [AS] 16 bytes de posições de asteroides
- [DA] 4 bytes de direção dos asteroides (OBS: verificar a ordem dos opcodes)
- [TI] 16 bytes de posições de tiros
- [DT] 4 bytes de direção dos tiros (OBS: verificar a ordem dos opcodes)
- [G2] Grupo 2 de {jogada_especial, especial_disponível,  jogada_tiro, acabou_vidas, 2'b00}
- [BP] 2 bytes de break point

Formato do bloco:
PT      G1      AS[0]  AS[1]  AS[2]   AS[3]   AS[4]   AS[5] 
AS[6]   AS[7]   AS[8]  AS[9]  AS[10]  AS[11]  AS[12]  AS[13] 
AS[14]  AS[15]  DA[0]  DA[1]  DA[2]   DA[3]   TI[0]   TI[1] 
TI[2]   TI[3]   TI[4]  TI[5]  TI[6]   TI[7]   TI[8]   TI[9]
TI[10]  TI[11]  TI[12] TI[13] TI[14]  TI[15]  DT[0]   DT[1] 
DT[2]   DT[3]   G2     BP

Total: 49 bytes