EMPTY_DATA_BYTE = 0

class Buffer():
    def __init__(self, buffer_size, chunk_size, break_point_str) -> None:
        self.index = 0
        self.buffer_size = buffer_size
        self.buffer = [EMPTY_DATA_BYTE] * self.buffer_size # inicialização do buffer
        self.chunk_size = chunk_size
        self.break_point_str = break_point_str
        self.last_break_point = -1
        self.chunk = [EMPTY_DATA_BYTE] * self.chunk_size
        self.chunk_loaded = False
        self.chunk_loading = False
    
    
    def write_buffer(self, byte: str):
        """Escreve um byte no buffer

        Args:
            byte (str): byte a ser escrito
        """
        # índice módulo n = buffer_size que retorna para o início, depois de atingir o limite
        index = self.index % self.buffer_size
        self.buffer[index] = byte
        
        if self.is_break_point(byte):
            if self.complete_chunk():
                self.load_chunk()
                # print('chunk completo recebido')
            else:
                self.chunk_loading = False
                pass
            
            self.last_break_point = index
            # print(f'breakpoint em {index}')
        
        # atualiza índice
        self.index = index + 1
    
        return
    
    
    def load_chunk(self):
        """Carrega um chunk, percorrendo os últimos n = chunk_size bytes do buffer
        """
        self.chunk_loading = True
        
        # percorre o buffer, coletando os bytes do chunk
        for i in range(self.chunk_size):
            buffer_index = self.index
            buffer_index = self.get_absolute_index(buffer_index, i - self.chunk_size + 1)
            byte = self.buffer[buffer_index]
            
            self.chunk[i] = byte
        
        self.chunk_loaded = True
        
        return
    
    
    def complete_chunk(self):
        """Verifica se o buffer acabou de receber um buffer completo

        Returns:
            bool: verdadeiro, se houve recepção de um chunk completo e falso caso contrário
        """
        
        # verifica coerência da distância entre os breakpoints
        if self.index - self.last_break_point == self.chunk_size:
            return True
        
        return False
    
    
    def is_break_point(self, last_byte):
        """Verifica se o buffer acabou de receber um break_point

        Args:
            last_byte (str): último byte recebido

        Returns:
            bool: verdadeiro se o buffer recebeu um break point
        """
        last_break_point_str_byte = self.break_point_str[-1]
        break_point_str_size = len(self.break_point_str)
        
        # detecção de byte final de parada
        if last_byte == last_break_point_str_byte:
            
            # caso o último byte do buffer seja o último byte da str do breakpoint
            # percorra o buffer para trás e verifique se a string é de fato de um breakpoint
            for i in range(break_point_str_size):
                # cálculo dos índices
                break_point_str_index = break_point_str_size - i - 1
                buffer_index = self.get_absolute_index(self.index, -i) 
                # print(f'buffer_index = {self.index}\trel_index={-i}\tcalc_index = {buffer_index}')
                
                # obtenção dos caracteres
                break_point_char = self.break_point_str[break_point_str_index]
                buffer_char = self.buffer[buffer_index]
                
                if buffer_char != break_point_char:
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
            Int: índice no buffer
        """
        if relative_index == 0:
            # retornar mesmo endereço, módulo n = buffer_size
            abs_index = pivot_index % self.buffer_size
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
        """Exibe o buffer em linhas do tamanho dos chunks
        """
        n = int(self.buffer_size/self.chunk_size)
        m = int(self.chunk_size)
        
        for i in range(n):
            for j in range(m):
                print(self.buffer[i * m + j], end='')
            print('')
    

def test():
    buffer = Buffer(buffer_size = 32, chunk_size = 8, break_point_str='ab')
    data = list('nk1abchunk2abchunk3abchunk4abchunk5abch')
    
    for byte in data:
        print(f'chunk = {buffer.chunk}')
        buffer.write_buffer(byte)
    
    buffer.print_buffer()
    
    pass

# test()