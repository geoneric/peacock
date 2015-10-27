if((${host_system_name} STREQUAL "windows") AND
        (${target_system_name} STREQUAL "windows") AND
        (${peacock_compiler_id} STREQUAL "mingw"))

    if(${target_architecture} STREQUAL "x86_32")
        set(ml ml)
    elseif(${target_architecture} STREQUAL "x86_64")
        set(ml ml64)
    endif()

    find_program(ml_program ${ml})

    if(NOT ml_program)
        message(WARNING
            "peacock: ${ml} is required for building Boost.Context,\n"
            "peacock: but it could not be found\n"
            "peacock: Boost.Context and dependent projects will be skipped")
        set(peacock_ml_found FALSE)
    else()
        set(peacock_ml_found TRUE)
    endif()
endif()
