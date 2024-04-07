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
  'screen_widht': 1550, #tamanho bom para pc do Felipe : 1550
  'screen_heigth': 900, #tamanho bom para pc do Felipe : 900
  'serial_port': 'COM4',
  'mode': 'gameplay',
  'debug_screen': 'gameplay',
  'byte_tape': 'in_default',
  'delay': 0.00,
  'print_buffer': False,
  'print_chunk': False,
  'print_uart': False,
  'print_received_data': False,
  'print_actual_screen': False
}


def start():
  game = Game(GAME_CONFIG)
  game.start_game()

  return


if __name__ == '__main__':
  start()