add_executable(cimaging_app_sample cimaging_app_sample.cpp)
target_link_libraries(cimaging_app_sample PRIVATE CImaging::app)

install(
    TARGETS cimaging_app_sample
    RUNTIME DESTINATION ${PROJECT_NAME}/bin)
