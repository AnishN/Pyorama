ctypedef ImageC ItemTypeC
cdef uint8_t ITEM_TYPE = handle_create_item_type()
cdef size_t ITEM_SIZE = sizeof(ItemTypeC)

cdef void c_image_data_flip_x(uint16_t width, uint16_t height, uint8_t *data) nogil:
    cdef:
        uint32_t *data_ptr
        size_t y
        size_t src, dst
        uint16_t left, right
    data_ptr = <uint32_t *>data
    for y in range(height):
        left = 0
        right = width - 1
        while left < right:
            src = y * width + left
            dst = y * width + right
            data_ptr[src], data_ptr[dst] = data_ptr[dst], data_ptr[src]
            left += 1
            right -= 1

cdef void c_image_data_flip_y(uint16_t width, uint16_t height, uint8_t *data) nogil:
    cdef:
        uint32_t *data_ptr
        size_t x
        size_t src, dst
        uint16_t top, bottom
    data_ptr = <uint32_t *>data
    for x in range(width):
        top = 0
        bottom = height - 1
        while top < bottom:
            src = top * width + x
            dst = bottom * width + x
            data_ptr[src], data_ptr[dst] = data_ptr[dst], data_ptr[src]
            top += 1
            bottom -= 1

cdef void c_image_data_premultiply_alpha(uint16_t width, uint16_t height, uint8_t *data) nogil:
    cdef size_t i
    for i in range(0, width * height * 4, 4):
        data[i] = <uint16_t>data[i] * data[i + 3] / 255
        data[i + 1] = <uint16_t>data[i + 1] * data[i + 3] / 255
        data[i + 2] = <uint16_t>data[i + 2] * data[i + 3] / 255

cdef class Image:
    def __cinit__(self, GraphicsManager manager):
        self.handle = 0
        self.manager = manager

    def __dealloc__(self):
        self.handle = 0
        self.manager = None
    
    cdef ItemTypeC *c_get_ptr(self) except *:
        return <ItemTypeC *>self.manager.c_get_ptr(self.handle)

    @staticmethod
    cdef uint8_t c_get_type() nogil:
        return ITEM_TYPE

    @staticmethod
    def get_type():
        return ITEM_TYPE

    @staticmethod
    cdef size_t c_get_size() nogil:
        return ITEM_SIZE

    @staticmethod
    def get_size():
        return ITEM_SIZE

    cpdef void create(self, uint16_t width, uint16_t height, uint8_t[::1] data=None, size_t bytes_per_channel=1, size_t num_channels=4) except *:
        cdef:
            ImageC *image_ptr
        if width == 0:
            raise ValueError("Image: width cannot be zero pixels")
        if height == 0:
            raise ValueError("Image: height cannot be zero pixels")
        self.handle = self.manager.create(ITEM_TYPE)
        image_ptr = self.c_get_ptr()
        image_ptr.width = width
        image_ptr.height = height
        image_ptr.bytes_per_channel = bytes_per_channel
        image_ptr.num_channels = num_channels
        image_ptr.data_size = <uint64_t>width * <uint64_t>height * bytes_per_channel * num_channels
        image_ptr.data = <uint8_t *>calloc(image_ptr.data_size, sizeof(uint8_t))
        if image_ptr.data == NULL:
            raise MemoryError("Image: cannot allocate memory for data")
        self.set_data(data)
    
    cpdef void create_from_file(self, bytes file_path, bint flip_x=False, bint flip_y=False, bint premultiply_alpha=True) except *:
        cdef:
            SDL_Surface *surface
            SDL_Surface *converted_surface
            uint16_t width
            uint16_t height
            size_t data_size
            size_t left, right, top, bottom
            size_t x, y, z
            size_t src, dst
            uint8_t *data_ptr
            uint8_t[::1] data
        surface = IMG_Load(file_path)
        if surface == NULL:
            print(IMG_GetError())
            raise ValueError("Image: cannot load from path")
        converted_surface = SDL_ConvertSurfaceFormat(surface, SDL_PIXELFORMAT_RGBA32, 0)
        if converted_surface == NULL:
            raise ValueError("Image: cannot convert to RGBA format")
        width = converted_surface.w
        height = converted_surface.h
        data_size = width * height * 4
        data_ptr = <uint8_t *>converted_surface.pixels
        data = <uint8_t[:data_size]>data_ptr
        if flip_x:
            c_image_data_flip_x(width, height, data_ptr)
        if not flip_y:#NOT actually flips the data to match OpenGL coordinate system
            c_image_data_flip_y(width, height, data_ptr)
        if premultiply_alpha:
            c_image_data_premultiply_alpha(width, height, data_ptr)
        self.create(width, height, data)
        SDL_FreeSurface(surface)
        SDL_FreeSurface(converted_surface)
    
    cpdef void delete(self) except *:
        cdef:
            ImageC *image_ptr
        image_ptr = self.c_get_ptr()
        free(image_ptr.data)
        self.manager.delete(self.handle)
        self.handle = 0
    
    cpdef void set_data(self, uint8_t[::1] data=None) except *:
        cdef:
            ImageC *image_ptr
        image_ptr = self.c_get_ptr()
        if data != None:
            if data.shape[0] != image_ptr.data_size:
                raise ValueError("Image: invalid data size")
            memcpy(image_ptr.data, &data[0], image_ptr.data_size)
        else:
            memset(image_ptr.data, 0, image_ptr.data_size)

    cpdef uint16_t get_width(self) except *:
        return self.c_get_ptr().width

    cpdef uint16_t get_height(self) except *:
        return self.c_get_ptr().height
    
    cpdef uint8_t[::1] get_data(self) except *:
        cdef:
            ImageC *image_ptr
        image_ptr = self.c_get_ptr()
        return <uint8_t[:image_ptr.data_size]>image_ptr.data