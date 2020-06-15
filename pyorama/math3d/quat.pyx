cdef class Quat:
    
    def __init__(self, float x=0.0, float y=0.0, float z=0.0, float w=0.0):
        Quat.c_set_data(&self.data, x, y, z, w)
    
    def __dealloc__(self):
        memset(&self.data, 0, sizeof(QuatC))
    
    def __getbuffer__(self, Py_buffer *buffer, int flags):
        buffer.buf = &self.data
        buffer.len = 4
        buffer.readonly = 0
        buffer.format = "f"
        buffer.ndim = 1
        buffer.shape = <Py_ssize_t *>&buffer.len
        buffer.strides = NULL
        buffer.suboffsets = NULL
        buffer.itemsize = sizeof(float)
        buffer.internal = NULL

    def __releasebuffer__(self, Py_buffer *buffer):
        pass

    """
    def __getitem__(self, size_t i):
        cdef size_t size = 4
        if i < 0 or i >= size:
            raise ValueError("invalid index")
        return (<float *>self.data)[i]
        
    def __setitem__(self, size_t i, float value):
        cdef size_t size = 4
        if i < 0 or i >= size:
            raise ValueError("invalid index")
        (<float *>self.data)[i] = value
    """
        
    property x:
        def __get__(self): return self.data.x
        def __set__(self, float new_x): self.data.x = new_x
    
    property y:
        def __get__(self): return self.data.y
        def __set__(self, float new_y): self.data.y = new_y
        
    property z:
        def __get__(self): return self.data.z
        def __set__(self, float new_z): self.data.z = new_z
        
    property w:
        def __get__(self): return self.data.w
        def __set__(self, float new_w): self.data.w = new_w
        
    @staticmethod
    def add(Quat out, Quat a, Quat b): pass

    @staticmethod
    def calculate_w(Quat out, Quat a): pass

    @staticmethod
    def conjugate(Quat out, Quat a): pass

    @staticmethod
    def copy(Quat out, Quat a): pass

    #@staticmethod
    #def float dot(Quat a, Quat b): pass

    #@staticmethod
    #def bint equals(Quat a, Quat b): pass

    @staticmethod
    def from_euler(Quat out, float x, float y, float z): pass

    @staticmethod
    def from_mat3(Quat out, Mat3 a): pass

    #@staticmethod
    #def float get_axis_angle(Vec3 out, Quat a): pass

    @staticmethod
    def identity(Quat out): pass

    @staticmethod
    def inv(Quat out, Quat a): pass

    #@staticmethod
    #def float length(Quat a): pass

    @staticmethod
    def lerp(Quat out, Quat a, Quat b, float t): pass

    @staticmethod
    def mul(Quat out, Quat a, Quat b): pass

    #@staticmethod
    #def bint nearly_equals(Quat a, Quat b, float epsilon=0.000001): pass

    @staticmethod
    def norm(Quat out, Quat a): pass

    @staticmethod
    def rotate_x(Quat out, Quat a, float radians): pass

    @staticmethod
    def rotate_y(Quat out, Quat a, float radians): pass

    @staticmethod
    def rotate_z(Quat out, Quat a, float radians): pass

    @staticmethod
    def rotation_to(Quat out, Vec3 a, Vec3 b): pass

    @staticmethod
    def scale_add(Quat out, Quat a, float scale=1.0, float add=0.0): pass

    @staticmethod
    def set_axes(Quat out, Vec3 view, Vec3 right, Vec3 up): pass

    @staticmethod
    def set_axis_angle(Quat out, Vec3 axis, float radians): pass

    @staticmethod
    def set_data(Quat out, float x=0.0, float y=0.0, float z=0.0, float w=0.0): pass

    @staticmethod
    def slerp(Quat out, Quat a, Quat b, float t): pass

    #@staticmethod
    #def float sqr_length(Quat a): pass
    
    @staticmethod
    cdef void c_add(QuatC *out, QuatC *a, QuatC *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            (<float *>out)[i] = (<float *>a)[i] + (<float *>b)[i]

    @staticmethod
    cdef void c_calculate_w(QuatC *out, QuatC *a) nogil:
        out.x = a.x
        out.y = a.y
        out.z = a.z
        out.w = c_math.sqrt(c_math.fabs(1.0 - a.x * a.x - a.y * a.y - a.z * a.z))

    @staticmethod
    cdef void c_conjugate(QuatC *out, QuatC *a) nogil:
        out.x = -a.x
        out.y = -a.y
        out.z = -a.z
        out.w = a.w

    @staticmethod
    cdef void c_copy(QuatC *out, QuatC *a) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            (<float *>out)[i] = (<float *>a)[i]

    @staticmethod
    cdef float c_dot(QuatC *a, QuatC *b) nogil:
        cdef float out = 0.0
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            out += (<float *>a)[i] * (<float *>b)[i]
        return out

    @staticmethod
    cdef bint c_equals(QuatC *a, QuatC *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            if (<float *>a)[i] != (<float *>b)[i]:
                return False
        return True

    @staticmethod
    cdef void c_from_euler(QuatC *out, float x, float y, float z) nogil:
        cdef float half_to_rad = 0.5 * c_math.M_PI / 180.0
        x *= half_to_rad
        y *= half_to_rad
        z *= half_to_rad
        cdef float sx = c_math.sin(x)
        cdef float cx = c_math.cos(x)
        cdef float sy = c_math.sin(y)
        cdef float cy = c_math.cos(y)
        cdef float sz = c_math.sin(z)
        cdef float cz = c_math.cos(z)
        out.x = sx * cy * cz - cx * sy * sz
        out.y = cx * sy * cz + sx * cy * sz
        out.z = cx * cy * sz - sx * sy * cz
        out.w = cx * cy * cz + sx * sy * sz

    @staticmethod
    cdef void c_from_mat3(QuatC *out, Mat3C *a) nogil:
        cdef float f_trace = a.m00 + a.m11 + a.m22
        cdef float f_root
        cdef int i, j, k
        
        if f_trace > 0.0:
            f_root = c_math.sqrt(f_trace + 1.0)
            out.w = 0.5 * f_root
            f_root = 0.5/f_root
            out.x = (a.m12 - a.m21) * f_root
            out.y = (a.m20 - a.m02) * f_root
            out.z = (a.m01 - a.m10) * f_root
        else:
            i = 0
            if a.m11 > a.m00: i = 1
            if a.m22 > (<float *>a)[i*3+i]: i = 2
            j = (i + 1) % 3
            k = (i + 2) % 3
            f_root = c_math.sqrt((<float *>a)[i*3+i]-(<float *>a)[j*3+j]-(<float *>a)[k*3+k] + 1.0)
            (<float *>out)[i] = 0.5 * f_root
            f_root = 0.5 / f_root
            (<float *>out)[3] = ((<float *>a)[j*3+k] - (<float *>a)[k*3+j]) * f_root
            (<float *>out)[j] = ((<float *>a)[j*3+i] + (<float *>a)[i*3+j]) * f_root
            (<float *>out)[k] = ((<float *>a)[k*3+i] + (<float *>a)[i*3+k]) * f_root

    @staticmethod
    cdef float c_get_axis_angle(Vec3C *out, QuatC *a) nogil:
        cdef float rad = c_math.acos(a.w) * 2.0
        cdef float s = c_math.sin(rad/2.0)
        if not s:
            out.x = a.x / s
            out.y = a.y / s
            out.z = a.z / s
        else:
            out.x = 1
            out.y = 0
            out.z = 0
        return rad

    @staticmethod
    cdef void c_identity(QuatC *out) nogil:
        out.x = 0
        out.y = 0
        out.z = 0
        out.w = 1

    @staticmethod
    cdef void c_inv(QuatC *out, QuatC *a) nogil:
        cdef float dot = a.x*a.x + a.y*a.y + a.z*a.z + a.w*a.w
        cdef float inv_dot = 1.0/dot if dot else 0
        out.x = -a.x*inv_dot
        out.y = -a.y*inv_dot
        out.z = -a.z*inv_dot
        out.w = a.w*inv_dot

    @staticmethod
    cdef float c_length(QuatC *a) nogil:
        cdef float out = c_math.sqrt(Quat.c_sqr_length(a))
        return out

    @staticmethod
    cdef void c_lerp(QuatC *out, QuatC *a, QuatC *b, float t) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            (<float *>out)[i] = (<float *>a)[i] + t * ((<float *>b)[i] - (<float *>a)[i])

    @staticmethod
    cdef void c_mul(QuatC *out, QuatC *a, QuatC *b) nogil:        
        out.x = a.x * b.w + a.w * b.x + a.y * b.z - a.z * b.y
        out.y = a.y * b.w + a.w * b.y + a.z * b.x - a.x * b.z
        out.z = a.z * b.w + a.w * b.z + a.x * b.y - a.y * b.x
        out.w = a.w * b.w - a.x * b.x - a.y * b.y - a.z * b.z

    @staticmethod
    cdef bint c_nearly_equals(QuatC *a, QuatC *b, float epsilon=0.000001) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            if c_math.fabs((<float *>a)[i] - (<float *>b)[i]) > epsilon * max(1.0, c_math.fabs((<float *>a)[i]), c_math.fabs((<float *>b)[i])):
                return False
        return True

    @staticmethod
    cdef void c_norm(QuatC *out, QuatC *a) nogil:
        cdef float mag = Quat.c_length(a)
        Quat.c_scale_add(out, a, scale=1.0/mag)

    @staticmethod
    cdef void c_rotate_x(QuatC *out, QuatC *a, float radians) nogil:
        cdef float rad = radians * 0.5
        cdef float s = c_math.sin(rad)
        cdef float c = c_math.cos(rad)
        out.x = a.x * c + a.w * s
        out.y = a.y * c + a.z * s
        out.z = a.z * c - a.y * s
        out.w = a.w * c - a.x * s

    @staticmethod
    cdef void c_rotate_y(QuatC *out, QuatC *a, float radians) nogil:
        cdef float rad = radians * 0.5
        cdef float s = c_math.sin(rad)
        cdef float c = c_math.cos(rad)
        out.x = a.x * c - a.z * s
        out.y = a.y * c + a.w * s
        out.z = a.z * c + a.x * s
        out.w = a.w * c - a.y * s

    @staticmethod
    cdef void c_rotate_z(QuatC *out, QuatC *a, float radians) nogil:
        cdef float rad = radians * 0.5
        cdef float s = c_math.sin(rad)
        cdef float c = c_math.cos(rad)
        out.x = a.x * c + a.y * s
        out.y = a.y * c - a.x * s
        out.z = a.z * c + a.w * s
        out.w = a.w * c - a.z * s

    @staticmethod
    cdef void c_rotation_to(QuatC *out, Vec3C *a, Vec3C *b) nogil:
        cdef Vec3C temp
        cdef Vec3C x_unit = [1, 0, 0]
        cdef Vec3C y_unit = [0, 1, 0]
        cdef float dot
        
        dot = Vec3.c_dot(a, b)
        if dot < -0.999999:
            Vec3.c_cross(&temp, &x_unit, a)
            if Vec3.c_length(&temp) < 0.000001:
                Vec3.c_cross(&temp, &y_unit, a)
            Vec3.c_norm(&temp, &temp)
            Quat.c_set_axis_angle(out, &temp, c_math.M_PI)
        elif dot > 0.999999:
            out[0] = [0, 0, 0, 1]
        else:
            Vec3.c_cross(&temp, a, b)
            out[0] = [temp.x, temp.y, temp.z, 1 + dot]
            Quat.c_norm(out, out)

    @staticmethod
    cdef void c_scale_add(QuatC *out, QuatC *a, float scale=1.0, float add=0.0) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            (<float *>out)[i] = scale * (<float *>a)[i] + add

    @staticmethod
    cdef void c_set_axes(QuatC *out, Vec3C *view, Vec3C *right, Vec3C *up) nogil:
        cdef Mat3C m = [
            right.x, up.x, -view.x,
            right.y, up.y, -view.y,
            right.z, up.z, -view.z,
        ]
        Quat.c_from_mat3(out, &m)
        Quat.c_norm(out, out)

    @staticmethod
    cdef void c_set_axis_angle(QuatC *out, Vec3C *axis, float radians) nogil:
        cdef float rad = radians * 0.5
        cdef float c = c_math.cos(rad)
        cdef float s = c_math.sin(rad)
        out.x = s * axis.x
        out.y = s * axis.y
        out.z = s * axis.z
        out.w = c

    @staticmethod
    cdef void c_set_data(QuatC *out, float x=0.0, float y=0.0, float z=0.0, float w=0.0) nogil:
        out.x = x
        out.y = y
        out.z = z
        out.w = w
    
    @staticmethod
    cdef void c_slerp(QuatC *out, QuatC *a, QuatC *b, float t) nogil:
        cdef float ax = a.x
        cdef float ay = a.y
        cdef float az = a.z
        cdef float aw = a.w
        cdef float bx = b.x
        cdef float by = b.y
        cdef float bz = b.z
        cdef float bw = b.w
        cdef float omega, cosom, sinom, scale0, scale1
        
        cosom = ax * bx + ay * by + az * bz + aw * bw
        if cosom < 0.0:
            cosom = -cosom
            bx = -bx
            by = -by
            bz = -bz
            bw = -bw
        if (1.0 - cosom) > 0.000001:
            omega  = c_math.acos(cosom)
            sinom  = c_math.sin(omega)
            scale0 = c_math.sin((1.0 - t) * omega) / sinom
            scale1 = c_math.sin(t * omega) / sinom
        else:
            scale0 = 1.0 - t
            scale1 = t
        out.x = scale0 * ax + scale1 * bx
        out.y = scale0 * ay + scale1 * by
        out.z = scale0 * az + scale1 * bz
        out.w = scale0 * aw + scale1 * bw

    @staticmethod
    cdef float c_sqr_length(QuatC *a) nogil:
        """
        cdef float out = 0.0
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            (<float *>out)[i] += (<float *>a)[i] * (<float *>a)[i]
        return out
        """
        cdef float out = 0.0
        out += a.x * a.x
        out += a.y * a.y
        out += a.z * a.z
        out += a.w * a.w
        return out