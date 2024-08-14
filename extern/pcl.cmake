# Exports:
# ${PCL_INCLUDE_DIRS}
# ${PCL_LIB_DIR}
# ${PCL_LIBRARIES}

include(ExternalProject)

ExternalProject_Add(
    extern_pcl
    PREFIX pcl
    URL https://github.com/PointCloudLibrary/pcl/archive/refs/tags/pcl-1.14.1.tar.gz
    # URL_HASH SHA256=dc0ac26f094eafa7b26c3653838494cc0a012bd1bdc1f1b0dc79b16c2de0125a
    DOWNLOAD_DIR "${EXTERN_DOWNLOAD_DIR}/pcl"
    UPDATE_COMMAND ""
    CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
        -DCMAKE_BUILD_TYPE=Release
        -DWITH_VTK=OFF
        -DWITH_PCAP=OFF
        -DWITH_OPENGL=OFF
        -DEIGEN_INCLUDE_DIR=${EIGEN_INCLUDE_DIRS}
        -DBUILD_GPU=OFF
        -DBUILD_CUDA=OFF
        -DWITH_CUDA=OFF
        -DWITH_OPENNI=OFF
        -DBUILD_visualization=OFF
        -DBUILD_gpu_kinfu=OFF
        -DBUILD_gpu_kinfu_large_scale=OFF
        -DBUILD_gpu_kinfu_large_scale_to=OFF
        -DBUILD_gpu_kinfu_tools=OFF
    DEPENDS extern_eigen
)

# PCL system dependencies
find_package(Boost REQUIRED COMPONENTS
    system
    filesystem
    date_time
    iostreams
    serialization
    regex
)
find_package(Qhull REQUIRED)

ExternalProject_Get_Property(extern_pcl INSTALL_DIR)
set(PCL_INCLUDE_DIRS
    "${INSTALL_DIR}/include/pcl-1.14"
)
set(PCL_LIB_DIR
    "${INSTALL_DIR}/lib"
)
set(PCL_LIBRARIES
    pcl_common
    pcl_kdtree
    pcl_octree
    pcl_search
    pcl_sample_consensus
    pcl_filters
    pcl_io
    pcl_features
    pcl_ml
    pcl_segmentation
    #pcl_visualization
    pcl_surface
    pcl_registration
    pcl_keypoints
    pcl_tracking
    pcl_recognition
    pcl_stereo
    # pcl_apps
    # pcl_cuda_features
    # pcl_cuda_segmentation
    # pcl_cuda_sample_consensus
    # pcl_outofcore
    # pcl_gpu_containers
    # pcl_gpu_utils
    # pcl_gpu_octree
    # pcl_gpu_features
    # pcl_gpu_kinfu
    # pcl_gpu_kinfu_large_scale
    # pcl_gpu_segmentation
    # pcl_people
    optimized
    debug
    ${OPENNI_LIBRARIES}
    ${OPENNI2_LIBRARIES}
    QHULL::QHULL
)

add_library(ExternPCL INTERFACE)
add_dependencies(ExternPCL extern_pcl)
target_compile_definitions(ExternPCL INTERFACE
    -DDISABLE_PCAP
    -DDISABLE_PNG
)
target_include_directories(ExternPCL INTERFACE ${PCL_INCLUDE_DIRS})
target_link_directories(ExternPCL INTERFACE ${PCL_LIB_DIR})
target_link_libraries(ExternPCL INTERFACE
    ${PCL_LIBRARIES}
    Boost::system
    Boost::filesystem
    Boost::date_time
    Boost::iostreams
    Boost::serialization
    Boost::regex
)
