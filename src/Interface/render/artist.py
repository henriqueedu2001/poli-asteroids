import pygame
from .screen import Screen

def print_rect(rect):
    print("center:", rect.center, end='\t')
    print("topleft:", rect.topleft, end='\t')
    print("rect width:", rect.width, end='\t')
    print("rect height:", rect.height, end='\t')
    
    print()
    

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
    
    
    def draw_rect(screen: Screen, x, y, width, height):
        border_radius = 3
        rect = pygame.Rect(x, y, width, height)
        pygame.draw.rect(screen.pygame_screen, (255, 0, 0), rect, border_radius=border_radius)
        
    
    def draw_image(screen: Screen, image: pygame.Surface, x, y, width, height, border=False, alignment='center'):
        img = image
        img = pygame.transform.scale(image, (width, height))
        
        offset_x = -width//2
        offset_y = -height//2
        
        abs_x, abs_y = x + offset_x, y + offset_y
        
        if border:
            Artist.draw_rect(screen, abs_x, abs_y, width, height)
        
        screen.pygame_screen.blit(img, (abs_x, abs_y))
        
        return
    
    
    def rotate_image(image, angle):
        return pygame.transform.rotate(image, angle)
    
    
    def shift(x, y, width, height, alignment='center'):
        new_x, new_y = x, y
        
        if alignment == 'center':
            new_x, new_y = x -(width/2), y - (height/2)
        
        return new_x, new_y
    
    
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