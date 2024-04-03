from .screen import Screen
from .artist import Artist

class RenderGameOver():
    def render(screen, data):
        Artist.draw_text(screen, 'Game Over', WHITE, 200, 200, 'center')
        
        return