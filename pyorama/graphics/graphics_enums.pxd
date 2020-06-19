ctypedef enum RendererItemType:
    RENDERER_ITEM_TYPE_WINDOW
    RENDERER_ITEM_TYPE_VERTEX_FORMAT
    RENDERER_ITEM_TYPE_VERTEX_BUFFER
    RENDERER_ITEM_TYPE_INDEX_BUFFER
    RENDERER_ITEM_TYPE_UNIFORM_FORMAT
    RENDERER_ITEM_TYPE_UNIFORM
    RENDERER_ITEM_TYPE_SHADER
    RENDERER_ITEM_TYPE_PROGRAM
    RENDERER_ITEM_TYPE_IMAGE
    RENDERER_ITEM_TYPE_TEXTURE
    RENDERER_ITEM_TYPE_FRAME_BUFFER
    RENDERER_ITEM_TYPE_VIEW

"""
ctypedef enum DepthTest:
    DEPTH_TEST_NONE
    DEPTH_TEST_NEVER
    DEPTH_TEST_LESS
    DEPTH_TEST_EQUAL
    DEPTH_TEST_LEQUAL
    DEPTH_TEST_GREATER
    DEPTH_TEST_NOTEQUAL
    DEPTH_TEST_GEQUAL
    DEPTH_TEST_ALWAYS

ctypedef struct RenderRectC:
    uint16_t x
    uint16_t y
    uint16_t w
    uint16_t h

ctypedef enum DrawMode:
    DRAW_MODE_TRIANGLE
    DRAW_MODE_POINT
    DRAW_MODE_LINE
    DRAW_MODE_LINE_STRIP
    DRAW_MODE_LINE_LOOP
    DRAW_MODE_TRIANGLE_STRIP
    DRAW_MODE_TRIANGLE_FAN
"""

cpdef enum BufferUsage:
    BUFFER_USAGE_STATIC
    BUFFER_USAGE_DYNAMIC
    BUFFER_USAGE_STREAM

cpdef enum VertexCompType:
    VERTEX_COMP_TYPE_F32
    VERTEX_COMP_TYPE_I8
    VERTEX_COMP_TYPE_U8
    VERTEX_COMP_TYPE_I16
    VERTEX_COMP_TYPE_U16

cpdef enum IndexFormat:
    INDEX_FORMAT_U8
    INDEX_FORMAT_U16
    INDEX_FORMAT_U32

cpdef enum ShaderType:
    SHADER_TYPE_VERTEX
    SHADER_TYPE_FRAGMENT

cpdef enum UniformType:
    UNIFORM_TYPE_INT
    UNIFORM_TYPE_FLOAT
    UNIFORM_TYPE_VEC2
    UNIFORM_TYPE_VEC3
    UNIFORM_TYPE_VEC4
    UNIFORM_TYPE_MAT2
    UNIFORM_TYPE_MAT3
    UNIFORM_TYPE_MAT4

cpdef enum AttributeType:
    ATTRIBUTE_TYPE_INT
    ATTRIBUTE_TYPE_FLOAT
    ATTRIBUTE_TYPE_VEC2
    ATTRIBUTE_TYPE_VEC3
    ATTRIBUTE_TYPE_VEC4
    ATTRIBUTE_TYPE_MAT2
    ATTRIBUTE_TYPE_MAT3
    ATTRIBUTE_TYPE_MAT4

cpdef enum:
    PROGRAM_MAX_ATTRIBUTES = 16
    PROGRAM_MAX_UNIFORMS = 16

cpdef enum TextureFilter:
    TEXTURE_FILTER_NEAREST
    TEXTURE_FILTER_LINEAR

cpdef enum TextureWrap:
    TEXTURE_WRAP_REPEAT
    TEXTURE_WRAP_MIRRORED_REPEAT
    TEXTURE_WRAP_CLAMP_TO_EDGE

cpdef enum TextureUnit:
    TEXTURE_UNIT_0
    TEXTURE_UNIT_1
    TEXTURE_UNIT_2
    TEXTURE_UNIT_3
    TEXTURE_UNIT_4
    TEXTURE_UNIT_5
    TEXTURE_UNIT_6
    TEXTURE_UNIT_7
    TEXTURE_UNIT_8
    TEXTURE_UNIT_9
    TEXTURE_UNIT_10
    TEXTURE_UNIT_11
    TEXTURE_UNIT_12
    TEXTURE_UNIT_13
    TEXTURE_UNIT_14
    TEXTURE_UNIT_15

cpdef enum:
    MAX_TEXTURE_UNITS = 16

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

cpdef enum ViewClear:
    VIEW_CLEAR_COLOR = (1 << 0)
    VIEW_CLEAR_DEPTH = (1 << 1)
    VIEW_CLEAR_STENCIL = (1 << 2)