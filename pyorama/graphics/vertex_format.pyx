ctypedef VertexFormatC ItemTypeC
cdef uint8_t ITEM_TYPE = handle_create_item_type()
cdef size_t ITEM_SIZE = sizeof(ItemTypeC)

cdef uint32_t c_vertex_comp_type_to_gl(VertexCompType type) nogil:
    if type == VERTEX_COMP_TYPE_F32:
        return GL_FLOAT
    elif type == VERTEX_COMP_TYPE_I8:
        return GL_BYTE
    elif type == VERTEX_COMP_TYPE_U8:
        return GL_UNSIGNED_BYTE
    elif type == VERTEX_COMP_TYPE_I16:
        return GL_SHORT
    elif type == VERTEX_COMP_TYPE_U16:
        return GL_UNSIGNED_SHORT

cdef size_t c_vertex_comp_type_get_size(VertexCompType type) nogil:
    if type == VERTEX_COMP_TYPE_F32:
        return sizeof(float)
    elif type == VERTEX_COMP_TYPE_I8:
        return sizeof(int8_t)
    elif type == VERTEX_COMP_TYPE_U8:
        return sizeof(uint8_t)
    elif type == VERTEX_COMP_TYPE_I16:
        return sizeof(int16_t)
    elif type == VERTEX_COMP_TYPE_U16:
        return sizeof(uint16_t)

cdef class VertexFormat:
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

    cpdef void create(self, list comps) except *:
        cdef:
            VertexFormatC *format_ptr
            size_t num_comps
            size_t i
            tuple comp_tuple
            bytes name
            size_t name_length
            VertexCompC *comp
            size_t offset
            size_t comp_type_size
        num_comps = len(comps)
        if num_comps > 16:
            raise ValueError("VertexFormat: maximum number of vertex comps exceeded")
        self.handle = self.manager.create(ITEM_TYPE)
        format_ptr = self.c_get_ptr()
        offset = 0
        for i in range(num_comps):
            comp_tuple = <tuple>comps[i]
            comp = &format_ptr.comps[i]
            name = <bytes>comp_tuple[0]
            name_length = len(name)
            if name_length >= 256:
                raise ValueError("VertexFormat: comp name cannot exceed 255 characters")
            memcpy(comp.name, <char *>name, sizeof(char) * name_length)
            comp.name_length = name_length
            comp.type = <VertexCompType>comp_tuple[1]
            comp.count = <size_t>comp_tuple[2]
            comp.normalized = <bint>comp_tuple[3]
            comp.offset = offset
            if comp.type == VERTEX_COMP_TYPE_F32: comp_type_size = 4
            elif comp.type == VERTEX_COMP_TYPE_I8: comp_type_size = 1
            elif comp.type == VERTEX_COMP_TYPE_U8: comp_type_size = 1
            elif comp.type == VERTEX_COMP_TYPE_I16: comp_type_size = 2
            elif comp.type == VERTEX_COMP_TYPE_U16: comp_type_size = 2
            offset += comp.count * comp_type_size
        format_ptr.count = num_comps
        format_ptr.stride = offset

    cpdef void delete(self) except *:
        self.manager.delete(self.handle)
        self.handle = 0


    