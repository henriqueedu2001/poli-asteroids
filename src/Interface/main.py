import pygame
import time # for debbuging
import utilitary.uart as uart
from utilitary.buffer import Buffer as Buffer
from utilitary.chunk import Chunk

# tamanho da tela
SCREEN_WIDTH = 800
SCREEN_HEIGHT = 300

BUFFER_SIZE = 256
CHUNK_SIZE = 45

MEM = 'pç1111222233334444qwer9999888877776666asdfè$&hç4444888844448888ghjk9999888877776666asdfè$&'

WHITE = (255, 255, 255)
BLACK = (0, 0, 0)

class Game():
  def __init__(self) -> None:
    self.screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
    self.clock = pygame.time.Clock()
    self.buffer = Buffer(buffer_size=BUFFER_SIZE, chunk_size=CHUNK_SIZE, break_point_str='$&')
    self.chunk = Chunk(chunk_size=CHUNK_SIZE)
    self.received_game_data = None
    self.text_font = None
    self.db_index = 0
    

  def start_game(self):
    """Inicia o jogo poli-asteroids
    """
    
    # inicia o jogo
    pygame.init()
    
    self.text_font = pygame.font.SysFont(None, 48)
    
    # roda o jogo
    self.run_game()


  def run_game(self):
    """Roda o jogo poli-asteroids
    """
    run = True

    while run:
      self.receive_data()
      self.render()

      for event in pygame.event.get():
        # lógica de fim do jogo
        if event.type == pygame.QUIT:
          run = False

      pygame.display.flip()
      
      time.sleep(0.1)
      
    # sair do jogo
    pygame.quit()
  
  
  def receive_data(self):
    """Recebe os dados da placa FPGA via transmissão serial
    """
    buffer = self.buffer
    chunk = self.chunk
    
    # temporário, para depuração
    received_byte = MEM[self.db_index]
    
    buffer.write_buffer(received_byte)
    
    if buffer.chunk_loading:
      chunk.load_chunk(buffer.chunk)
      chunk.decode_data()
      
      self.received_game_data = chunk.decoded_data
    
    # temporário, para depuração
    self.db_index = (self.db_index + 1) % len(MEM)
    
    return
  
  def render(self):
    self.clear_screen()
    
    font = self.text_font
    
    data = self.received_game_data
    
    self.buffer.print_buffer()
    print('-----------------')
    
    try:
      score = data['score']
      player_direction = data['player_direction']
      lifes_quantity = data['lifes_quantity']
      game_difficulty = data['game_difficulty']
      asteroids_positions = data['asteroids_positions']
      asteroids_directions = data['asteroids_directions']
      shooting_positions = data['shooting_positions']
      shooting_directions = data['shooting_directions']
      played_special_shooting = data['played_special_shooting']
      available_special_shooting = data['available_special_shooting']
      played_shooting = data['played_shooting']
      end_of_lifes = data['end_of_lifes']
      
      # print(data)
      self.draw_text(f'{score}', font, WHITE, SCREEN_WIDTH // 2, SCREEN_HEIGHT // 2)
    except:
      print('não foi possível renderizar')
      pass
    
    pass
  
  
  def clear_screen(self):
    self.screen.fill(BLACK)

  
  def draw_text(self, text, font, color, x, y):
    screen = self.screen
    text_surface = font.render(text, True, color)
    text_rect = text_surface.get_rect()
    text_rect.center = (x, y)
    screen.blit(text_surface, text_rect)
    
    return


  def transmit_data(send_data: str):
    port = uart.open_port(uart.DEFAULT_PORT_NAME)

    # recebimento de dados
    received_data = uart.receive_data(port)

    # transmissão de dados
    uart.send_data(port, send_data)

    return received_data


game = Game()
game.start_game()
