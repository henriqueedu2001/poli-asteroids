from .screen import Screen
from .artist import Artist

class RenderGameplay():
    asteroid_img_size = 70
    shot_img_size = 20
    player_img_size = 70
    
    def render(screen: Screen, data):
        score = data['score'] if data is not None else 0
        player = {
            'direction': data['player_direction'] if data is not None else 'NULL'
        }
        lifes_quantity = data['lifes_quantity'] if data is not None else 3
        asteroids = [
            (7, 7),
            (0, 0),
            (15, 15),
            (0, 15),
            (15, 0)
        ]
        
        shots = [
            (2, 4),
            (14, 12),
            (15, 13),
            (2, 4),
            (15, 0)
        ]
        
        RenderGameplay.render_score(screen, score)
        RenderGameplay.render_player(screen, player)
        RenderGameplay.render_lifes(screen, lifes_quantity)
        RenderGameplay.render_asteroids(screen, asteroids)
        RenderGameplay.render_shots(screen, shots)
        
        return
    
    def render_score(screen: Screen, score):
        text = f'SCORE: {score}'
        x = screen.ru_x(3)
        y = screen.ru_y(3)
        
        Artist.draw_text(screen, text, x, y)
        
        return


    def render_lifes(screen: Screen, lifes_quantity):
        img = screen.images['life']
        
        for i in range(lifes_quantity):
            x_spacing = screen.ru_x(i*4.5)
            x = screen.ru_x(3) + x_spacing
            y = screen.ru_y(6)
            Artist.draw_image(screen, img, x, y, 40, 40)
        
        return


    def render_player(screen: Screen, player):
        direction = player['direction']
        img = screen.images['space_ship']
        
        x = screen.ru_x(50)
        y = screen.ru_x(50)
        size = RenderGameplay.player_img_size
        angle = 0
        
        if direction == 'UP':
            angle = 0
        elif direction == 'DOWN':
            angle = 180
        elif direction == 'LEFT':
            angle = 90
        elif direction == 'RIGHT':
            angle = -90
        else:
            angle = 0
        
        img = Artist.rotate_image(img, angle)
        
        Artist.draw_image(screen, img, x, y, size, size)
        
        return


    def render_asteroids(screen: Screen, asteroids):
        for i, asteroid in enumerate(asteroids):
            x_index, y_index = asteroid[0], asteroid[1]
            
            if x_index != 0 or y_index != 0:
                x = screen.grid_x(x_index)
                y = screen.grid_y(y_index)
                
                RenderGameplay.render_asteroid(screen, x, y, asset_index=i)
        
        return
    
    
    def render_asteroid(screen: Screen, x, y, asset_index=0):
        img = RenderGameplay.get_asteroid_asset(asset_index, screen.images)
        size = RenderGameplay.asteroid_img_size
        
        Artist.draw_image(screen, img, x, y, size, size)
        
        return
    
    
    def get_asteroid_asset(asset_index, images):
        n = 1 + (asset_index % 8)
        asteroid_img = images[f'asteroid_0{n}']
        
        return asteroid_img


    def render_shots(screen: Screen, shots):
        for shot in shots:
            x_index, y_index = shot[0], shot[1]
            
            if x_index != 0 or y_index != 0:
                x = screen.grid_x(x_index)
                y = screen.grid_y(y_index)
                
                RenderGameplay.render_shot(screen, x, y)
                
        return
    
    
    def render_shot(screen: Screen, x, y):
        img = screen.images['shot']
        size = RenderGameplay.shot_img_size
        
        Artist.draw_image(screen, img, x, y, size, size)
        
        return