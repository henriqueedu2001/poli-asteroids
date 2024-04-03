import pygame
import random
import time # for debbuging
from . utilitary import uart as uart
from . utilitary.byte_tape import ByteTape
from . utilitary.buffer import Buffer as Buffer
from . utilitary.chunk import Chunk
from . utilitary.binary_handler import BinaryHandler
from . render.render import RenderEngine
from . testing.read_byte_tape import get_byte_tape

# tamanho da tela
SCREEN_WIDTH = 600
SCREEN_HEIGHT = 600

BUFFER_SIZE = 256
CHUNK_SIZE = 45
BREAK_POINT_STR = b'\x41\x41'

DEFAULT_PORT_NAME = 'COM6'

class Game():
  def __init__(self) -> None:
    self.screen = None
    self.clock = None
    self.buffer = Buffer(buffer_size=BUFFER_SIZE, chunk_size=CHUNK_SIZE, break_point_str=BREAK_POINT_STR)
    self.received_game_data = None
    self.menu_byte = None
    self.text_font = None
    self.render_engine = None
    self.port = None
    self.port_opened = False
    self.debug_mode = False
    self.debug_byte_tape = ByteTape()
    self.log_messages = True
    self.degug_count = 0
    self.degug_count_max = 0

  def start_game(self):
    """Inicia o jogo poli-asteroids
    """
    
    # inicia o jogo
    self.log_message('starting game...')
    
    # abre a porta serial
    # uart.show_ports()
    
    if self.debug_mode:
      self.log_messages = True
      self.log_message('loading byte tape')
      
      self.debug_byte_tape.load_tape()
      self.log_message('byte tape loaded')
    
    else:
      while self.port_opened == False:
        try:
          self.port = uart.open_port(port_name=DEFAULT_PORT_NAME)
          self.port_opened = True
          self.log_message('uart port started with sucess!')
        except Exception as exeption:
          self.log_message(f'failed to start the uart.\ndetails: {exeption}')
          time.sleep(2)

    try:
      pygame.init()
      self.screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
      self.clock = pygame.time.Clock()
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
      self.receive_data(delay=0.0)
      self.render()

      for event in pygame.event.get():
        # lógica de fim do jogo
        if event.type == pygame.QUIT:
          self.log_message('player left the game')
          run = False
      
      pygame.display.flip()
      
    # sair do jogo
    pygame.quit()
  
  
  def receive_data(self, delay=0):
    """Recebe os dados da placa FPGA via transmissão serial
    """
    time.sleep(delay)
    
    buffer = self.buffer
    # chunk = self.chunk

    # receber o byte da comunicação serial com a uart
    # received_byte = self.receive_byte_tape() if self.debug_mode else self.receive_uart_byte(self.port)
    
    n_bytes = self.buffer.buffer_size
    received_bytes = self.receive_byte_tape() if self.debug_mode else self.receive_uart_bytes(self.port, n=n_bytes)
    
    if received_bytes!= None:
      if len(received_bytes) == 1:
        self.menu_byte = BinaryHandler.get_byte(received_bytes[0])
        
        byte_initial_menu = BinaryHandler.get_byte(b'\xf0')
        byte_gameplay = BinaryHandler.get_byte(b'\xf4')
        byte_gameover = BinaryHandler.get_byte(b'\xf5')
        byte_players_scores = BinaryHandler.get_byte(b'\xf1')
        
        print(f'menu byte encoding:')
        print(f'\t byte_initial_menu={byte_initial_menu}')
        print(f'\t byte_gameplay={byte_gameplay}')
        print(f'\t byte_gameover={byte_gameover}')
        print(f'\t byte_players_scores={byte_players_scores}')
        print(f'menu_byte = {self.menu_byte}\tscreen = ', end=' ')
        
        if self.menu_byte == byte_initial_menu:
          print('início')
        elif self.menu_byte == byte_gameplay:
          print('gameplay')
        elif self.menu_byte == byte_gameover:
          print('gameover')
        elif self.menu_byte == byte_players_scores:
          print('gameover')
        else:
          print('not valid menu byte')

        
        pass
      for received_byte in received_bytes:
        buffer.write_buffer(received_byte)

    if buffer.chunk_loading:
      try:
        self.buffer.chunk.slice_chunk()
        self.buffer.chunk.decode_data()
        # self.buffer.print_buffer()
      except Exception as exeption:
        self.log_message(f'error while loading chunk\n{exeption}')

      self.received_game_data = self.buffer.chunk.decoded_data
    
    return
  
  
  def receive_byte_tape(self):
    try:
      byte = self.debug_byte_tape.read_byte()
      return byte
    except:
      return None
  
  
  def receive_uart_bytes(self, port, n=256):
    try:
      byte = uart.receive_data(port, n=n)
      return byte
    except:
      return None
  
  
  def render(self):
    data = self.received_game_data
    self.render_engine.load_data(data)
    self.render_engine.render()
    
    return
  
  
  def log_message(self, log_message):
    if self.log_messages:
        print(log_message)
    
    return


if __name__ == '__main__':
  game = Game()
  game.start_game()
