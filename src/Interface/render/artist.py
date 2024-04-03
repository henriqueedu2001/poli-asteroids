import pygame
from .screen import Screen

class Artist():
    def draw_line(screen: Screen, start_point, end_point, brush_size=3):
        pygame.draw.line(screen.pygame_screen, (255, 255, 255), start_point, end_point, brush_size)
        
        return
    
    
    def draw_text(screen: Screen, text, x, y):
        color = (255, 255, 255)
        font = pygame.font.SysFont(None, 24)
        text_surface = font.render(text, True, color)
        text_pos = (x, y)
            
        screen.pygame_screen.blit(text_surface, text_pos)

        return
    
    
    def draw_image(screen: Screen, image, x, y, width, height, alignment='center'):
        resized_img = pygame.transform.scale(image, (width, height))
        width, height = resized_img.get_width(), resized_img.get_height()
        # position = self.shift(x, y, width, height, alignment)

        screen.pygame_screen.blit(resized_img, (x, y))
        
        return
    
    
    def rotate_image(image, angle):
        return pygame.transform.rotate(image, angle)
    
    
    def draw_button(screen: Screen, text, x, y, width, height, pressed='false'):
        pressed_border_size = 6
        unpressed_border_size = 2
        
        x_min = x - (width//2)
        y_max = y - (height//2)
        
        rect = pygame.Rect(x_min, y_max, width, height)
                
        if pressed == True:
            Artist.draw_text(screen, text, x, y)
            pygame.draw.rect(screen.pygame_screen, (255, 255, 255), rect, pressed_border_size)
        
        else:
            Artist.draw_text(screen, text, x, y)
            pygame.draw.rect(screen.pygame_screen, (255, 255, 255), rect, unpressed_border_size)
        
        return