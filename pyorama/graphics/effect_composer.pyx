ctypedef EffectComposerC ItemTypeC
cdef uint8_t ITEM_TYPE = handle_create_item_type()
cdef size_t ITEM_SIZE = sizeof(ItemTypeC)

cdef class EffectComposer:
    def __cinit__(self, GraphicsManager manager):
        self.handle = 0
        self.manager = manager

    def __dealloc__(self):
        self.handle = 0
        self.manager = None
    
    @staticmethod
    cdef ItemTypeC *get_ptr_by_index(GraphicsManager manager, size_t index) except *:
        cdef:
            PyObject *slot_map_ptr
        slot_map_ptr = manager.slot_maps[<uint8_t>ITEM_TYPE]
        return <ItemTypeC *>(<ItemSlotMap>slot_map_ptr).items.c_get_ptr(index)

    @staticmethod
    cdef ItemTypeC *get_ptr_by_handle(GraphicsManager manager, Handle handle) except *:
        return <ItemTypeC *>manager.get_ptr(handle)

    cdef ItemTypeC *get_ptr(self) except *:
        return EffectComposer.get_ptr_by_handle(self.manager, self.handle)

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

    cpdef void create(self) except *:
        self.handle = self.manager.create(ITEM_TYPE)

    cpdef void delete(self) except *:
        self.manager.delete(self.handle)
        self.handle = 0

    def set_render_pass(self, Handle render_pass):
        cdef:
            EffectComposerC *composer_ptr
        composer_ptr = self.get_ptr()
        composer_ptr.render_pass = render_pass

    def set_effect_passes(self, list effect_passes):
        cdef:
            EffectComposerC *composer_ptr
            size_t i
            size_t n = <size_t>len(effect_passes)
        composer_ptr = self.get_ptr()
        memset(&composer_ptr.effect_passes, 0, sizeof(composer_ptr.effect_passes))
        for i in range(n):
            composer_ptr.effect_passes[i] = <Handle>effect_passes[i]