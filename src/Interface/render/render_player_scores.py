from .screen import Screen
from .artist import Artist

class RenderPlayersScores():
    def render(screen: Screen, data):
        x, y = screen.ru_x(50), screen.ru_y(30)
        font = Artist.get_font(32)
        Artist.draw_text(screen, 'S C O R E S', x, y, font, alignment='center')
        
        return