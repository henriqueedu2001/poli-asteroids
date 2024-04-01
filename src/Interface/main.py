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

DEFAULT_PORT_NAME = 'COM6'

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
    self.log_messages = True
    self.db_index = 0
    self.port = None
    self.port_opened = False
    

  def start_game(self):
    """Inicia o jogo poli-asteroids
    """
    
    # inicia o jogo
    self.log_message('starting game...')
    
    # abre a porta serial
    uart.show_ports()

    while self.port_opened == False:
      try:
        self.port = uart.open_port(port_name=DEFAULT_PORT_NAME)
        self.port_opened = True
        self.log_message('uart port started with sucess!')
      except Exception as exeption:
        self.log_message('failed to start the uart')
        time.sleep(2)

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
    # received_byte = MEM[self.db_index]

    received_byte = self.receive_uart_byte(self.port)

    bin = get_bin(received_byte)
    hex = get_hex(received_byte)
    print(f'{hex} {bin}')
    
    buffer.write_buffer(received_byte)
    
    if buffer.chunk_loading:
      chunk.load_chunk(buffer.chunk)
      chunk.decode_data()
      
      self.received_game_data = chunk.decoded_data
    
    # temporário, para depuração
    self.db_index = (self.db_index + 1) % len(MEM)
    
    return
  

  def receive_uart_byte(self, port):
    byte = uart.receive_data(port)

    return byte
  
  
  def render(self):
    data = self.received_game_data
    self.render_engine.load_data(data)
    self.render_engine.render()
    
    pass
  
  
  def log_message(self, log_message):
    if self.log_messages:
        print(log_message)


def get_hex(byte):
    try:
      codigo_ascii = ord(str(byte))
      codigo_hex = hex(codigo_ascii)
      return codigo_hex
    except:
      pass
    
    return 'null'


def get_bin(byte):
    try:
      codigo_ascii = ord(str(byte))
      return codigo_ascii
    except:
      pass
    
    return 'null'


game = Game()
game.start_game()
