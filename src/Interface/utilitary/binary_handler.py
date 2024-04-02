from typing import List

class BinaryHandler():
    def get_byte(byte: bytes | int) -> bytes:
        real_byte = byte
        
        if type(byte) == int:
            real_byte = bytes([byte])
        
        return real_byte
    
    
    def get_int(byte: bytes) -> int:
        int_value = int.from_bytes(byte, byteorder='big')
        
        return int_value
    
    
    def get_byte_str(byte: bytes | int, str_format='hex') -> str:
        byte_str = 'XX'
        byte_int = byte
        
        if type(byte) == bytes:
            byte_int = BinaryHandler.get_int(byte)
        
        if str_format == 'hex':
            byte_hex = '{:02x}'.format(byte_int)
            byte_str = byte_hex
        elif str_format == 'bin':
            reversed_bits = BinaryHandler.get_bits(byte_int)
            bits = reversed(reversed_bits)
            byte_str = ''.join(map(str, bits))
            
        return byte_str
    
    
    def get_bits(byte: bytes | int) -> List[int]:
        bits = []
        
        byte_int = byte
        
        # converte byte para int
        if type(byte) == bytes:
            byte_int = BinaryHandler.get_int(byte)
                  
        for i in range(8):
            bit = BinaryHandler.get_bit(byte=byte_int, index=i)
            bits.append(bit)
            
        return bits


    def get_bit(byte: bytes | int, index: int) -> int:
        """Retorna o valor do bit na posição index do byte"""
        byte_int = byte
        bit = 0
        
        # converte para int, se necessário
        if type(byte_int) == bytes:
            byte_int = BinaryHandler.get_int(byte)
        
        bit = (byte_int >> index) & 1
        
        return bit
    
    
    def print_byte(byte: bytes | int, str_format: str = 'hex') -> None:
        byte_str = BinaryHandler.get_byte_str(byte, str_format=str_format)
        
        print(byte_str)
        
        return
    
    
    def print_byte_data(data: bytes | List[int], bytes_per_line: int = 16, str_format: str = 'hex') -> None:
        block_size = len(data)
        lines = (block_size // bytes_per_line)
        tail_size = block_size % bytes_per_line
        spacing_char = ' '

        # imprimir bloco, com exceção da cauda
        for i in range(lines):
            for j in range(bytes_per_line):
                index = i*bytes_per_line + j
                byte = data[index]
                byte_char = BinaryHandler.get_byte_str(byte=byte, str_format=str_format)
                print(byte_char, end=spacing_char)
            print()
        
        # imprimir cauda
        for j in range(tail_size):
            index = lines*bytes_per_line + j
            byte = data[index]
            byte_char = BinaryHandler.get_byte_str(byte=byte, str_format=str_format)
            print(byte_char, end=spacing_char)
        print()

def test():
    byte_tape = b'\x00\x00\x01\x02\x03\x04\x01\x02\x03\x04\x01\x02\x03\x04\x01\x02\x03\x04\x01\x02\x03'
    
    BinaryHandler.print_byte_data(data=byte_tape, str_format='hex')
    
    # for byte in byte_tape:
    #     real_byte = BinaryHandler.get_byte(byte)
    #     BinaryHandler.print_byte(real_byte, str_format='bin')
    
    return

# test()