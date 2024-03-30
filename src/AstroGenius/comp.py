# Lista de arquivos a serem adicionados
arquivos = [
    "astro_genius.v",
    "jogo_base.v",
    "asteroide.v",
    "tiro.v",
    "Modulos/comparador_85.v",
    "Modulos/contador_163.v",
    "Modulos/contador_m.v",
    "Modulos/decrementador.v",
    "Modulos/edge_detector.v",
    "Modulos/Memorias/memoria_aste.v",
    "Modulos/Memorias/memoria_load_aste.v",
    "Modulos/Memorias/memoria_tiro.v",
    "Modulos/Memorias/memoria_load_tiro.v",
    "Modulos/Memorias/memoria_frame.v",
    "Modulos/Memorias/rom_aste.v",
    "Modulos/mux_coor.v",
    "Modulos/mux_pos.v",
    "Modulos/mux_reg_jogada.v",
    "Modulos/registrador_n.v",
    "Modulos/somador_subtrator.v",
    "Modulos/random.v",
    "Modulos/uart_tx.v",
    "Modulos/hexa7seg_dig.v",
    "Modulos/contador_163_dificuldades.v",
    "UC/uc_envia_dados.v",
    "UC/uc_compara_asteroides_com_nave_e_tiros.v",
    "UC/uc_compara_tiros_e_asteroides.v",
    "UC/uc_coordena_asteroides_tiros.v",
    "UC/uc_gera_asteroide.v",
    "UC/uc_gera_frame.v",
    "UC/uc_registra_especial.v",
    "UC/uc_jogo_principal.v",
    "UC/uc_move_asteroides.v",
    "UC/uc_move_tiros.v",
    "UC/uc_registra_tiro.v",
    "UC/uc_renderiza.v",
    "UC/uc_menu.v"
]

# Nome do arquivo de saída
arquivo_saida = "digital.v"

# Abrir o arquivo de saída em modo de escrita
with open(arquivo_saida, "w") as saida:
    # Iterar sobre os arquivos
    for arquivo in arquivos:
        # Abrir cada arquivo de entrada e ler o conteúdo
        with open(arquivo, "r") as entrada:
            conteudo = entrada.read()
        # Escrever o conteúdo no arquivo de saída
        saida.write(conteudo)
        # Adicionar uma quebra de linha para separar os conteúdos dos arquivos
        saida.write("\n\n")
