from pyorama.graphics.graphics_manager cimport *
from pyorama.graphics.mesh cimport *
from pyorama.graphics.buffer_enums cimport *

ctypedef struct IndexBufferC:
    Handle handle
    uint32_t gl_id
    IndexFormat format
    BufferUsage usage
    size_t size

cdef size_t c_index_format_get_size(IndexFormat format) nogil
cdef uint32_t c_index_format_to_gl(IndexFormat format) nogil

cdef class IndexBuffer:
    cdef:
        readonly GraphicsManager manager
        readonly Handle handle
    
    cdef IndexBufferC *c_get_ptr(self) except *
    @staticmethod
    cdef uint8_t c_get_type() nogil
    @staticmethod
    cdef size_t c_get_size() nogil
    cpdef void create(self, IndexFormat format, BufferUsage usage=*) except *
    cpdef void delete(self) except *
    cdef void c_set_data(self, uint8_t *data_ptr, size_t data_size) except *
    cpdef void set_data(self, uint8_t[::1] data) except *
    cpdef void set_data_from_mesh(self, Mesh mesh) except *
    cdef void c_set_sub_data(self, uint8_t *data_ptr, size_t data_size, size_t offset) except *
    cpdef void set_sub_data(self, uint8_t[::1] data, size_t offset) except *
    cpdef void set_sub_data_from_mesh(self, Mesh mesh, size_t offset) except *
    cdef void c_draw(self) except *