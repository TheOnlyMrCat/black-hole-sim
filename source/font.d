import std.string;
import std.experimental.logger;

import bindbc.sdl;
import bindbc.sdl.ttf;

import cat.wheel.graphics : Surface;
import cat.wheel.structs;

struct Font {

    this(string file, int size) {
        _font = TTF_OpenFont(file.toStringz, size);
    }

    ~this() {
        TTF_CloseFont(_font);
    }

    Surface render(string text, Color c = Color(255, 255, 255, 255)) {
        return Surface(TTF_RenderText_Solid(_font, text.toStringz, SDL_Color(c.r, c.g, c.b, c.a)));
    }

private:
    TTF_Font* _font;
}