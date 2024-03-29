import pygame

SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600

WHITE = (255, 255, 255)
BLACK = (0, 0, 0)

class RenderEngine():
    def __init__(self, screen) -> None:
        self.data = None
        self.loaded_data = False
        self.screen = screen
        self.text_font = pygame.font.SysFont(None, 48)
        
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
        print(f'{self.data}')
        # pygame.draw.rect(self.screen, WHITE, (100, 100, 200, 150))
        self.draw_text('ffffff', self.text_font, WHITE, 200, 200)
        return
    
    
    def clear_screen(self):
        self.screen.fill(BLACK)
    
    
    def print_data(self):
        print(self.data)
        
        
    def draw_text(self, text, font, color, x, y):
        screen = self.screen
        text_surface = font.render(text, True, color)
        text_rect = text_surface.get_rect()
        text_rect.center = (x, y)
        screen.blit(text_surface, text_rect)

        return
    