from .screen import Screen
from .artist import Artist

class RenderGameOver():
    def render(screen, data):
        Artist.draw_text(screen, 'Game Over', (255, 255, 255), 200, 200, 'center')
        
        return