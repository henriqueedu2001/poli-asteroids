import pygame
import random
import time # for debbuging
import utilitary.uart as uart
from utilitary.buffer import Buffer as Buffer
from utilitary.chunk import Chunk
from render.render import RenderEngine
from testing.read_byte_tape import get_byte_tape

# tamanho da tela
SCREEN_WIDTH = 800
SCREEN_HEIGHT = 800

BUFFER_SIZE = 256
CHUNK_SIZE = 45
BREAK_POINT_STR = 'AA'

# MEM = 'pç1111222233334444qwer9999888877776666asdfè$&hç4444888844448888ghjk9999888877776666asdfè$&'
MEM = get_byte_tape()

WHITE = (255, 255, 255)
BLACK = (0, 0, 0)

class Game():
  def __init__(self) -> None:
    self.screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
    self.clock = pygame.time.Clock()
    self.buffer = Buffer(buffer_size=BUFFER_SIZE, chunk_size=CHUNK_SIZE, break_point_str=BREAK_POINT_STR)
    self.chunk = Chunk(chunk_size=CHUNK_SIZE)
    self.received_game_data = None
    self.text_font = None
    self.render_engine = None
    self.log_messages = False
    self.db_index = 0
    

  def start_game(self):
    """Inicia o jogo poli-asteroids
    """
    
    # inicia o jogo
    self.log_message('starting game...')
    
    try:
      pygame.init()
      self.log_message('game started with sucess!')
    except Exception as exeption:
      self.log_message('failed to start the game')
    
    self.render_engine = RenderEngine(self.screen)
    
    # roda o jogo
    self.run_game()


  def run_game(self):
    """Roda o jogo poli-asteroids
    """
    self.log_message('running game...')
    
    run = True
    
    while run:
      self.receive_data()
      self.render()

      for event in pygame.event.get():
        # lógica de fim do jogo
        if event.type == pygame.QUIT:
          self.log_message('player left the game')
          run = False

      pygame.display.flip()
      
      # time.sleep(0.01)
      
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
    data = self.received_game_data
    self.render_engine.load_data(data)
    self.render_engine.render()
    
    pass


  def transmit_data(send_data: str):
    port = uart.open_port(uart.DEFAULT_PORT_NAME)

    # recebimento de dados
    received_data = uart.receive_data(port)

    # transmissão de dados
    uart.send_data(port, send_data)

    return received_data
  
  
  def log_message(self, log_message):
    if self.log_messages:
        print(log_message)


game = Game()
game.start_game()
