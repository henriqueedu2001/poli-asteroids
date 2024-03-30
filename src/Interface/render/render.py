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
        self.shooting_positions = None
        self.shooting_directions = None
        self.played_special_shooting = None
        self.available_special_shooting = None
        self.played_shooting = None
        self.end_of_lifes = None
        
        self.colors = {
            'white': (255, 255, 255),
            'black': (0, 0, 0)
        }
        
        self.images = {
            'life': None,
            'space_ship': None,
            'asteroid': None,
            'asteroid_01': None,
            'asteroid_02': None,
            'asteroid_03': None,
            'asteroid_04': None
        }
        
        self.images_paths = {
            'life': 'foto.jpeg',
            'space_ship': 'foto.jpeg',
            'asteroid': 'foto.jpeg',
            'asteroid_01': 'foto.jpeg',
            'asteroid_02': 'foto.jpeg',
            'asteroid_03': 'foto.jpeg',
            'asteroid_04': 'foto.jpeg'
        }
        
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
            self.shooting_positions = data['shooting_positions']
            self.shooting_directions = data['shooting_directions']
            self.played_special_shooting = data['played_special_shooting']
            self.available_special_shooting = data['available_special_shooting']
            self.played_shooting = data['played_shooting']
            self.end_of_lifes = data['end_of_lifes']
        except:
            pass
        
        # carrega os asteroides
        self.load_asteroids()
        
        return
    
    
    def load_asteroids(self):
        asteroids = []
        
        # print(f'{self.data}')
        
        try:
            for index, asteroid_position in enumerate(self.asteroids_positions):
                try:
                    # verifica se o asteroide está carregado ou não
                    if asteroid_position != NOT_LOADED_ASTEROID_POSITION:
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
    
    
    def render(self):
        self.clear_screen()
        
        # render the graphic elements
        self.render_score()
        self.render_lifes()
        self.render_player()
        self.render_asteroids()
        
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
        # n = self.lifes_quantity
        life_img = self.images['life']
        n = 3
        
        x_base = self.relative_units_x(3)
        y_base = self.relative_units_x(6)
        
        x_spacing = self.relative_units_x(6)
        
        for i in range(n):
            x_i = x_base + i*x_spacing
            
            self.draw_image(life_img, x_i, y_base, 30, 30, 'topleft')
        
        return
    
    
    def render_player(self):
        # player_direction = self.player_direction
        player_direction = 'UP'
        space_ship_img = self.images['space_ship']
        x_center = self.relative_units_x(50)
        y_center = self.relative_units_x(50)
        
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
        
        self.draw_image(space_ship_img, x_center, y_center, 30, 30, 'center')
        
        return
    
    
    def render_asteroids(self):
        
        return


    def render_asteroid(self):
        asteroid_img = self.images['asteroid']
        
        x = self.relative_units_x(20)
        y = self.relative_units_y(20)
        
        self.draw_image(asteroid_img, x, y, 30, 30, 'center')
        
        return
    
    
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