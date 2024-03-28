class Buffer():
    def __init__(self, buffer_size, chunk_size, break_point_str) -> None:
        self.index = 0
        self.buffer_size = buffer_size
        self.buffer = [0] * self.buffer_size # inicialização do buffer
        self.chunk_size = chunk_size
        self.break_point_str = break_point_str
        self.break_points = []
    
    
    def write_buffer(self, byte: str):
        """Escreve um byte no buffer

        Args:
            byte (str): byte a ser escrito
        """
        # índice módulo n = buffer_size que retorna para o início, depois de atingir o limite
        index = self.index % self.buffer_size
        self.buffer[index] = byte
        
        if self.complete_chunk(byte) == True:
            print('chunk completo encontrado')
        
        # atualiza índice
        self.index = index + 1
    
        return
    
    
    def complete_chunk(self, last_byte):
        """verifica se o último byte indica um chunk completo de dados

        Args:
            last_byte (_type_): _description_

        Returns:
            _type_: _description_
        """
        last_break_point_str_byte = self.break_point_str[-1]
        break_point_str_size = len(self.break_point_str)
        
        pivot_index = self.get_absolute_index(self.index, -1)
        
        if last_byte == last_break_point_str_byte:
            for i in range(break_point_str_size):
                comparison_index = self.get_absolute_index(self.index, -i)
                break_point_str_index = break_point_str_size - 1 - i
                
                if self.buffer[comparison_index] != self.break_point_str[break_point_str_index]:
                    return False
                
            return True
                
        
        return False
    
    
    def get_absolute_index(self, pivot_index, relative_index):
        """Obtém um índice absoluto no buffer, a partir de um índice pivô e um índice relativo.
        por exemplo, num buffer de tamanho 8, para o índice pivô pivot_index = 3, temos:\n
        rel_index = -6 => abs_index = 5\n
        rel_index = -5 => abs_index = 6\n
        rel_index = -4 => abs_index = 7\n
        rel_index = -3 => abs_index = 0\n
        rel_index = -2 => abs_index = 1\n
        rel_index = -1 => abs_index = 2\n
        rel_index = 0 => abs_index = 3 (mesmo do pivô)\n
        rel_index = 1 => abs_index = 4\n
        rel_index = 2 => abs_index = 5\n
        rel_index = 3 => abs_index = 6\n
        rel_index = 4 => abs_index = 7\n
        rel_index = 5 => abs_index = 0\n
        rel_index = 6 => abs_index = 1\n

        Args:
            pivot_index (_type_): _description_
            relative_index (_type_): _description_

        Returns:
            _type_: _description_
        """
        if relative_index == 0:
            # retornar mesmo endereço
            abs_index = pivot_index
        elif relative_index > 0:
            # retornar pivot_index + relative_index, descontando a ultrapassagem à direita
            abs_index = (pivot_index + relative_index) % self.buffer_size
        elif relative_index < 0:
            # retornar pivot_index + relative_index, descontado a ultrapassagem à esquerda
            abs_index = pivot_index + relative_index
            
            if abs_index >= 0:
                # índice ainda positivo
                abs_index = abs_index % self.buffer_size
            elif abs_index < 0:
                # índice negativo, mover para fim do bloco
                abs_index = (abs_index + self.buffer_size) % self.buffer_size
            
        return abs_index
    
    
    def print_buffer(self):
        n = int(self.buffer_size/self.chunk_size)
        m = int(self.chunk_size)
        
        for i in range(n):
            for j in range(m):
                print(self.buffer[i * m + j], end='')
            print('\n')
    

def test():
    buffer = Buffer(buffer_size = 8, chunk_size = 2, break_point_str='ab')
    data = list('2223333ab--111122223333ab--111122223333')
    
    for byte in data:
        buffer.write_buffer(byte)
    
    buffer.print_buffer()
    
    pass

test()