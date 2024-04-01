import os

def get_byte_tape():
    byte_tape = ''

    # obtendo o diretório atual do script
    # file_name = 'byte_tape.out'
    file_name = 'fita.txt'
    absolute_path = os.path.dirname(os.path.abspath(__file__))
    path = os.path.join(absolute_path, file_name)

    # abrindo o arquivo para leitura
    with open(path, 'r', encoding="utf8") as file:
        # lendo o arquivo linha por linha
        for line in file:
            byte_tape = byte_tape + line
    
    return byte_tape