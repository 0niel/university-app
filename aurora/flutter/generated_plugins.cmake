#
# Generated file, do not edit.
#
set(ROOT_PROJECT_BINARY_DIR "${PROJECT_BINARY_DIR}")

function(add_library TARGET)
    _add_library(${TARGET} ${ARGN})

    if (
      FALSE
    )
      add_custom_command(TARGET ${TARGET} POST_BUILD
                        COMMAND ${CMAKE_COMMAND} -E copy
                        "$<TARGET_FILE:${TARGET}>"
                        "${ROOT_PROJECT_BINARY_DIR}/bundle/lib/$<TARGET_FILE_NAME:${TARGET}>")
    endif()
endfunction()

list(APPEND FLUTTER_PLATFORM_PLUGIN_LIST
)

list(APPEND FLUTTER_FFI_PLUGIN_LIST
)

foreach(PLUGIN ${FLUTTER_PLATFORM_PLUGIN_LIST})
    add_subdirectory(flutter/ephemeral/.plugin_symlinks/${PLUGIN}/aurora plugins/${PLUGIN})
    target_link_libraries(${BINARY_NAME} PRIVATE ${PLUGIN}_platform_plugin)
endforeach(PLUGIN)

foreach(FFI_PLUGIN ${FLUTTER_FFI_PLUGIN_LIST})
    add_subdirectory(flutter/ephemeral/.plugin_symlinks/${FFI_PLUGIN}/aurora plugins/${FFI_PLUGIN})
endforeach(FFI_PLUGIN)
