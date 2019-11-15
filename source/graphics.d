import std.concurrency;
import std.string;
import std.experimental.logger;

import bindbc.sdl;

import cat.wheel.ecs;
import cat.wheel.events;
import cat.wheel.graphics;
import cat.wheel.structs;

import app;
import body;
import camera;
import font;

immutable(int) fontHeight = 10;

class GrfxData {
	SDL_Texture *line1;

	string currentcmd;
	string renderedcmd;
	SDL_Texture* line2;

	SDL_Texture* currentRaster;
	SDL_Texture* currentRender;
	bool view;
}

Window window;
Graphics grfx;
Simulator sim;
Camera camer4;
GrfxData data;

bool continueRender = true;

class Simulator {
	Body[] bodies;
}

void setup() {
	info("Creating window and renderer");

	window = new Window("Black Hole Simulator", 0, 0, 640, 480 + fontHeight * 2 + 1);
	grfx = new Graphics(window);

	theFont = Font("SourceCodePro.ttf", fontHeight);
	Surface txt = theFont.render("Hello, World!");
	data.line1 = SDL_CreateTextureFromSurface(grfx.renderer, txt.sdl);

	info("Creating simulation");

	sim = new Simulator();

	camer4 = new Camera(new Graphics(window), sim);
	camer4.setPosition(Vector3F(-3, 0, 0));
}

Font theFont;

void render() {
	grfx.drawTexture(data.view ? data.currentRender : data.currentRaster, Rect(), Rect(0, 0, 640, 480));

	int line1Width;
	SDL_QueryTexture(data.line1, null, null, &line1Width, null);
	grfx.drawTexture(data.line1, Rect(), Rect(0, 480, line1Width, fontHeight));

	if (data.renderedcmd != data.currentcmd) {
		data.line2 = grfx.createTextureFrom(theFont.render(data.currentcmd));
		data.renderedcmd = data.currentcmd;
	}

	int line2Width;
	SDL_QueryTexture(data.line2, null, null, &line2Width, null);
	grfx.drawTexture(data.line2, Rect(), Rect(0, 480 + fontHeight + 1, line2Width, fontHeight));

	grfx.render();
	grfx.color = Color(0, 0, 0, 255);
	grfx.clear();
}