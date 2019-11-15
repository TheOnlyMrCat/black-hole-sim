import std.concurrency;
import std.experimental.logger;
import std.string;

import bindbc.sdl;
import bindbc.sdl.ttf;

import cat.wheel.events;
import cat.wheel.graphics;
import cat.wheel.input;

import graphics;

int main() {
	info("Loading SDL");
	immutable(SDLSupport) sdlRet = loadSDL();
	if (sdlRet != sdlSupport) {
		if (sdlRet == SDLSupport.noLibrary) {
			fatal("Failed to load SDL. Make sure you have it installed on your system.");
		} else if (sdlRet == SDLSupport.badLibrary) {
			error("SDL failed to load in its entirity. The app will run, but some things may not work as expected.");
		}
	} else {
		info("SDL loaded successfully");
	}

	info("Loading SDL_TTF");
	immutable(SDLTTFSupport) ttfRet = loadSDLTTF();
	if (ttfRet != sdlTTFSupport) {
		if (ttfRet == SDLTTFSupport.noLibrary) {
			error("Failed to load SDL_TTF. No text can be displayed.");
			info("If text is desirable, ensure SDL_TTF is instlled on your system.");
		} else if (ttfRet == SDLTTFSupport.badLibrary) {
			error("SDL_TTF failed to load in its entirity. Some features may not work as expected.");
		}
	}

	initSDL(SDL_INIT_VIDEO | SDL_INIT_AUDIO | SDL_INIT_TIMER);

	if (TTF_Init() != 0) {
		error("Failed to initialise SDL_TTF.");
	}

	Handler handler = new Handler();

	handler.addDelegate((EventArgs args) {
		if (args.classinfo == typeid(PumpEventArgs) && (cast(PumpEventArgs) args).event.type == SDL_EventType.SDL_QUIT) {
			handler.stop();
		}
	}, ED_PUMP);

	info("Setting graphics up");

	setup();

	handler.addDelegate((args) {
		render();
	}, ED_POST_TICK);

	info("Setting input up");

	handler.addDelegate((args) {
		if (args.classinfo == typeid(PumpEventArgs)) {
			SDL_Event e = (cast(PumpEventArgs) args).event;

			if (e.type == SDL_EventType.SDL_TEXTEDITING) {
				data.currentcmd = e.edit.text.idup;
			// } else if (e.type == SDL_EventType.SDL_KEYDOWN) {
			// 	if (e.key.keysym.sym == SDL_Keycode.SDLK_RETURN) {
			// 		SDL_StopTextInput();
			// 	}
			} else if (e.type == SDL_EventType.SDL_TEXTINPUT) {
				data.currentcmd = "";
			}
		}
	}, ED_PUMP);

	// InputHandler input = new InputHandler(handler);

	// handler.addDelegate((args) {
	// 	if (args.classinfo == typeid(KeyboardEventArgs)) {
	// 		Keysym s = (cast(KeyboardEventArgs) args).sym;

	// 	}
	// }, EI_KEY_PRESSED);

	SDL_StartTextInput();

	info("Starting SDL Handler");

	handler.handle();

	if (TTF_WasInit()) TTF_Quit();

	return 0;
}
