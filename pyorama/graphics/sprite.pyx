ctypedef SpriteC ItemTypeC
cdef uint8_t ITEM_TYPE = handle_create_item_type()
cdef size_t ITEM_SIZE = sizeof(ItemTypeC)

cdef class Sprite:
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

    cpdef void create(self, float width, float height) except *:
        cdef:
            SpriteC *sprite_ptr
            float[12] tex_coords

        tex_coords = [
            0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 
            0.0, 1.0, 1.0, 0.0, 1.0, 1.0,
        ]
        self.handle = self.manager.create(ITEM_TYPE)
        sprite_ptr = self.c_get_ptr()
        sprite_ptr.width = width
        sprite_ptr.height = height
        sprite_ptr.tex_coords = tex_coords
        sprite_ptr.position = Vec2C(0.0, 0.0)
        sprite_ptr.rotation = 0.0
        sprite_ptr.scale = Vec2C(1.0, 1.0)
        sprite_ptr.z_index = 0.0
        sprite_ptr.visible = True
        sprite_ptr.tint = Vec3C(1.0, 1.0, 1.0)
        sprite_ptr.alpha = 1.0

    cpdef void delete(self) except *:
        self.manager.delete(self.handle)
        self.handle = 0

    cpdef void set_tex_coords(self, float[::1] tex_coords) except *:
        cdef:
            SpriteC *sprite_ptr
            float *tex_coords_ptr

        if tex_coords.shape[0] != 12:
            raise ValueError("Sprite: tex coords array is invalid length")
        sprite_ptr = self.c_get_ptr()
        tex_coords_ptr = &tex_coords[0]
        memcpy(sprite_ptr.tex_coords, tex_coords_ptr, sizeof(float) * 12)

    cpdef void set_tex_coords_as_rect(self, Vec4 rect) except *:
        cdef:
            SpriteC *sprite_ptr
            float *tex_coords_ptr
            Vec4C *rect_ptr

        rect_ptr = &rect.data  
        sprite_ptr = self.c_get_ptr()
        sprite_ptr.tex_coords = [
            rect_ptr.x, rect_ptr.y,
            rect_ptr.z, rect_ptr.y,
            rect_ptr.x, rect_ptr.w,
            rect_ptr.x, rect_ptr.w,
            rect_ptr.z, rect_ptr.y,
            rect_ptr.z, rect_ptr.w,
        ]

    cpdef void set_position(self, Vec2 position) except *:
        self.c_get_ptr().position = position.data

    cpdef void set_anchor(self, Vec2 anchor) except *:
        self.c_get_ptr().anchor = anchor.data

    cpdef void set_rotation(self, float rotation) except *:
        self.c_get_ptr().rotation = rotation

    cpdef void set_scale(self, Vec2 scale) except *:
        self.c_get_ptr().scale = scale.data

    cpdef void set_z_index(self, float z_index) except *:
        self.c_get_ptr().z_index = z_index

    cpdef void set_visible(self, bint visible) except *:
        self.c_get_ptr().visible = visible

    cpdef void set_tint(self, Vec3 tint) except *:
        self.c_get_ptr().tint = tint.data

    cpdef void set_alpha(self, float alpha) except *:
        self.c_get_ptr().alpha = alpha

    cpdef float[::1] get_tex_coords(self) except *:
        cdef:
            float[::1] tex_coords
        tex_coords = <float[:12]>self.c_get_ptr().tex_coords
        return tex_coords

    cpdef Vec4 get_tex_coords_as_rect(self):
        cdef:
            Vec4 rect
            SpriteC *sprite_ptr
        
        sprite_ptr = self.c_get_ptr()
        rect = Vec4(
            sprite_ptr.tex_coords[0],
            sprite_ptr.tex_coords[1],
            sprite_ptr.tex_coords[2],
            sprite_ptr.tex_coords[5],
        )
        return rect

    cpdef Vec2 get_position(self):
        cdef:
            Vec2 position = Vec2()
        position.data = self.c_get_ptr().position
        return position

    cpdef Vec2 get_anchor(self):
        cdef:
            Vec2 anchor = Vec2()
        anchor.data = self.c_get_ptr().anchor
        return anchor

    cpdef float get_rotation(self) except *:
        return self.c_get_ptr().rotation

    cpdef Vec2 get_scale(self):
        cdef:
            Vec2 scale = Vec2()
        scale.data = self.c_get_ptr().scale
        return scale

    cpdef float get_z_index(self) except *:
        return self.c_get_ptr().z_index

    cpdef bint get_visible(self) except *:
        return self.c_get_ptr().visible

    cpdef Vec3 get_tint(self):
        cdef:
            Vec3 tint = Vec3()
        tint.data = self.c_get_ptr().tint
        return tint

    cpdef float get_alpha(self) except *:
        return self.c_get_ptr().alpha