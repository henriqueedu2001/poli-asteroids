import os

def ler_arquivo_binario(caminho_arquivo):
    # Inicializando uma lista para armazenar as strings binárias
    binary_strings = []
    
    # Abrindo o arquivo para leitura
    with open(caminho_arquivo, 'r') as file:
        # Lendo o arquivo linha por linha
        for line in file:
            # Removendo espaços em branco e quebras de linha
            line = line.strip()
            
            # Convertendo a linha em uma string binária
            binary_string = ''.join([bit for bit in line if bit in ['0', '1']])
            
            # Adicionando a string binária à lista
            binary_strings.append(binary_string)
    
    # Juntando todas as strings binárias em uma única string
    binary_data = ''.join(binary_strings)
    
    return binary_data


def salvar_arquivo_texto_binario(binary_data, caminho_saida):
    # Convertendo a string binária em uma string legível
    text_data = ''.join(chr(int(binary_data[i:i+8], 2)) for i in range(0, len(binary_data), 8))
    
    # Escrevendo os dados no novo arquivo
    with open(caminho_saida, 'w') as file:
        file.write(text_data)

def main():
    # Obtendo o diretório atual do script
    diretorio_atual = os.path.dirname(os.path.abspath(__file__))

    # Construindo o caminho completo do arquivo de entrada
    caminho_arquivo_entrada = os.path.join(diretorio_atual, 'data.txt')
    
    # Lendo o arquivo binário
    binary_data = ler_arquivo_binario(caminho_arquivo_entrada)
    
    # Construindo o caminho completo do arquivo de saída
    caminho_arquivo_saida = os.path.join(diretorio_atual, 'fita.txt')
    
    # Salvando o arquivo de texto binário
    salvar_arquivo_texto_binario(binary_data, caminho_arquivo_saida)

main()
