import pygame
import utilitary.uart as uart
from utilitary.buffer import Buffer as Buffer
from utilitary.chunk import Chunk

# tamanho da tela
SCREEN_WIDHT = 800
SCREEN_HEIGHT = 600

BUFFER_SIZE = 256
CHUNK_SIZE = 45

MEM = 'pç1111222233334444qwer9999888877776666asdfè$&pç4444888844448888ghjk9999888877776666asdfè$&'

class Game():
  def __init__(self) -> None:
    self.screen = pygame.display.set_mode((SCREEN_WIDHT, SCREEN_HEIGHT))
    self.clock = pygame.time.Clock()
    self.buffer = Buffer(buffer_size=BUFFER_SIZE, chunk_size=CHUNK_SIZE, break_point_str='$&')
    self.chunk = Chunk(chunk_size=CHUNK_SIZE)
    self.db_index = 0
    

  def start_game(self):
    """Inicia o jogo poli-asteroids
    """
    
    # inicia o jogo
    pygame.init()
    
    # roda o jogo
    self.run_game()


  def run_game(self):
    """Roda o jogo poli-asteroids
    """
    run = True

    while run:
      self.receive_data()

      for event in pygame.event.get():
        # lógica de fim do jogo
        if event.type == pygame.QUIT:
          run = False
    
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
      
      chunk.print_decoded_data()
      print('-------------------')
    
    # temporário, para depuração
    self.db_index = (self.db_index + 1) % len(MEM)
    
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
