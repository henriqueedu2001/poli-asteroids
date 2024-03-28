EMPTY_DATA_BYTE = 0

class Chunk():
    def __init__(self, chunk_size) -> None:
        self.chunk_size = chunk_size
        self.chunk = [EMPTY_DATA_BYTE] * self.chunk_size
        self.loaded = False
        self.encoded_data = None
        self.decoded_data = None
    
    def load_chunk(self, chunk):
        self.chunk = chunk
        self.loaded = True
        
        return
    
    
    def slice_chunk(self):
        """Divide o chunk de dados em segmentos de informação
        """
        chunk = self.chunk
        
        # pedaços de informação
        PT = chunk[0]
        G1 = chunk[1]
        AS = chunk[2:18]
        DA = chunk[18:22]
        TI = chunk[22:38]
        DT = chunk[38:42]
        G2 = chunk[42]
        BP = chunk[43:45]
        
        sliced_chunk = {
            'PT': PT, 'G1': G1, 'AS': AS, 'DA': DA, 'TI': TI, 'DT': DT, 'G2': G2, 'BP': BP
        }
        
        self.encoded_data = sliced_chunk
        
        return
    
    
    def decode_data(self):
        encoded_data = self.encoded_data
        
        PT = encoded_data['PT'] 
        G1 = encoded_data['G1'] 
        AS = encoded_data['AS'] 
        DA = encoded_data['DA'] 
        TI = encoded_data['TI'] 
        DT = encoded_data['DT'] 
        G2 = encoded_data['G2'] 
        
        score = ChunkInterpreter.get_score(PT)
        player_direction = ChunkInterpreter.get_player_direction(G1)
        lifes_quantity = ChunkInterpreter.get_lifes_quantity(G1)
        game_difficulty = ChunkInterpreter.get_game_difficulty(G1)
        asteroids_positions = ChunkInterpreter.get_asteroids_positions(AS)
        asteroids_directions = ChunkInterpreter.get_asteroids_directions(DA)
        shooting_positions = ChunkInterpreter.get_shooting_positions(TI)
        shooting_directions = ChunkInterpreter.get_shooting_directions(DT)
        played_special_shooting = ChunkInterpreter.get_played_special_shooting(G2)
        available_special_shooting = ChunkInterpreter.get_available_special_shooting(G2)
        played_shooting = ChunkInterpreter.get_played_shooting(G2)
        end_of_lifes = ChunkInterpreter.get_end_of_lifes(G2)
        
        data = {
            'score': score,
            'player_direction': player_direction,
            'lifes_quantity': lifes_quantity,
            'game_difficulty': game_difficulty,
            'asteroids_positions': asteroids_positions,
            'asteroids_directions': asteroids_directions,
            'shooting_positions': shooting_positions,
            'shooting_directions': shooting_directions,
            'played_special_shooting': played_special_shooting, 
            'available_special_shooting': available_special_shooting,
            'played_shooting': played_shooting,
            'end_of_lifes': end_of_lifes
        }
        
        self.decoded_data = data
        
        return data
    
    
    def print_chunk(self):
        print(self.chunk)


class ChunkInterpreter():
    def get_score(PT_slice: str):
        score = 0

        bin_code = get_binary_code(PT_slice)
        score = get_number(bin_code)

        return score


    def get_player_direction(G1_slice: str):
        player_direction = 0

        return player_direction


    def get_lifes_quantity(G1_slice: str):
        lifes_quantity = 0

        return lifes_quantity


    def get_game_difficulty(G1_slice: str):
        game_difficulty = 0

        return game_difficulty


    def get_asteroids_positions(AS_slice: str):
        asteroids_positions = []
        
        for byte in AS_slice:
            bin_code = get_binary_code(byte)
            x = bin_code[0:4]
            y = bin_code[4:8]
            
            x = get_number(x)
            y = get_number(y)
            
            asteroids_positions.append((x,y))

        return asteroids_positions


    def get_asteroids_directions(DA_slice: str):
        asteroids_directions = []
        asteroids_directions_codes = []
        
        for byte in DA_slice:
            bin_code = get_binary_code(byte)
            first_asteroid_code = bin_code[0:2]
            second_asteroid_code = bin_code[2:4]
            
            asteroids_directions_codes.append(first_asteroid_code)
            asteroids_directions_codes.append(second_asteroid_code)
        
        for asteroid_code in asteroids_directions_codes:
            direction = ChunkInterpreter.decode_direction(asteroid_code)
            asteroids_directions.append(direction)
            
        return asteroids_directions


    def get_shooting_positions(TI_slice: str):
        shooting_positions = []
        
        for byte in TI_slice:
            bin_code = get_binary_code(byte)
            x = bin_code[0:4]
            y = bin_code[4:8]
            
            x = get_number(x)
            y = get_number(y)
            
            shooting_positions.append((x,y))

        return shooting_positions


    def get_shooting_directions(DT_slice: str):
        shooting_directions = 0
        
        shooting_directions = []
        shooting_directions_codes = []
        
        for byte in DT_slice:
            bin_code = get_binary_code(byte)
            first_shooting_code = bin_code[0:2]
            second_shooting_code = bin_code[2:4]
            
            shooting_directions_codes.append(first_shooting_code)
            shooting_directions_codes.append(second_shooting_code)
        
        for shooting_code in shooting_directions_codes:
            direction = ChunkInterpreter.decode_direction(shooting_code)
            shooting_directions.append(direction)

        return shooting_directions


    def get_played_special_shooting(G2_slice: str):
        played_special_shooting = 0

        return played_special_shooting


    def get_available_special_shooting(G2_slice: str):
        available_special_shooting = 0

        return available_special_shooting


    def get_played_shooting(G2_slice: str):
        played_shooting = 0

        return played_shooting


    def get_end_of_lifes(G2_slice: str):
        end_of_lifes = 0

        return end_of_lifes
    
    
    def decode_direction(direction: str):
        """Obtém a direção a partir de dois bits, decodificando 
        em UP, DOWN, LEFT e RIGHT.

        Args:
            direction (str): string de dois bits

        Returns:
            str: string de direção 
        """
        bit_0, bit_1 = direction[0], direction[1]
        direct = None
        
        if bit_0 == '0' and bit_1 == '0':
            direct = 'UP'
        elif bit_0 == '0' and bit_1 == '1':
            direct = 'DOWN'
        elif bit_0 == '1' and bit_1 == '0':
            direct = 'LEFT'
        elif bit_0 == '1' and bit_1 == '1':
            direct = 'RIGHT'
            
        return direct




def get_binary_code(ascii_char: str):
    """Obtém o código binário correspondente a um certo caracter ascii

    Args:
        ascii_char (str): _description_

    Returns:
        _type_: _description_
    """
    ascii_code = ord(ascii_char)
    binary_code = bin(ascii_code)
    
    # formata para 8bits
    binary_code = format(ascii_code, '0{}b'.format(8))
    
    return binary_code


def get_number(binary_str: str):
    """Obtém variável tipo int a partir de uma string binária

    Args:
        binary_str (str): string binária a ser convertida

    Returns:
        int: valor correspondente
    """
    number = int(binary_str, 2)
    
    return number


def test():
    chunk = Chunk(chunk_size=64)
    chunk.load_chunk('pç1111222233334444qwer9999888877776666asdfè$&')
    chunk.print_chunk()
    
    chunk.slice_chunk()
    data = chunk.decode_data()
    
    print(data)
    pass


test()