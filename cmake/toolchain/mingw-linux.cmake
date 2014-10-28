# http://www.cmake.org/Wiki/CmakeMingw

# The name of the target operating system.
set(CMAKE_SYSTEM_NAME Windows)

# Which compilers to use for C and C++.
set(CMAKE_C_COMPILER $ENV{CC})
set(CMAKE_CXX_COMPILER $ENV{CXX})

string(FIND $ENV{CC} "gcc" base_id)
string(SUBSTRING $ENV{CC} 0 ${base_id} base)

set(CMAKE_RC_COMPILER "${base}windres")

# Here is the target environment located.
set(CMAKE_FIND_ROOT_PATH /usr)

# Adjust the default behaviour of the FIND_XXX() commands:
# Search headers and libraries in the target environment, search
# programs in the host environment.
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
