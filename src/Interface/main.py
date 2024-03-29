import pygame
import utilitary.uart as uart
from utilitary.buffer import Buffer as Buffer
from utilitary.chunk import Chunk

# tamanho da tela
SCREEN_WIDHT = 800
SCREEN_HEIGHT = 600

MEM = 'pç1111222233334444qwer9999888877776666asdfè$&pç4444888844448888ghjk9999888877776666asdfè$&'

def start_game():
  """Inicia o jogo poli-asteroids
  """
  screen = pygame.display.set_mode((SCREEN_WIDHT, SCREEN_HEIGHT))
  clock = pygame.time.Clock()
  
  # inicia o jogo
  pygame.init()
  
  # roda o jogo
  run_game(screen, clock)


def run_game(screen, clock):
  """_summary_

  Args:
      screen (pygame.display.set_mode): tela do jogo
      clock (pygame.time.Clock): clock do jogo
  """
  run = True
  
  # configuração do buffer
  buffer_size=256
  chunk_size=45
  buffer = Buffer(buffer_size=buffer_size, chunk_size=chunk_size, break_point_str='$&')
  chunk = Chunk(chunk_size=chunk_size)
  
  i = 0
  while run:
    
    received_data = receive_data(i)
    buffer.write_buffer(received_data)
    chunk.load_chunk(buffer.chunk)
    chunk.decode_data()
    chunk.print_decoded_data()
    print('-------------------')
    
    i = i + 1
    i = i % len(MEM)

    for event in pygame.event.get():
      # lógica de fim do jogo
      if event.type == pygame.QUIT:
        run = False
  
  # sair do jogo
  pygame.quit()
  

def receive_data(index):
  byte = MEM[index]
  
  return byte

def transmit_data(send_data: str):
  port = uart.open_port(uart.DEFAULT_PORT_NAME)

  # recebimento de dados
  received_data = uart.receive_data(port)

  # transmissão de dados
  uart.send_data(port, send_data)

  return received_data

start_game()
