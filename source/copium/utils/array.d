module copium.utils.array;

import core.stdc.stdlib;
import core.memory;
import std.typecons : Nullable;

struct Array(T)
{
    T* ptr = null;
    size_t length = 0;
    size_t capacity = 0;

    @disable this(this);  // ✅ Prevent copying
    
    @nogc ~this()
    {
        if (ptr)
        {
            core.stdc.stdlib.free(ptr);
            ptr = null;
            this.length = 0;
            this.capacity = 0;
        }
    }
    
    @nogc bool append(T value)
    {
        if (this.length == capacity)
        {
            size_t newCapacity = capacity == 0 ? 4 : capacity * 2;
            T* newPtr = cast(T*) realloc(ptr, newCapacity * T.sizeof);
            if (newPtr is null)
            {
                return false;
            }
            ptr = newPtr;
            capacity = newCapacity;
        }
        ptr[this.length] = value;
        this.length++;
        return true;
    }

    @nogc auto reduce(string operation)()
    {
        if (this.length == 0)
        {
            return T.init;
        }

        T result = ptr[0];

        static if (operation == "|")
        {
            for (size_t i = 1; i < this.length; i++)
            {
                result |= ptr[i];
            }
        }
        else static if (operation == "&")
        {
            for (size_t i = 1; i < this.length; i++)
            {
                result &= ptr[i];
            }
        }
        else static if (operation == "^")
        {
            for (size_t i = 1; i < this.length; i++)
            {
                result ^= ptr[i];
            }
        }
        else static if (operation == "+")
        {
            for (size_t i = 1; i < this.length; i++)
            {
                result += ptr[i];
            }
        }
        else static if (operation == "*")
        {
            for (size_t i = 1; i < this.length; i++)
            {
                result *= ptr[i];
            }
        }
        else
        {
            static assert(false, "Unsupported operation: " ~ operation);
        }

        return result;
    }

    @nogc T opIndex(size_t index) const
    {
        if (checkRange(index))
        {
            return ptr[index];
        }
        else
        {
            return typeof(return).init;
        }

    }

    @nogc private bool checkRange(size_t index) const
    {
        if (index >= this.length)
        {
            return false;
        }
        else
        {
            return true;
        }
    }
}
