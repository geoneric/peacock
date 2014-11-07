if((${host_system_name} STREQUAL "windows") AND
        (${target_system_name} STREQUAL "windows") AND
        (${compiler_id} STREQUAL "mingw") AND
        (${target_architecture} STREQUAL "x86_64"))
    find_program(ml64 ml64)

    if(NOT ml64)
        MESSAGE(SEND_ERROR
            "peacock: ml64 is required for building Boost.Context,\n"
            "peacock: but it could not be found\n"
            "peacock: Add its location to PATH")
    endif()
endif()
