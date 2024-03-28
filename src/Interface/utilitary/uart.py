import serial

# Configurar a porta serial (substitua '/dev/ttyUSB0' pelo seu dispositivo serial)
serial_port = serial.Serial('COM6', baudrate=9600, timeout=1, parity=serial.PARITY_NONE)

try:
    while True:
        # Espera por entrada do usuário para enviar dados
        data_to_send = input("Digite os dados a serem enviados (pressione Enter para enviar): ")
        
        # Verifica se os dados não estão vazios
        if data_to_send:
            # Envie os dados pela porta serial
            serial_port.write(data_to_send.encode())  # Converta a entrada de string para bytes antes de enviar
            
            # Confirme o envio
            print("Dados enviados com sucesso:", data_to_send)
        
        # Leia 1 byte (8 bits) da porta serial
        byte_received = serial_port.read(1)
        
        if byte_received:
            # Exiba o byte recebido
            print("Byte recebido:", byte_received.hex())  # Exibe o byte como hexadecimal
except KeyboardInterrupt:
    # Se o usuário pressionar Ctrl+C, feche a porta serial e encerre o programa
    serial_port.close()
    print("Programa encerrado.")