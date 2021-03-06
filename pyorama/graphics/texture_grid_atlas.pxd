from pyorama.graphics.graphics_manager cimport *
from pyorama.graphics.texture cimport *

ctypedef struct TextureGridAtlasC:
    Handle handle
    Handle texture
    size_t num_rows
    size_t num_columns

cdef class TextureGridAtlas:
    cdef:
        readonly GraphicsManager manager
        readonly Handle handle
    
    cdef TextureGridAtlasC *c_get_ptr(self) except *

    @staticmethod
    cdef uint8_t c_get_type() nogil
    @staticmethod
    cdef size_t c_get_size() nogil
    cpdef void create(self, Texture texture, size_t num_rows, size_t num_columns) except *
    cpdef void delete(self) except *
    cpdef size_t get_num_rows(self) except *
    cpdef size_t get_num_columns(self) except *
    cpdef size_t get_row_from_index(self, size_t index) except *
    cpdef size_t get_column_from_index(self, size_t index) except *
    cpdef size_t get_index_from_row_column(self, size_t row, size_t column) except *