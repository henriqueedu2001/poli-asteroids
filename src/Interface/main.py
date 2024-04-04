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
DEBUG_BYTE_TAPE = 'in_default'

DEFAULT_GAME_CONFIG = {
  'screen_widht': 800,
  'screen_heigth': 800,
  'serial_port': 'COM6',
  'mode': 'gameplay',
  'byte_tape': 'in_default',
  'delay': 0
}

DEFAULT_RENDER_CONFIG = {
    'render_mode': 'gameplay'
}

class Game():
  def __init__(self, game_config=DEFAULT_GAME_CONFIG, render_config=DEFAULT_RENDER_CONFIG) -> None:
    self.game_config = game_config
    
    # delay
    self.delay = self.game_config['delay']
    
    # debugging
    self.debug_mode = True if self.game_config['mode'] == 'debug' else False
    self.debug_byte_tape_name = self.game_config['byte_tape'] if self.game_config['byte_tape'] else DEBUG_BYTE_TAPE
    self.debug_byte_tape = ByteTape()
    self.log_messages = True
    self.degug_count = 0
    self.degug_count_max = 0
    
    # pygame parameters
    self.screen = None
    self.clock = None
    
    # buffer
    self.buffer = Buffer(buffer_size=BUFFER_SIZE, chunk_size=CHUNK_SIZE, break_point_str=BREAK_POINT_STR)
    self.received_game_data = None
    self.menu_byte = None
    
    # render
    self.render_config = render_config
    self.render_engine = None
    self.text_font = None
    
    self.actual_screen = 'gameplay'
    
    if self.debug_mode:
      self.actual_screen = self.game_config['debug_screen']
    
    # uart
    self.port = None
    self.port_opened = False
    

  def start_game(self):
    """Inicia o jogo poli-asteroids
    """
    
    # inicia o jogo
    self.log_message('starting game...')
    
    # configuração do jogo
    self.log_message(f'game config: {self.game_config}')
    self.log_message(f'render config: {self.render_config}')
    
    # abre a porta serial
    # uart.show_ports()
    
    if self.debug_mode:
      self.log_message('debug mode activated')
      self.log_messages = True
      
      try:
        self.log_message('loading byte tape...')
        self.debug_byte_tape.load_tape(self.debug_byte_tape_name)
        self.log_message('byte tape loaded')
      except Exception as execption:
        self.log_message(f'failed to load byte tape\n error: {execption}')
    
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
    
    
    self.render_engine = RenderEngine(self.screen, actual_screen=self.actual_screen, config=self.render_config)
    
    # roda o jogo
    self.run_game()


  def run_game(self):
    """Roda o jogo poli-asteroids
    """
    self.log_message('running game...')
    
    run = True
    
    while run:
      self.receive_data(delay=self.delay)
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
