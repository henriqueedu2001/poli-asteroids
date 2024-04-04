from .screen import Screen
from .artist import Artist

class RenderGameplay():
    asteroid_img_size = 7
    shot_img_size = 2
    player_img_size = 12
    life_img_size = 8
    
    def get_asteroids_pos(data):
        if data == None:
            return []
        
        positions = data['asteroids_positions'] if data is not None else None
        
        return positions
    
    
    def get_shots_pos(data):
        if data == None:
            return []
        
        positions = data['shots_positions'] if data is not None else None
        
        return positions
    
    
    def render(screen: Screen, data):
        score = data['score'] if data is not None else 0
        player = {
            'direction': data['player_direction'] if data is not None else 'NULL'
        }
        lifes_quantity = data['lifes_quantity'] if data is not None else 3
        asteroids = RenderGameplay.get_asteroids_pos(data)
        shots = RenderGameplay.get_shots_pos(data)
        
        # print(asteroids, shots)
        
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
        
        offset_x, offset_y = screen.ru_size(5), screen.ru_size(10)
        life_size = screen.ru_size(RenderGameplay.life_img_size)
        x_spacing = screen.ru_x(7)
        
        for i in range(lifes_quantity):
            x = offset_x + x_spacing*i
            y = offset_y
            Artist.draw_image(screen, img, x, y, life_size, life_size)
        
        return


    def render_player(screen: Screen, player):
        direction = player['direction']
        img = screen.images['space_ship']
        
        x = screen.ru_x(50)
        y = screen.ru_x(50)
        size = screen.ru_size(RenderGameplay.player_img_size)
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
        size = screen.ru_size(RenderGameplay.asteroid_img_size)
        
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
        size = screen.ru_size(RenderGameplay.shot_img_size)
        
        Artist.draw_image(screen, img, x, y, size, size)
        
        return