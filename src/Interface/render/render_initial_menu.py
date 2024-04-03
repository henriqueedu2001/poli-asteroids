from .screen import Screen
from .artist import Artist

class RenderInitialMenu():
    def render(screen: Screen, data):
        Artist.draw_text(screen, 'Initial Menu', WHITE, 200, 200, 'center')
        img = screen.images['space_ship']
        Artist.draw_image(screen, img, 200, 200, 400, 400)
        return