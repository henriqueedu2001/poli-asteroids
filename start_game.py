from src.Interface.main import Game

# modos: 
# depuração: 'debug'
# jogo: 'gameplay'

# telas possíveis: 
#   menu inicial: 'initial_menu' 
#   jogo: 'gameplay'  
#   fim de jogo: 'gameover'  
#   ver pontuações: 'players_scores' 
#   registrar pontuação: 'register_scores' 
#   depuração: 'debug'

GAME_CONFIG = {
  'screen_widht': 700,
  'screen_heigth': 700,
  'serial_port': 'COM24',
  'mode': 'debug',
  'debug_screen': 'gameplay',
  'byte_tape': 'in_default',
  'delay': 0.00,
  'print_buffer': False,
  'print_chunk': False,
  'print_uart': False
}


def start():
  game = Game(GAME_CONFIG)
  game.start_game()

  return


if __name__ == '__main__':
  start()