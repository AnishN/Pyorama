ctypedef SpriteBatchC ItemTypeC
cdef uint8_t ITEM_TYPE = handle_create_item_type()
cdef size_t ITEM_SIZE = sizeof(ItemTypeC)

cdef class SpriteBatch:
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

    cpdef void create(self) except *:
        self.handle = self.manager.create(ITEM_TYPE)

    cpdef void delete(self) except *:
        cdef:
            SpriteBatchC *batch_ptr
        batch_ptr = self.c_get_ptr()
        free(batch_ptr.sprites)
        free(batch_ptr.vertex_data_ptr)
        free(batch_ptr.index_data_ptr)
        self.manager.delete(self.handle)
        self.handle = 0

    cpdef void set_sprites(self, list sprites) except *:
        cdef:
            SpriteBatchC *batch_ptr
            VertexBuffer vbo = VertexBuffer(self.manager)
            IndexBuffer ibo = IndexBuffer(self.manager)
            size_t i
            size_t num_sprites = len(sprites)

        batch_ptr = self.c_get_ptr()
        if num_sprites != batch_ptr.num_sprites:
            #recreate sprite handles buffer
            free(batch_ptr.sprites)
            batch_ptr.sprites = <Handle *>calloc(num_sprites, sizeof(Handle))
            if batch_ptr.sprites == NULL:
                raise MemoryError("SpriteBatch: cannot allocate sprite handles")

            #recreate vertex buffer
            free(batch_ptr.vertex_data_ptr)
            vbo.create(self.manager.v_fmt_sprite, usage=BUFFER_USAGE_DYNAMIC)
            batch_ptr.vertex_buffer = vbo.handle
            v_fmt_ptr = <VertexFormatC *>self.manager.c_get_ptr(self.manager.v_fmt_sprite.handle)
            vbo_size = v_fmt_ptr.stride * 6 * num_sprites
            batch_ptr.vertex_data_ptr = <uint8_t *>calloc(1, vbo_size)
            if batch_ptr.vertex_data_ptr == NULL:
                raise MemoryError("SpriteBatch: cannot allocate vertex data")

            #recreate index buffer
            free(batch_ptr.index_data_ptr)
            ibo.create(self.manager.i_fmt_sprite, usage=BUFFER_USAGE_DYNAMIC)
            batch_ptr.index_buffer = ibo.handle
            ibo_size = sizeof(uint32_t) * 6 * num_sprites
            batch_ptr.index_data_ptr = <uint8_t *>calloc(1, ibo_size)
            if batch_ptr.index_data_ptr == NULL:
                raise MemoryError("SpriteBatch: cannot allocate index data")

        batch_ptr.num_sprites = num_sprites
        for i in range(num_sprites):
            batch_ptr.sprites[i] = (<Sprite>sprites[i]).handle

    cpdef VertexBuffer get_vertex_buffer(self):
        cdef:
            SpriteBatchC *batch_ptr
            VertexBuffer out = VertexBuffer(self.manager)
        batch_ptr = self.c_get_ptr()
        out.handle = batch_ptr.vertex_buffer
        return out

    cpdef IndexBuffer get_index_buffer(self):
        cdef:
            SpriteBatchC *batch_ptr
            IndexBuffer out = IndexBuffer(self.manager)
        batch_ptr = self.c_get_ptr()
        out.handle = batch_ptr.index_buffer
        return out

    cdef void c_update(self) except *:
        cdef:
            SpriteBatchC *batch_ptr
            SpriteC *sprite_ptr
            size_t i, j, index
            Vec4C[6] vertex_tex_coord
            VertexBuffer v_buffer = VertexBuffer(self.manager)
            IndexBuffer i_buffer = IndexBuffer(self.manager)
            VertexFormatC *v_fmt_ptr
            uint8_t *vbo_ptr
            uint8_t *ibo_ptr
            size_t vbo_size, ibo_size
            uint8_t *vbo_index
            uint8_t *ibo_index
            
        vertex_tex_coord = [
            Vec4C(0.0, 0.0, 0.0, 0.0),
            Vec4C(1.0, 0.0, 1.0, 0.0),
            Vec4C(0.0, 1.0, 0.0, 1.0),
            Vec4C(0.0, 1.0, 0.0, 1.0),
            Vec4C(1.0, 0.0, 1.0, 0.0),
            Vec4C(1.0, 1.0, 1.0, 1.0),
        ]
        v_fmt_ptr = self.manager.v_fmt_sprite.c_get_ptr()
        batch_ptr = self.c_get_ptr()
        vbo_size = v_fmt_ptr.stride * 6 * batch_ptr.num_sprites
        ibo_size = sizeof(uint32_t) * 6 * batch_ptr.num_sprites
        vbo_ptr = batch_ptr.vertex_data_ptr
        ibo_ptr = batch_ptr.index_data_ptr

        for i in range(batch_ptr.num_sprites):
            sprite_ptr = <SpriteC *>self.manager.c_get_ptr_by_index(Sprite.c_get_type(), i)
            for j in range(6):
                index = 6 * i + j
                vbo_index = vbo_ptr + (index * v_fmt_ptr.stride)
                memcpy(vbo_index + 0, &vertex_tex_coord[j], sizeof(Vec4C))
                memcpy(vbo_index + sizeof(Vec4C), &sprite_ptr.position, sizeof(Vec2C))
                memcpy(vbo_index + sizeof(Vec4C) + sizeof(Vec2C), &sprite_ptr.z_index, sizeof(float))
                memcpy(vbo_index + sizeof(Vec4C) + sizeof(Vec3C), &sprite_ptr.rotation, sizeof(float))
                memcpy(vbo_index + (2 * sizeof(Vec4C)), &sprite_ptr.width, sizeof(float))
                memcpy(vbo_index + (2 * sizeof(Vec4C)) + sizeof(float), &sprite_ptr.height, sizeof(float))
                memcpy(vbo_index + (2 * sizeof(Vec4C)) + sizeof(Vec2C), &sprite_ptr.scale, sizeof(Vec2C))
                memcpy(vbo_index + (3 * sizeof(Vec4C)), &sprite_ptr.tint, sizeof(Vec3C))
                memcpy(vbo_index + (3 * sizeof(Vec4C)) + sizeof(Vec3C), &sprite_ptr.alpha, sizeof(float))
                memcpy(vbo_index + (4 * sizeof(Vec4C)), &sprite_ptr.anchor, sizeof(Vec2C))
                ibo_index = ibo_ptr + (index * sizeof(uint32_t))
                memcpy(ibo_index, &index, sizeof(uint32_t))
        v_buffer.handle = batch_ptr.vertex_buffer
        v_buffer.c_set_data(vbo_ptr, vbo_size)
        i_buffer.handle = batch_ptr.index_buffer
        i_buffer.c_set_data(ibo_ptr, ibo_size)