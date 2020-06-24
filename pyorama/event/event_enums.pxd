from pyorama.libs.sdl2 cimport *

cpdef enum EventItemType:
    EVENT_ITEM_TYPE_LISTENER_KEY

cpdef enum:
    MAX_EVENT_TYPES = 65536

#maps to uint16_t (looking at SDL_LASTEVENT = 0xFFFF = 65535)
#Will use this to ensure value is within bounds
cpdef enum EventType:
    EVENT_TYPE_WINDOW = SDL_WINDOWEVENT
    EVENT_TYPE_KEY_DOWN = SDL_KEYDOWN
    EVENT_TYPE_KEY_UP = SDL_KEYUP
    EVENT_TYPE_MOUSE_MOTION = SDL_MOUSEMOTION
    EVENT_TYPE_MOUSE_BUTTON_DOWN = SDL_MOUSEBUTTONDOWN
    EVENT_TYPE_MOUSE_BUTTON_UP = SDL_MOUSEBUTTONUP
    EVENT_TYPE_MOUSE_WHEEL = SDL_MOUSEWHEEL

    #Non-SDL2 EventTypes
    EVENT_TYPE_ENTER_FRAME = SDL_USEREVENT#0x8000 (32768)
    EVENT_TYPE_USER = SDL_USEREVENT + 1024#reserve some EventType slots for pyorama
    EVENT_TYPE_LAST = SDL_LASTEVENT