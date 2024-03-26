import pygame

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
  
  while run:
    for event in pygame.event.get():
      
      # lógica de fim do jogo
      if event.type == pygame.QUIT:
        run = False
  
  # sair do jogo
  pygame.quit()

start_game()