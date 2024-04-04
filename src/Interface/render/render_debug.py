from .screen import Screen
from .artist import Artist

class RenderDebug():
    asteroid_img_size = 7
    shot_img_size = 3
    player_img_size = 12
    life_img_size = 8
    
    def render(screen: Screen, data):
        RenderDebug.draw_title(screen)
        RenderDebug.draw_axis(screen)
        RenderDebug.draw_grid_line(screen)
        RenderDebug.draw_inner_grid_lines(screen)
        # RenderDebug.draw_img(screen, 'space_ship', 300, 300, 200, 200)
        RenderDebug.draw_player(screen)
        RenderDebug.draw_img_grid(screen, img_name='asteroid_01', n=16, img_size=7, inner_grid=True)
        
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
    
    
    def draw_player(screen: Screen, img_size=12):        
        size = screen.ru_x(img_size)
        
        x = screen.ru_x(50)
        y = screen.ru_y(50)
        size_x, size_y = size, size
        
        RenderDebug.draw_img(screen, 'space_ship', x, y, size_x, size_y)
        
        return
    
    
    def grid_positions(screen: Screen, n: int = 8, inner_grid=False):
        positions = []
        
        delta_x = 100/n
        delta_y = 100/n
        
        for i in range(n):
            for j in range(n):
                if inner_grid:                    
                    x = screen.grid_x(i)
                    y = screen.grid_y(j)
                    positions.append((x, y))
                else:
                    x = screen.ru_x(i*delta_x)
                    y = screen.ru_y(j*delta_y)
                    positions.append((x, y))
        
        return positions
                
                
    def draw_img_grid(screen: Screen, img_name='space_ship', img_size=10, n: int = 8, inner_grid=False):
        size = screen.ru_y(img_size)
        size_x, size_y = size, size
        
        for i in range(n-1):
            for j in range(n-1):
                x, y = screen.grid_x(i), screen.grid_y(j)
                RenderDebug.draw_img(screen, img_name, x, y, size_x, size_y)
        
        return
    
    
    def draw_inner_grid_lines(screen: Screen, n=16):
        
        # linhas horizontais
        for i in range(n-1):
            x_left = screen.grid_x(0)
            x_right = screen.grid_x(14)
            y_i = screen.grid_y(i)
            
            start = (x_left, y_i)
            end = (x_right, y_i)
            
            Artist.draw_line(screen, start, end)
        
        # linhas verticais
        for i in range(n-1):
            x_i = screen.grid_x(i)
            y_top = screen.grid_y(14)
            y_botom = screen.grid_y(0)
            
            start = (x_i, y_top)
            end = (x_i, y_botom)
            
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
    
    
    def draw_img(screen: Screen, img_name, x, y, width, height):
        img = screen.images[img_name]
        Artist.draw_image(screen, img, x, y, width, height)
        
        return
    
    
    def get_img(screen: Screen, img_name):
        img = screen.images[img_name]
        
        return img