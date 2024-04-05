from .screen import Screen
from .artist import Artist

class RenderInitialMenu():
    def render(screen: Screen, data):
        RenderInitialMenu.render_title(screen)
        RenderInitialMenu.render_buttons(screen)
        RenderInitialMenu.render_bottom(screen)
        
        return
    
    def render_title(screen: Screen):
        x = screen.ru_x(50)
        y = screen.ru_y(30)
        font = Artist.get_font(font_size=32)
        
        Artist.draw_text(screen, 'A S T R O G E N I U S', x, y, textfont=font, alignment='center')
        return
    
    
    def render_bottom(screen: Screen):
        x = screen.ru_x(50)
        y = screen.ru_y(95)
        line_spacing = screen.ru_size(2)
        
        font = Artist.get_font(font_size=12)
        
        authors = 'João Felipe, Henrique S. Souza, Luiz F. Körbes'
        
        Artist.draw_text(screen, 'Escola Politécnica da USP', x, y, font, alignment='center')
        Artist.draw_text(screen, authors, x, y + line_spacing, font, alignment='center')
        
        return
    
    
    def render_buttons(screen: Screen, selected_option='scores'):
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
