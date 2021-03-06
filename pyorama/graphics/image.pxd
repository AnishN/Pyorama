from pyorama.graphics.graphics_manager cimport *

ctypedef struct ImageC:
    Handle handle
    uint16_t width
    uint16_t height
    size_t bytes_per_channel#can be 1 (default), 2, 3, or 4
    size_t num_channels#can be 1, 2, 3, or 4 (default)
    size_t data_size
    uint8_t *data

cdef void c_image_data_flip_x(uint16_t width, uint16_t height, uint8_t *data) nogil
cdef void c_image_data_flip_y(uint16_t width, uint16_t height, uint8_t *data) nogil
cdef void c_image_data_premultiply_alpha(uint16_t width, uint16_t height, uint8_t *data) nogil

cdef class Image:
    cdef:
        readonly GraphicsManager manager
        readonly Handle handle
    
    cdef ImageC *c_get_ptr(self) except *
    @staticmethod
    cdef uint8_t c_get_type() nogil
    @staticmethod
    cdef size_t c_get_size() nogil
    cpdef void create(self, uint16_t width, uint16_t height, uint8_t[::1] data=*, size_t bytes_per_channel=*, size_t num_channels=*) except *
    cpdef void create_from_file(self, bytes file_path, bint flip_x=*, bint flip_y=*, bint premultiply_alpha=*) except *
    cpdef void delete(self) except *
    cpdef void set_data(self, uint8_t[::1] data=*) except *
    cpdef uint16_t get_width(self) except *
    cpdef uint16_t get_height(self) except *
    cpdef uint8_t[::1] get_data(self) except *