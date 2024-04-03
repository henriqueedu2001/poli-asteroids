from .screen import Screen
from .artist import Artist

class RenderDebug():
    def render(screen: Screen, data):
        RenderDebug.draw_title(screen)
        # RenderDebug.draw_axis(screen)
        RenderDebug.draw_grid_line(screen)
        
        return
    
    
    def draw_title(screen: Screen):
        Artist.draw_text(screen, 'D E B U G M O D E', 200, 200)
        
        return
    
    
    def draw_axis(screen: Screen):
        # vertical
        start = (screen.ru_x(50), screen.ru_y(0))
        end = (screen.ru_x(50), screen.ru_y(100))
        Artist.draw_line(screen, start, end)
        
        # horizontal
        start = (screen.ru_x(0), screen.ru_y(50))
        end = (screen.ru_x(100), screen.ru_y(50))
        Artist.draw_line(screen, start, end)
        
        return
    
    
    def draw_grid_line(screen: Screen, n: int = 8):
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
            x_i = screen.ru_x(i*delta_x)
            y_top = screen.ru_y(0)
            y_botom = screen.ru_y(100)
            
            start = (x_i, y_top)
            end = (x_i, y_botom)
            
            Artist.draw_line(screen, start, end)
        
        return