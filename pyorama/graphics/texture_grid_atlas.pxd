from pyorama.graphics.graphics_manager cimport *
from pyorama.graphics.texture cimport *

cdef class TextureGridAtlas:
    cdef:
        readonly Handle handle
        readonly GraphicsManager graphics

    cdef TextureGridAtlasC *get_ptr(self) except *
    cpdef void create(self, Texture texture, size_t num_rows, size_t num_columns) except *
    cpdef void delete(self) except *
    cpdef size_t get_num_rows(self) except *
    cpdef size_t get_num_columns(self) except *
    cpdef size_t get_row_from_index(self, size_t index) except *
    cpdef size_t get_column_from_index(self, size_t index) except *
    cpdef size_t get_index_from_row_column(self, size_t row, size_t column) except *