from cython cimport view
from cpython.buffer cimport *
from pyorama.core.error cimport *
from pyorama.libs.c cimport *

ctypedef struct ItemArrayC:
    char *items
    size_t max_items
    size_t item_size

cdef class ItemArray:

    @staticmethod
    cdef Error c_init(ItemArrayC *self, size_t item_size, size_t max_items) nogil

    @staticmethod
    cdef void c_free(ItemArrayC *self) nogil

    @staticmethod
    cdef void c_get_ptr(ItemArrayC *self, size_t index, void **item_ptr) nogil

    @staticmethod
    cdef void c_get(ItemArrayC *self, size_t index, void *item) nogil

    @staticmethod
    cdef void c_set(ItemArrayC *self, size_t index, void *item) nogil

    @staticmethod
    cdef void c_clear(ItemArrayC *self, size_t index) nogil

    @staticmethod
    cdef void c_clear_all(ItemArrayC *self) nogil

    @staticmethod
    cdef void c_swap(ItemArrayC *self, size_t a, size_t b) nogil