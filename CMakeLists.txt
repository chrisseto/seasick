cmake_minimum_required (VERSION 3.14)

project(seasick)

find_package (Seastar REQUIRED)

add_executable (seasick main.cc)

target_link_libraries (seasick PRIVATE Seastar::seastar)

install(TARGETS seasick DESTINATION bin)
