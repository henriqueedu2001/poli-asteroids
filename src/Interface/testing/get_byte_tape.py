import os

# obtendo o diretório atual do script
diretorio_atual = os.path.dirname(os.path.abspath(__file__))

# construindo o caminho completo do arquivo
path = os.path.join(diretorio_atual, 'data.txt')

# abrindo o arquivo para leitura
with open(path, 'r') as file:
    binary_strings = []
    
    # lendo o arquivo linha por linha
    for line in file:
        # removendo espaços em branco e quebras de linha
        line = line.strip()
        
        # convertendo a linha em uma string binária
        binary_string = ''.join([bit for bit in line if bit in ['0', '1']])
        
        # adicionando a string binária à lista
        binary_strings.append(binary_string)

# juntando todas as strings binárias em uma única string
binary_data = ''.join(binary_strings)

# convertendo a string binária em uma string legível
text_data = ''.join(chr(int(binary_data[i:i+8], 2)) for i in range(0, len(binary_data), 8))

# imprimindo a string legível
print(text_data)
