if(${target_system_name} STREQUAL "windows")
    set(qt_make_spec win32-g++)
    set(configure_arguments
        -debug-and-release
    )
else()
    if(${target_architecture} STREQUAL "x86_32")
        set(qt_address_model "32")
    else()
        set(qt_address_model "64")
    endif()
    set(qt_make_spec linux-g++-${qt_address_model})
    set(configure_arguments
        -release
        -prefix ${qt_prefix}
    )
endif()


# if cross compiling:
# -xplatform ...
# See README file for list of supported OS' and compilers.

# Cross compile example for i686-w64-mingw32-g++: 
#   configure -xplatform win32-g++ -device-option CROSS_COMPILE=i686-w64-mingw32-
#
