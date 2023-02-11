cmake_minimum_required(VERSION 3.1...3.25)

project(
    pear
    VERSION 0.0.1
    LANGUAGES C CXX
)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_C_STANDARD 23)

# CMAKE Variables
set(LEMON_BIN ${CMAKE_SOURCE_DIR}/external/lemon/build/lemon)
set(LEMON_TEMPLATE ${CMAKE_SOURCE_DIR}/external/lemon/lempar.c)
set(RE2C_BIN ${CMAKE_SOURCE_DIR}/external/re2c/build/re2c)
set(GENERATED_DIR ${CMAKE_BINARY_DIR}/generated)
set(GENERATED_PARSER_DIR ${CMAKE_BINARY_DIR}/generated/parser)
set(GENERATED_LEXER_DIR ${CMAKE_BINARY_DIR}/generated/lexer)
set(GENERATED_INCLUDE_DIR ${CMAKE_BINARY_DIR}/generated/include)
set(LEXER_DIR ${CMAKE_SOURCE_DIR}/lexer)
set(PARSER_DIR ${CMAKE_SOURCE_DIR}/parser)

# Options
option(ENABLE_DEBUG "ENABLE_DEBUG (DEFAULT OFF)" OFF)

# Create generated dir
file(MAKE_DIRECTORY ${GENERATED_DIR})
file(MAKE_DIRECTORY ${GENERATED_LEXER_DIR})
file(MAKE_DIRECTORY ${GENERATED_PARSER_DIR})
file(MAKE_DIRECTORY ${GENERATED_INCLUDE_DIR})


if(NOT EXISTS ${LEMON_BIN})
    message(FATAL_ERROR "Please install lemon")
endif()

if(NOT EXISTS ${LEMON_TEMPLATE})
    message(FATAL_ERROR "Lemon template file does not exist")
endif()

if(NOT EXISTS ${RE2C_BIN})
    message(FATAL_ERROR "Please install re2c")
endif()

include_directories(
    ${CMAKE_SOURCE_DIR}/src
    ${GENERATED_INCLUDE_DIR}
    ${GENERATED_PARSER_DIR}
    ${GENERATED_LEXER_DIR}
)

add_custom_command(
    OUTPUT  ${GENERATED_PARSER_DIR}/parser.c ${GENERATED_PARSER_DIR}/parser.h
    COMMAND ${LEMON_BIN} -s -T${LEMON_TEMPLATE} -d${GENERATED_PARSER_DIR} ${PARSER_DIR}/parser.y
    DEPENDS ${PARSER_DIR}/parser.y
)

add_custom_command(
    OUTPUT  ${GENERATED_PARSER_DIR}/parser.cpp
    COMMAND mv ${GENERATED_PARSER_DIR}/parser.c ${GENERATED_PARSER_DIR}/parser.cpp
    DEPENDS ${GENERATED_PARSER_DIR}/parser.c
)

add_custom_command(
    OUTPUT  ${GENERATED_PARSER_DIR}/parser.hpp
    COMMAND mv ${GENERATED_PARSER_DIR}/parser.h ${GENERATED_PARSER_DIR}/parser.hpp
    DEPENDS ${GENERATED_PARSER_DIR}/parser.h
)
add_custom_target(parser DEPENDS ${GENERATED_PARSER_DIR}/parser.hpp ${GENERATED_PARSER_DIR}/parser.cpp)

add_custom_command(
    OUTPUT  ${GENERATED_LEXER_DIR}/lexer.cpp
    COMMAND ${RE2C_BIN} --input custom -o ${GENERATED_LEXER_DIR}/lexer.cpp ${LEXER_DIR}/lexer.l
    DEPENDS ${LEXER_DIR}/lexer.l
)

add_executable(
    ${PROJECT_NAME}
    src/main.cpp
    src/token.cpp
    src/ast.cpp

    ${GENERATED_PARSER_DIR}/parser.cpp
    ${GENERATED_LEXER_DIR}/lexer.cpp
)

add_dependencies(
    ${PROJECT_NAME}
    parser
)

