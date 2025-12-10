module copium.utils.string;

import core.stdc.stdlib : malloc, free;
import core.stdc.string : memcpy;

@nogc char* toCString(const(char)[] s) {
    char* c_str = cast(char*)malloc(s.length + 1); // allocate enough space for the string length plus the null terminator.
    if (c_str is null) {
        return null;
    }
    memcpy(c_str, s.ptr, s.length);
    c_str[s.length] = '\0'; // apply the terminator. this is needed because c doesnt do that automatically like d does.
    return c_str;
}