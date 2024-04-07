from .screen import Screen
from .artist import Artist

class RenderLoading():
    def render(screen: Screen, data):
        x, y = screen.ru_x(50), screen.ru_y(30)
        font = Artist.get_font(font_size=32)
        Artist.draw_text(screen, 'L O A D I N G', x, y, font, alignment='center')
        return