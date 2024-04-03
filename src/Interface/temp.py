from .screen import Screen
from .artist import Artist

class RenderDebug():
    def render(screen: Screen, data):
        RenderDebug.draw_title(screen)
        RenderDebug.draw_grid(screen)
        
        return
    
    
    def draw_title(screen: Screen):
        Artist.draw_text(screen, 'D E B U G M O D E', 200, 200)
        
        return
    
    
    def draw_grid(screen: Screen, n: int = 8):
        delta_x = 100/n
        delta_y = 100/n
        
        # linhas horizontais
        for i in range(n+1):
            x_left = screen.ru_x(0)
            x_right = screen.ru_x(100)
            y_i = screen.ru_y(i*delta_y)
            
            start = (x_left, y_i)
            end = (x_right, y_i)
            
            Artist.draw_line(screen, start, end)
        
         # linhas verticais
        for i in range(n+1):
            
            start = (x_left, y_i)
            end = (x_right, y_i)
            
            Artist.draw_line(screen, start, end)
        
        return
    
    
    
