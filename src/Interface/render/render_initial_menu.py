from .screen import Screen
from .artist import Artist

class RenderInitialMenu():
    def render(screen: Screen, data):
        RenderInitialMenu.render_brand(screen)
        RenderInitialMenu.render_buttons(screen)
        
        return
    
    def render_brand(screen: Screen):
        x = screen.ru_x(50)
        y = screen.ru_y(30)
        
        Artist.draw_text(screen, 'A S T R O G E N I U S', x, y)
        return
    
    
    def render_buttons(screen: Screen, selected_option='start'):
        start_selected = True if selected_option == 'start' else False
        scores_selected = True if selected_option == 'scores' else False
        
        x = screen.ru_x(50)
        y = screen.ru_y(50)
        
        width = screen.ru_x(60)
        height = screen.ru_x(12)
        vertical_spacing = screen.ru_x(15)
        
        Artist.draw_button(screen, 'start game', x, y, width, height, start_selected)
        Artist.draw_button(screen, 'see scores', x, y + vertical_spacing, width, height, scores_selected)
        
        return
