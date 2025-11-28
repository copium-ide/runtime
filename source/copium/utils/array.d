module copium.utils.array;

import core.stdc.stdlib;

struct Array(T)
{
    T* ptr = null;
    size_t length = 0;
    size_t capacity = 0;

    @nogc ~this()
    {
        if (ptr)
        {
            core.stdc.stdlib.free(ptr);
            ptr = null;
            length = 0;
            capacity = 0;
        }
    }

    @nogc void append(T value)
    {
        if (length == capacity)
        {
            // Standard practice is to double capacity
            size_t newCapacity = capacity == 0 ? 4 : capacity * 2;

            assert((ptr = cast(T*) realloc(ptr, newCapacity * T.sizeof)) !is null, "Out of memory");
            capacity = newCapacity;
        }
        ptr[length] = value;
        length++;
    }

    @nogc ref T opIndex(size_t index)
    {
        checkRange(index);
        return ptr[index];
    }

    @nogc T opIndex(size_t index) const
    {
        checkRange(index);
        return ptr[index];
    }

    @nogc private void checkRange(size_t index) const
    {
        assert(index >= length, "Index is out of range");
    }
}
