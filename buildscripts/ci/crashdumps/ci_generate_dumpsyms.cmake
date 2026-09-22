message(STATUS "Generate dump symbols")

set(HERE ${CMAKE_CURRENT_LIST_DIR})

set(GEN_SCRIPT "${HERE}/generate_syms.cmake")
set(ARTIFACTS_DIR "${CMAKE_SOURCE_DIR}/build.artifacts")
set(SYMBOLS_DIR ${ARTIFACTS_DIR}/symbols)

# Options
set(APP_BIN "" CACHE STRING "Path to app binary")
set(APP_DSYM "" CACHE STRING "Path to the dSYM bundle of the app binary (macOS)")
set(ARCH "" CACHE STRING "System architecture")
set(GENERATE_ARCHS "" CACHE STRING "Generate symbols for architectures")
set(BUILD_DIR "${CMAKE_SOURCE_DIR}/build.release" CACHE STRING "Path to build directory")

if(WIN32)
    file(ARCHIVE_EXTRACT INPUT "${HERE}/win/dump_syms.7z" DESTINATION "${HERE}/win/")
    set(DUMPSYMS_BIN "${HERE}/win/dump_syms.exe")
elseif(LINUX)
    file(ARCHIVE_EXTRACT INPUT "${HERE}/linux/${ARCH}/dump_syms.7z" DESTINATION "${HERE}/linux/")
    set(DUMPSYMS_BIN "${HERE}/linux/dump_syms")
    execute_process(COMMAND chmod +x ${DUMPSYMS_BIN})
elseif(APPLE)
    file(ARCHIVE_EXTRACT INPUT "${HERE}/macos/dump_syms.7z" DESTINATION "${HERE}/macos/")
    set(DUMPSYMS_BIN "${HERE}/macos/dump_syms")
endif()

set(CONFIG
    -DDUMPSYMS_BIN=${DUMPSYMS_BIN}
    -DBUILD_DIR=${BUILD_DIR}
    -DSYMBOLS_DIR=${SYMBOLS_DIR}
    -DAPP_BIN=${APP_BIN}
    -DAPP_DSYM=${APP_DSYM}
    -DGENERATE_ARCHS=${GENERATE_ARCHS}
)

execute_process(
    COMMAND cmake ${CONFIG} -P ${GEN_SCRIPT}
    RESULT_VARIABLE result
)

if(result)
    message(FATAL_ERROR "Failed to generate dump symbols, exit code: ${result}")
endif()

execute_process(
    COMMAND ls ${SYMBOLS_DIR} OUTPUT_VARIABLE symbols_dir_contents
)

message(STATUS "SYMBOLS_DIR contents: ${symbols_dir_contents}")

# A .sym without FUNC records holds only the symbol table: no file names, no
# line numbers. Prebuilt dependencies (Qt and friends) ship stripped and
# legitimately have none, so only the application module is checked.
get_filename_component(APP_MODULE "${APP_BIN}" NAME)
string(REGEX REPLACE "\\.pdb$" "" APP_MODULE "${APP_MODULE}")

file(GLOB APP_SYM_FILES "${SYMBOLS_DIR}/${APP_MODULE}/*/${APP_MODULE}.sym")

if(NOT APP_SYM_FILES)
    message(FATAL_ERROR "No symbol file generated for '${APP_MODULE}' in ${SYMBOLS_DIR}")
endif()

foreach(SYM_FILE IN LISTS APP_SYM_FILES)
    file(STRINGS "${SYM_FILE}" FUNC_RECORD REGEX "^FUNC " LIMIT_COUNT 1)
    if(NOT FUNC_RECORD)
        message(FATAL_ERROR
            "${SYM_FILE} has no FUNC records.\n"
            "The build has no debug info, or the symbols were generated from a stripped binary.")
    endif()
    message(STATUS "Checked ${SYM_FILE}")
endforeach()
