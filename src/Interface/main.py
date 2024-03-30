import pygame
import random
import time # for debbuging
import utilitary.uart as uart
from utilitary.buffer import Buffer as Buffer
from utilitary.chunk import Chunk
from render.render import RenderEngine

# tamanho da tela
SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600

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
    characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ$&!"#%()*+,-./:;<=>?@[\]^_`{|}~áàäéèêâôöóò\''
    
    received_byte = random.choice(characters)
    
    if self.db_index == self.chunk.chunk_size - 2:
      received_byte = '$'
    elif self.db_index == self.chunk.chunk_size - 1:
      received_byte = '&'
    
    buffer.write_buffer(received_byte)
    
    if buffer.chunk_loading:
      chunk.load_chunk(buffer.chunk)
      chunk.decode_data()
      
      self.received_game_data = chunk.decoded_data
    
    # temporário, para depuração
    self.db_index = (self.db_index + 1) % self.chunk.chunk_size
    
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
