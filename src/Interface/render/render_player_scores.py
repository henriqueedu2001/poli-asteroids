from .screen import Screen
from .artist import Artist

class RenderPlayersScores():
    def render(screen, data):
        Artist.draw_text(screen, 'Players Scores', WHITE, 200, 200, 'center')
        
        return