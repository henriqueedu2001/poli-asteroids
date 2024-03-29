import utilitary.chunk_decoder as chunk_decoder

EMPTY_DATA_BYTE = '0'

class Chunk():
    def __init__(self, chunk_size) -> None:
        self.chunk_size = chunk_size
        self.chunk = [EMPTY_DATA_BYTE] * self.chunk_size
        self.loaded = False
        self.encoded_data = None
        self.decoded_data = None
    
    
    def load_chunk(self, chunk: str):
        """Carrega um chunk de dados na memória

        Args:
            chunk (str): string do chunk de dados
        """
        self.chunk = chunk
        self.loaded = True
        
        return
    
    
    def slice_chunk(self):
        """Divide o chunk de dados em segmentos de informação
        """
        chunk = self.chunk
        
        # pedaços de informação
        PT = str(chunk[0])
        G1 = str(chunk[1])
        AS = str(chunk[2:18])
        DA = str(chunk[18:22])
        TI = str(chunk[22:38])
        DT = str(chunk[38:42])
        G2 = str(chunk[42])
        BP = str(chunk[43:45])
        
        sliced_chunk = {
            'PT': PT, 'G1': G1, 'AS': AS, 'DA': DA, 'TI': TI, 'DT': DT, 'G2': G2, 'BP': BP
        }
        
        self.encoded_data = sliced_chunk
        
        return
    
    
    def decode_data(self) -> dict:
        """Obtém os dados a partir dos dados codificados no chunk

        Returns:
            dict: dicionário com as variáveis decodificadas
        """
        if self.loaded:
            # fatiamento dos dados
            self.slice_chunk()
            
            # decodificando dados
            encoded_data = self.encoded_data
            data = chunk_decoder.ChunkDecoder.decode_data(encoded_data)
            self.decoded_data = data
        
        return data
    
    
    def print_chunk(self):
        print(self.chunk)
    
    
    def print_decoded_data(self):
        data = self.decoded_data
        max_key_length = max(len(str(key)) for key in data.keys())
        
        for key, value in data.items():
            print(f"{str(key):<{max_key_length}} : {value}")


def test():
    chunk = Chunk(chunk_size=64)
    chunk.load_chunk('pç1111222233334444qwer9999888877776666asdfè$&')
    chunk.print_chunk()
    
    # chunk.slice_chunk()
    data = chunk.decode_data()
    
    print(data)
    pass


# test()