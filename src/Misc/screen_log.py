import os
import pygame
import random
import time

SCREEN_WIDTH = 600
SCREEN_HEIGHT = 600

WHITE = (255, 255, 255)
BLACK = (0, 0, 0)

IMG_PATH = 'space_ship.svg'

class Game():
    def __init__(self) -> None:
        self.screen = None
        self.clock = None
        self.screen_width = None
        self.screen_height = None
        self.display_info = None
        self.img = None
        
        return
    
    def start_game(self):
        pygame.init()
        self.screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
        self.clock = pygame.time.Clock()
        self.screen_width = pygame.display.Info().current_w
        self.screen_height = pygame.display.Info().current_h
        self.display_info = pygame.display.Info()
        
        # self.print_relative_units()
        # print(self.display_info)
        # print(f'SCREEN DIMENSIONS\nwidth = {self.screen_width} height={self.screen_height}')
        
        self.load_img()
        
        self.run_game()
        
        return
    
    
    def run_game(self):
        running = True
        
        while running:
            self.render()
            
            # lógica de saída
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    running = False
            
            # Limpe a tela
            pygame.display.flip()
        
        pygame.quit()
        
        return
    
    
    def render(self):
        screen = self.screen
        
        self.draw_grid()
        self.draw_images()
        
        return
    
    
    def draw_images(self):
        n = 8
        
        delta_x = 100/n
        delta_y = 100/n
        
        for i in range(n+1):
            for j in range(n+1):
                x = self.relative_units_x(i*delta_x)
                y = self.relative_units_y(j*delta_y)
                self.draw_image(self.img, x, y, 20, 20)
        
        return
    
    
    def draw_line(self, start_point, end_point):
        screen = self.screen
        brush_size = 3
        
        pygame.draw.line(screen, WHITE, start_point, end_point, brush_size)
        
        return
    
    
    def draw_image(self, image, x, y, width, height, alignment='center'):
        resized_img = pygame.transform.scale(image, (width, height))
        pos = (x, y)
        
        print(pos)
        self.screen.blit(resized_img, pos)
        
        return
    
    
    def relative_units_x(self, x):
        ru_x = int(x*self.screen_width/100)
        
        return ru_x
    
    
    def relative_units_y(self, y):
        ru_y = int(y*self.screen_height/100)
        
        return ru_y
    
    
    def load_img(self):
        script_dir = os.path.dirname(os.path.abspath(__file__))
        path = os.path.join(script_dir, IMG_PATH)
        
        self.img = pygame.image.load(path)
        
        return
    
    
    def draw_grid(self):        
        n = 8
        
        start = (self.relative_units_x(0), self.relative_units_y(0))
        end = (self.relative_units_x(100), self.relative_units_y(100))
        
        self.draw_line(start, end)
        self.draw_line(start, end)
        
        # # vertical
        for i in range(n+1):
            x = self.relative_units_x(i*(100/n))
            y_top = self.relative_units_y(0)
            y_bottom = self.relative_units_y(100)
            start_point = (x, y_top)
            end_point = (x, y_bottom)
            self.draw_line(start_point, end_point)
            
        for i in range(n+1):
            y = self.relative_units_y(i*(100/n))
            x_left = self.relative_units_x(0)
            x_right = self.relative_units_x(100)
            start_point = (x_left, y)
            end_point = (x_right, y)
            self.draw_line(start_point, end_point)
    
    
    def print_relative_units(self):
        print('relative units')
        
        for i in range(101):
            for j in range(101):
                x = self.relative_units_x(i)
                y = self.relative_units_y(j)
                
                print(f'ru_x = {i} => {x}\tru_y = {j} => {y}')

game = Game()
game.start_game()