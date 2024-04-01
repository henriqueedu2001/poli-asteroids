import pygame
import os

WHITE = (255, 255, 255)
BLACK = (0, 0, 0)

NOT_LOADED_ASTEROID_POSITION = (0, 0)
NOT_LOADED_SHOOT_POSITION = (0, 0)

class RenderEngine():
    def __init__(self, screen) -> None:
        self.data = None
        self.loaded_data = False
        self.screen = screen
        self.screen_width, self.screen_height = screen.get_size()
        self.default_text_font = pygame.font.SysFont(None, 24)
        self.log_messages = False
        
        # state variables
        self.score = None
        self.player_direction = None
        self.lifes_quantity = None
        self.game_difficulty = None
        self.asteroids = None
        self.asteroids_positions = None
        self.asteroids_directions = None
        self.shots = None
        self.shots_positions = None
        self.shots_directions = None
        self.played_special_shooting = None
        self.available_special_shooting = None
        self.played_shooting = None
        self.end_of_lifes = None
        self.players_scores = [
            {'name': 'player_01', 'score': 201},
            {'name': 'player_02', 'score': 168},
            {'name': 'player_03', 'score': 95},
            {'name': 'player_04', 'score': 85},
            ]
        
        self.colors = {
            'white': (255, 255, 255),
            'black': (0, 0, 0)
        }
        
        self.images = {
            'life': None,
            'space_ship': None,
            'shot': None,
            'asteroid': None,
            'asteroid_01': None,
            'asteroid_02': None,
            'asteroid_03': None,
            'asteroid_04': None
        }
        
        self.images_paths = {
            'life': 'heart.svg',
            'space_ship': 'space_ship.svg',
            'shot': 'shot.svg',
            'asteroid_01': 'asteroid_01.svg',
            'asteroid_02': 'asteroid_02.svg',
            'asteroid_03': 'asteroid_03.svg',
            'asteroid_04': 'asteroid_04.svg',
            'asteroid_05': 'asteroid_05.svg',
            'asteroid_06': 'asteroid_06.svg',
            'asteroid_07': 'asteroid_07.svg',
            'asteroid_08': 'asteroid_08.svg'
        }
        
        self.db_index = 0
        
        # carregamento de imagens
        self.load_assets()
        
        return
    
    
    def load_assets(self):
        """Carrega todas as imagens no jogo
        """
        self.log_message('loading images...')
        
        # getting the absolute path
        script_dir = os.path.dirname(os.path.abspath(__file__))
        
        # loading all images
        for img_key, img_path in self.images_paths.items():
            try:
                self.log_message(f'loading image {img_key}')
                
                # loading image
                path = os.path.join(script_dir, "imgs", img_path)
                self.images[img_key] = pygame.image.load(path)
                
                self.log_message(f'sucess in loading image {img_key}!')
                pass
            except Exception as exeption:
                self.log_message(f'failed to load image {img_key}')
                self.log_message(f'\texeption {exeption}')
                pass
            pass
        
        return
    
    
    def load_data(self, data):
        if data != None:
            self.data = data
            self.load_state_variables()
            self.loaded_data = True
        else:
            self.loaded_data = False
            
        return
    
    
    def load_state_variables(self):
        data = self.data
        
        try:
            self.score = data['score']
            self.player_direction = data['player_direction']
            self.lifes_quantity = data['lifes_quantity']
            self.game_difficulty = data['game_difficulty']
            self.asteroids_positions = data['asteroids_positions']
            self.asteroids_directions = data['asteroids_directions']
            self.shots_positions = data['shots_positions'] # TODO fix typo
            self.shots_directions = data['shots_directions'] # TODO fix typo
            self.played_special_shooting = data['played_special_shooting']
            self.available_special_shooting = data['available_special_shooting']
            self.played_shooting = data['played_shooting']
            self.end_of_lifes = data['end_of_lifes']
        except:
            pass
        
        # carrega tiros e asteroides
        self.load_asteroids()
        self.load_shots()
        
        return
    
    
    def load_asteroids(self):
        asteroids = []
        
        if self.loaded_data:
            try:
                for index, asteroid_position in enumerate(self.asteroids_positions):
                    try:
                        new_asteroid = {
                            'x': asteroid_position[0],
                            'y': asteroid_position[1],
                            'direction': self.asteroids_directions[index]
                        }
                        asteroids.append(new_asteroid)
                    except Exception as exception:
                        self.log_message(f'error in loading asteroid n = {index}\n{exception}')
            except Exception as exception:
                        self.log_message(f'error in loading asteroids\n{exception}')
                    
        self.asteroids = asteroids 
        
        return
    
    
    def load_shots(self):
        shots = []
        
        if self.loaded_data:
            try:
                for index, shot_position in enumerate(self.shots_positions):
                    try:
                        # verifica se o tiro está carregado ou não
                        if shot_position != NOT_LOADED_ASTEROID_POSITION:
                            new_shot = {
                                'x': shot_position[0],
                                'y': shot_position[1],
                                'direction': self.shots_directions[index]
                            }
                            shots.append(new_shot)
                        else:
                            self.log_message(f'shot not loaded')
                    except Exception as exception:
                        self.log_message(f'error in loading shot n = {index}\n{exception}')
            except Exception as exception:
                        self.log_message(f'error in loading shots\n{exception}')
        
        self.shots = shots
        
        return
    
    
    def render(self):
        self.clear_screen()
        
        # telas possíveis: initial_menu, gameplay, gameover e players_scores
        actual_screen = 'players_scores'
        
        render_engines = {
            'initial_menu': self.render_initial_menu,  
            'gameplay': self.render_gameplay,  
            'gameover': self.render_gameover,  
            'players_scores': self.render_players_scores
        }
        
        render_engines[actual_screen]()
        
        return
    
    
    def render_gameplay(self):
        self.render_score()
        self.render_lifes()
        self.render_player()
        self.render_asteroids()
        self.render_shots()
        
        return
    
    
    def render_gameover(self, selected_option='enter_score'):
        gameover_x = self.relative_units_x(50)
        gameover_y = self.relative_units_x(20)
        
        self.draw_text('G A M E O V E R', pygame.font.SysFont(None, 52), self.colors['white'], gameover_x, gameover_y, 'center')
        
        vertical_spacing = self.relative_units_x(15)
        button_width = self.relative_units_x(60)
        button_height = self.relative_units_x(12)
        
        enter_score_x = self.relative_units_x(50)
        enter_score_y = self.relative_units_y(50)
        
        back_to_menu_x = self.relative_units_x(50)
        back_to_menu_y = self.relative_units_y(50) + vertical_spacing
        
        
        enter_score_selected = True if selected_option == 'enter_score' else False
        back_to_menu_selected = True if selected_option == 'back_to_menu' else False
        self.draw_button('enter score', enter_score_x, enter_score_y, button_width, button_height, enter_score_selected, 'center')
        self.draw_button('back to menu', back_to_menu_x, back_to_menu_y, button_width, button_height, back_to_menu_selected, 'center')
        
        return
    
    
    def render_initial_menu(self):
        self.render_brand()
        
        return
    
    
    def render_brand(self):
        x = self.relative_units_x(50)
        y = self.relative_units_y(20)
        self.draw_text('A S T R O G E N I U S', pygame.font.SysFont(None, 52), self.colors['white'], x, y, 'center')
        self.render_initial_menu_buttons(selected_option='start')
        
        return
    
    
    def render_initial_menu_buttons(self, selected_option='start'):
        x = self.relative_units_x(50)
        y = self.relative_units_y(50)
        
        width = self.relative_units_x(60)
        height = self.relative_units_x(12)
        vertical_spacing = self.relative_units_x(15)
        
        # destacar botão selecionado pelo jogador
        start_selected = True if selected_option == 'start' else False
        scores_selected = True if selected_option == 'scores' else False
        
        self.draw_button('start', x, y, width, height, start_selected, 'center')
        self.draw_button('scores', x, y + vertical_spacing, width, height, scores_selected, 'center')
        
    
    def render_players_scores(self):
        center_x, center_y = self.relative_units_x(50), self.relative_units_y(50)
        scores_text_x = center_x
        scores_text_y = self.relative_units_y(20)
        
        column_start_y = center_y
        column_margin_y = self.relative_units_y(5)
        column_spacing_x = self.relative_units_x(20)
        column_spacing_y = self.relative_units_y(5)
        left_column_x = center_x - column_spacing_x
        right_column_x = center_x + column_spacing_x
        
        
        self.draw_text('S C O R E S', pygame.font.SysFont(None, 52), self.colors['white'], scores_text_x, scores_text_y, 'center')
        self.draw_text('player', pygame.font.SysFont(None, 52), self.colors['white'], left_column_x, column_start_y, 'center')
        self.draw_text('score', pygame.font.SysFont(None, 52), self.colors['white'], right_column_x, column_start_y, 'center')
        
        for i, player in enumerate(self.players_scores):
            name, score = player['name'], str(player['score'])
            line_y = column_start_y + column_margin_y + i*column_spacing_y
            player_name_x = left_column_x
            player_name_y = line_y
            
            player_score_x = right_column_x
            player_score_y = line_y
            self.draw_text(name, pygame.font.SysFont(None, 36), self.colors['white'], player_name_x, player_name_y, 'center')
            self.draw_text(score, pygame.font.SysFont(None, 36), self.colors['white'], player_score_x, player_score_y, 'center')
        
        return
    
    
    def render_score(self):
        score = self.score
        
        x = self.relative_units_x(3)
        y = self.relative_units_y(3)
        
        font = pygame.font.SysFont(None, 24)
        
        if score != None:
            self.draw_text(f'SCORE: {score}', font, self.colors['white'], x, y, 'topleft')
        else:
            self.draw_text('SCORE: NOT LOADED', font, self.colors['white'], x, y, 'topleft')
    
    
    def render_lifes(self):      
        x_base = self.relative_units_x(3)
        y_base = self.relative_units_x(6)    
        x_spacing = self.relative_units_x(6)
        
        try:
            n = self.lifes_quantity
            
            life_img = self.images['life']
            
            for i in range(n):
                x_i = x_base + i*x_spacing
                y_i = y_base
                
                self.draw_image(life_img, x_i, y_i, 50, 50, 'topleft')
        except Exception as exeption:
            self.draw_text('LIFES NOT LOADED', self.default_text_font, self.colors['white'], x_base, y_base, 'topleft')
            pass
        
        return
    
    
    def render_player(self):
        player_direction = self.player_direction
        space_ship_img = self.images['space_ship']
        x_center = self.relative_units_x(50)
        y_center = self.relative_units_y(50)
        
        # definição do ângulo, em função da direção
        angle = 0
        if player_direction == 'UP':
            angle = 0
        elif player_direction == 'DOWN':
            angle = 180
        elif player_direction == 'LEFT':
            angle = 90
        elif player_direction == 'RIGHT':
            angle = -90
        else:
            angle = 0
        
        # rotação da imagem
        space_ship_img = pygame.transform.rotate(space_ship_img, angle)
        
        self.draw_image(space_ship_img, x_center, y_center, 50, 50, 'center')
        
        return
    
    
    def render_asteroids(self):
        asteroids = self.asteroids
        
        if asteroids != None:
            # renderiza cada asteroide
            for i, asteroid in enumerate(asteroids):
                x, y = asteroid['x'], asteroid['y']
                x, y = self.transform_coordinates(x, y)
                self.render_asteroid(x, y, i)

        return
    
    
    def render_shots(self):
        shots = self.shots
        
        if shots != None:
            # renderiza cada asteroide
            for shot in shots:
                x, y = shot['x'], shot['y']
                x, y = self.transform_coordinates(x, y)
                self.render_shot(x, y)

        return
    
    
    def render_shot(self, x, y):
        shot_img = self.images['shot']
        
        self.draw_image(shot_img, x, y, 10, 10, 'center')
        
        return
    
    
    def render_asteroid(self, x, y, asset_index=0):
        asteroid_img = self.get_asteroid_asset(asset_index)
        
        self.draw_image(asteroid_img, x, y, 40, 40, 'center')
        
        return
    
    
    def get_asteroid_asset(self, asset_index):
        n = 1 + (asset_index % 8)
        asteroid_img = self.images[f'asteroid_0{n}']
        
        return asteroid_img
    
    
    def transform_coordinates(self, x, y):
        new_x, new_y = 0, 0
        width, height = self.screen_width, self.screen_height
        horizontal_margin = self.relative_units_x(15)
        vertical_margin = self.relative_units_y(15)
        
        w, h, hm, vm = width, height, horizontal_margin, vertical_margin
        
        new_x = int(hm + ((w - 2*hm)/14)*x)
        new_y = int(vm + ((h - 2*vm)/14)*(14-y))
        
        return new_x, new_y
    
    
    def clear_screen(self):
        self.screen.fill(BLACK)
    
    
    def print_data(self):
        print(self.data)
        
        
    def draw_text(self, text, font, color, x, y, alignment='center'):
        screen = self.screen
        text_surface = font.render(text, True, color)
        text_rect = text_surface.get_rect()
        
        # alignment logic
        if alignment == 'center':
            text_rect.center = (x, y)
        elif alignment == 'topleft':
            text_rect.topleft = (x, y)
        elif alignment == 'bottomleft':
            text_rect.bottomleft = (x, y)
        elif alignment == 'topright':
            text_rect.topright = (x, y)
        elif alignment == 'bottomright':
            text_rect.bottomright = (x, y)
        else:
            text_rect.center = (x, y)
            
        screen.blit(text_surface, text_rect)

        return
    
    
    def draw_image(self, image, x, y, width, height, alignment='center'):
        resized_img = pygame.transform.scale(image, (width, height))
        
        rect = resized_img.get_rect()
        if alignment == "center":
            rect.center = (x, y)
        elif alignment == "topleft":
            rect.topleft = (x, y)
        elif alignment == "topright":
            rect.topright = (x, y)
        elif alignment == "bottomleft":
            rect.bottomleft = (x, y)
        elif alignment == "bottomright":
            rect.bottomright = (x, y)
            
        self.screen.blit(resized_img, rect)
        
        return
    
    
    def draw_button(self, text, x, y, width, height, pressed='false', alignment='center'):
        pressed_border_size = 6
        unpressed_border_size = 2
        
        x_min = x - (width//2)
        y_max = y - (height//2)
        
        rect = pygame.Rect(x_min, y_max, width, height)
                
        if pressed == True:
            self.draw_text(text, self.default_text_font, self.colors['white'], x, y, 'center')
            pygame.draw.rect(self.screen, self.colors['white'], rect, pressed_border_size)
        
        else:
            self.draw_text(text, self.default_text_font, self.colors['white'], x, y, 'center')
            pygame.draw.rect(self.screen, self.colors['white'], rect, unpressed_border_size)
        
        return
    
    
    def relative_units_x(self, x):
        ru_x = int(x*self.screen_width/100)
        
        return ru_x
    
    
    def relative_units_y(self, y):
        ru_y = int(y*self.screen_height/100)
        
        return ru_y
    
    
    def log_message(self, log_message):
        if self.log_messages:
            print(log_message)
            
        return