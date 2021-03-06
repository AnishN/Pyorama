from cpython.object cimport *
from pyorama.core.item_slot_map cimport *
from pyorama.graphics.graphics_manager cimport *

cpdef enum FrameBufferAttachment:
    FRAME_BUFFER_ATTACHMENT_COLOR_0
    FRAME_BUFFER_ATTACHMENT_COLOR_1
    FRAME_BUFFER_ATTACHMENT_COLOR_2
    FRAME_BUFFER_ATTACHMENT_COLOR_3
    FRAME_BUFFER_ATTACHMENT_COLOR_4
    FRAME_BUFFER_ATTACHMENT_COLOR_5
    FRAME_BUFFER_ATTACHMENT_COLOR_6
    FRAME_BUFFER_ATTACHMENT_COLOR_7
    FRAME_BUFFER_ATTACHMENT_COLOR_8
    FRAME_BUFFER_ATTACHMENT_COLOR_9
    FRAME_BUFFER_ATTACHMENT_COLOR_10
    FRAME_BUFFER_ATTACHMENT_COLOR_11
    FRAME_BUFFER_ATTACHMENT_COLOR_12
    FRAME_BUFFER_ATTACHMENT_COLOR_13
    FRAME_BUFFER_ATTACHMENT_COLOR_14
    FRAME_BUFFER_ATTACHMENT_COLOR_15
    FRAME_BUFFER_ATTACHMENT_DEPTH
    FRAME_BUFFER_ATTACHMENT_STENCIL

cpdef enum:
    MAX_FRAME_BUFFER_ATTACHMENTS = 8

ctypedef struct FrameBufferC:
    Handle handle
    uint32_t gl_id
    Handle[8] textures
    FrameBufferAttachment[8] attachments
    size_t num_attachments

cdef uint32_t c_frame_buffer_attachment_to_gl(FrameBufferAttachment attachment) nogil

cdef class FrameBuffer:
    cdef:
        readonly GraphicsManager manager
        readonly Handle handle
    
    cdef FrameBufferC *c_get_ptr(self) except *
    @staticmethod
    cdef uint8_t c_get_type() nogil
    @staticmethod
    cdef size_t c_get_size() nogil
    cpdef void create(self) except *
    cpdef void delete(self) except *
    cpdef void attach_textures(self, dict textures) except *