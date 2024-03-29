import pygame
import os

WHITE = (255, 255, 255)
BLACK = (0, 0, 0)

class RenderEngine():
    def __init__(self, screen) -> None:
        self.data = None
        self.loaded_data = False
        self.screen = screen
        self.screen_width, self.screen_height = screen.get_size()
        self.default_text_font = pygame.font.SysFont(None, 24)
        self.log_messages = True
        
        # state variables
        self.score = None
        self.player_direction = None
        self.lifes_quantity = None
        self.game_difficulty = None
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
            'asteroid_01': None,
            'asteroid_02': None,
            'asteroid_03': None,
            'asteroid_04': None
        }
        
        self.images_paths = {
            'life': 'foto.jpeg',
            'space_ship': 'foto.jpeg',
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
        
        return
    
    
    def render(self):
        self.clear_screen()
        
        # render the graphic elements
        self.render_score()
        
        self.draw_image(self.images['life'], 150, 150, 100, 100)
        
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
    
    
    def draw_image(self, image, x, y, width, height):
        resized_img = pygame.transform.scale(image, (width, height))
        self.screen.blit(resized_img, (x, y))
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