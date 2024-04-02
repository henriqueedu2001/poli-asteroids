from binary_handler import BinaryHandler
from typing import List

class ChunkDecoder():
    def decode_data(encoded_data):
        PT = encoded_data['PT'] 
        G1 = encoded_data['G1'] 
        AS = encoded_data['AS'] 
        DA = encoded_data['DA'] 
        TI = encoded_data['TI'] 
        DT = encoded_data['DT'] 
        G2 = encoded_data['G2']
        
        score = ChunkDecoder.get_score(PT)
        player_direction = ChunkDecoder.get_player_direction(G1)
        lifes_quantity = ChunkDecoder.get_lifes_quantity(G1)
        game_difficulty = ChunkDecoder.get_game_difficulty(G1)
        asteroids_positions = ChunkDecoder.get_asteroids_positions(AS)
        asteroids_directions = ChunkDecoder.get_asteroids_directions(DA)
        shots_positions = ChunkDecoder.get_shots_positions(TI)
        shots_directions = ChunkDecoder.get_shots_directions(DT)
        played_special_shooting = ChunkDecoder.get_played_special_shooting(G2)
        available_special_shooting = ChunkDecoder.get_available_special_shooting(G2)
        played_shooting = ChunkDecoder.get_played_shooting(G2)
        end_of_lifes = ChunkDecoder.get_end_of_lifes(G2)
        
        data = {
            'score': score,
            'player_direction': player_direction,
            'lifes_quantity': lifes_quantity,
            'game_difficulty': game_difficulty,
            'asteroids_positions': asteroids_positions,
            'asteroids_directions': asteroids_directions,
            'shots_positions': shots_positions,
            'shots_directions': shots_directions,
            'played_special_shooting': played_special_shooting, 
            'available_special_shooting': available_special_shooting,
            'played_shooting': played_shooting,
            'end_of_lifes': end_of_lifes
        }
        
        print(data)
        
        return data
        
        
    def get_score(PT_slice: bytes):
        score = BinaryHandler.get_int(PT_slice)

        return score


    def get_player_direction(G1_slice: bytes):
        bits = BinaryHandler.get_bits(G1_slice)
        bits = bits[0:2]
        direction = ChunkDecoder.decode_direction(bits)
        
        return direction


    def get_lifes_quantity(G1_slice: bytes):
        bits = BinaryHandler.get_bits(G1_slice)
        bits = bits[2:5]
        
        lifes_quantity = BinaryHandler.get_int_from_bits(bits)
        
        return lifes_quantity


    def get_game_difficulty(G1_slice: bytes):
        bits = BinaryHandler.get_bits(G1_slice)
        bits = bits[5:8]
        
        game_difficulty = BinaryHandler.get_int_from_bits(bits)

        return game_difficulty


    def get_asteroids_positions(AS_slice: bytes):
        asteroids_positions = []
        
        # converte cada byte de cada asteroide
        for byte in AS_slice:
            bits = BinaryHandler.get_bits(byte)
            x = bits[0:4]
            y = bits[4:8]
            
            x = BinaryHandler.get_int_from_bits(x)
            y = BinaryHandler.get_int_from_bits(y)
            
            asteroids_positions.append((x,y))

        return asteroids_positions


    def get_asteroids_directions(DA_slice: bytes):
        asteroids_directions = []
        asteroids_directions_codes = []
        
        for byte in DA_slice:
            bits = BinaryHandler.get_bits(byte)
            asteroid_direction_1 = bits[0:2]
            asteroid_direction_2 = bits[2:4]
            asteroid_direction_3 = bits[4:6]
            asteroid_direction_4 = bits[6:8]
            
            asteroids_directions_codes.append(asteroid_direction_1)
            asteroids_directions_codes.append(asteroid_direction_2)
            asteroids_directions_codes.append(asteroid_direction_3)
            asteroids_directions_codes.append(asteroid_direction_4)
        
        for asteroid_code in asteroids_directions_codes:
            direction = ChunkDecoder.decode_direction(asteroid_code)
            asteroids_directions.append(direction)
        
        return asteroids_directions


    def get_shots_positions(TI_slice: List[bytes]) -> List[str]:
        shooting_positions = []
        
        for byte in TI_slice:
            bits = BinaryHandler.get_bits(byte)
            x = bits[0:4]
            y = bits[4:8]
            
            x = BinaryHandler.get_int_from_bits(x)
            y = BinaryHandler.get_int_from_bits(y)
            
            shooting_positions.append((x,y))

        return shooting_positions


    def get_shots_directions(DT_slice: List[bytes]) -> List[str]:
        shooting_directions = 0
        
        shooting_directions = []
        shooting_directions_codes = []
        
        for byte in DT_slice:
            bits = BinaryHandler.get_bits(byte)
            shooting_code_1 = bits[0:2]
            shooting_code_2 = bits[2:4]
            shooting_code_3 = bits[4:6]
            shooting_code_4 = bits[6:8]
            
            shooting_directions_codes.append(shooting_code_1)
            shooting_directions_codes.append(shooting_code_2)
            shooting_directions_codes.append(shooting_code_3)
            shooting_directions_codes.append(shooting_code_4)
        
        for shooting_code in shooting_directions_codes:
            direction = ChunkDecoder.decode_direction(shooting_code)
            shooting_directions.append(direction)
        
        return shooting_directions


    def get_played_special_shooting(G2_slice: bytes) -> bool:
        bits = BinaryHandler.get_bits(G2_slice)
        bit = bits[0]
        
        played_special_shooting = BinaryHandler.cast_bool(bit)
        
        return played_special_shooting


    def get_available_special_shooting(G2_slice: bytes) -> bool:
        bits = BinaryHandler.get_bits(G2_slice)
        bit = bits[1]
        
        available_special_shooting = BinaryHandler.cast_bool(bit)

        return available_special_shooting


    def get_played_shooting(G2_slice: bytes) -> bool:
        bits = BinaryHandler.get_bits(G2_slice)
        bit = bits[2]
        
        played_shooting = BinaryHandler.cast_bool(bit)

        return played_shooting


    def get_end_of_lifes(G2_slice: bytes) -> bool:
        bits = BinaryHandler.get_bits(G2_slice)
        bit = bits[3]
        
        end_of_lifes = BinaryHandler.cast_bool(bit)

        return end_of_lifes
    
    
    def decode_direction(direction: List[int]):
        """Obtém a direção a partir de dois bits, decodificando 
        em UP, DOWN, LEFT e RIGHT.

        Args:
            direction (str): string de dois bits

        Returns:
            str: string de direção 
        """
        bit_0, bit_1 = direction[0], direction[1]
        direct = None
        
        if bit_0 == 0 and bit_1 == 0:
            direct = 'UP'
        elif bit_0 == 0 and bit_1 == 1:
            direct = 'DOWN'
        elif bit_0 == 1 and bit_1 == 0:
            direct = 'LEFT'
        elif bit_0 == 1 and bit_1 == 1:
            direct = 'RIGHT'
            
        return direct