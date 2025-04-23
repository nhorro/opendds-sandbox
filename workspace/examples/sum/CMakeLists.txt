cmake_minimum_required(VERSION 3.10)
project(OpenDDS_SumExample)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Validar que DDS_ROOT esté definido
if(NOT DEFINED ENV{DDS_ROOT})
  message(FATAL_ERROR "La variable de entorno DDS_ROOT no está definida")
endif()

if(NOT DEFINED ENV{ACE_ROOT})
  message(FATAL_ERROR "La variable de entorno ACE_ROOT no está definida")
endif()

if(NOT DEFINED ENV{TAO_ROOT})
  message(FATAL_ERROR "La variable de entorno TAO_ROOT no está definida")
endif()

# Incluir headers de OpenDDS y del IDL
include_directories(
  $ENV{DDS_ROOT}
  $ENV{DDS_ROOT}/dds
  $ENV{ACE_ROOT}         
  $ENV{TAO_ROOT}         
  ${CMAKE_CURRENT_SOURCE_DIR}/idl
)
# Rutas absolutas para los archivos fuente generados por opendds_idl y tao_idl
set(GENERATED_SOURCES  
  ${CMAKE_CURRENT_SOURCE_DIR}/idl/SumC.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/idl/SumS.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/idl/SumTypeSupportC.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/idl/SumTypeSupportImpl.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/idl/SumTypeSupportS.cpp
)

# Crear ejecutable del subscriber
add_executable(subscriber
    ${CMAKE_CURRENT_SOURCE_DIR}/src/subscriber.cpp
    ${GENERATED_SOURCES}
)

# Crear ejecutable del publisher
add_executable(publisher
    ${CMAKE_CURRENT_SOURCE_DIR}/src/publisher.cpp
    ${GENERATED_SOURCES}
)

# Vincular bibliotecas requeridas por OpenDDS
target_link_libraries(subscriber
  OpenDDS_Dcps
  ACE
)

target_link_libraries(publisher
  OpenDDS_Dcps
  ACE
)
