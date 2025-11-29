module copium.utils.array;

import core.stdc.stdlib;
import core.memory;
import std.typecons : Nullable;

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
            this.length = 0;
            this.capacity = 0;
        }
    }

    @nogc bool append(T value)
    {
        if (this.length == capacity)
        {
            // Standard practice is to double capacity
            size_t newCapacity = capacity == 0 ? 4 : capacity * 2;

            if((ptr = cast(T*) realloc(ptr, newCapacity * T.sizeof)) !is null)
            {
                return false;
            }
            
            capacity = newCapacity;
        }
        ptr[this.length] = value;
        this.length++;
        return true;
    }

    @nogc T opIndex(size_t index) const
    {
        if(checkRange(index))
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
