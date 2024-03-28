import pygame
import utilitary.uart as uart

# tamanho da tela
SCREEN_WIDHT = 800
SCREEN_HEIGHT = 600

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

  i = 0
  send_data_buffer = ['a', 'b', 'c', 'd']
  
  while run:
    send_data = send_data_buffer[i%4]
    received_data = transmit_data(send_data)
    print(received_data)
    i = i + 1

    for event in pygame.event.get():
      # lógica de fim do jogo
      if event.type == pygame.QUIT:
        run = False
  
  # sair do jogo
  pygame.quit()


def transmit_data(send_data: str):
  port = uart.open_port(uart.DEFAULT_PORT_NAME)

  # recebimento de dados
  received_data = uart.receive_data(port)

  # transmissão de dados
  uart.send_data(port, send_data)

  return received_data

start_game()
