from .screen import Screen
from .artist import Artist

class RenderPlayersScores():
    def render(screen, data):
        Artist.draw_text(screen, 'Players Scores', (255, 255, 255), 200, 200, 'center')
        
        return