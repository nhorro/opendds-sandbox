# OpenDDS Docker Development Environment (Ubuntu 20.04 + CORBA)

Entorno para experimentar con OpenDDS, incluyendo sus dependencias ACE y TAO (CORBA), en una configuración compatible con sistemas legacy que utilizan `DCPSInfoRepo`, `tao_cosnaming` e IORs. Basado en Ubuntu 20.04. Se compila directamente desde el código fuente oficial.

## Contenido

- [OpenDDS 3.13.2](https://github.com/OpenDDS/OpenDDS/tree/DDS-3.13.2).
- Instalación de ACE/TAO como submódulo (dentro de `ACE_wrappers`)
- Herramientas disponibles: `opendds_idl`, `tao_idl`, `DCPSInfoRepo`, `tao_cosnaming`, etc.
- Variables de entorno configuradas automáticamente.

## Uso básico

### 1. Iniciar el contenedor en modo interactivo

```bash
./run.sh
```

Esto monta la carpeta `./app` como directorio de trabajo dentro del contenedor. El contenedor no persiste: se elimina al salir.

### 2. Compilar un archivo `.idl`

```bash
cd /app

# Paso 1: generar archivos DDS desde el IDL
opendds_idl Sum.idl

# Paso 2: generar archivos CORBA desde TypeSupport
tao_idl SumTypeSupport.idl
```

## Estructura de instalación

A continuación se describen los directorios principales y su función:

| Ruta                                | Contenido                                                  |
|-------------------------------------|-------------------------------------------------------------|
| `/opt/OpenDDS`                      | Código fuente y herramientas de OpenDDS                    |
| `/opt/OpenDDS/bin`                  | Ejecutables como `opendds_idl`, `DCPSInfoRepo`, etc.       |
| `/opt/OpenDDS/lib`                  | Bibliotecas de OpenDDS                                     |
| `/opt/OpenDDS/ACE_wrappers`        | Submódulo con ACE y TAO                                    |
| `/opt/OpenDDS/ACE_wrappers/lib`    | Bibliotecas como `libACE.so`, `libTAO_*.so`, etc.          |
| `/opt/OpenDDS/ACE_wrappers/TAO`    | Código fuente de TAO                                       |
| `/opt/OpenDDS/ACE_wrappers/TAO/TAO_IDL` | Librerías específicas para el compilador IDL de TAO   |

## Variables de entorno relevantes

Estas variables están configuradas automáticamente al construir la imagen Docker:

```bash
export DDS_ROOT=/opt/OpenDDS
export ACE_ROOT=/opt/OpenDDS/ACE_wrappers
export TAO_ROOT=$ACE_ROOT/TAO
export PATH=$DDS_ROOT/bin:$PATH
export LD_LIBRARY_PATH=$DDS_ROOT/lib:$ACE_ROOT/lib:$TAO_ROOT/TAO_IDL:$LD_LIBRARY_PATH
```

Estas rutas permiten la ejecución de herramientas y aplicaciones sin instalación adicional en el sistema.

## Herramientas disponibles

| Comando         | Función                                                  |
|-----------------|----------------------------------------------------------|
| `opendds_idl`   | Genera código DDS (TypeSupport, C++ stub/skeleton)       |
| `tao_idl`       | Genera código CORBA tradicional                          |
| `DCPSInfoRepo`  | Servicio de descubrimiento centralizado de OpenDDS       |
| `tao_cosnaming` | Naming Service CORBA                                     |


## Notas sobre distribución

Para generar una distribución portable de una aplicación basada en OpenDDS, se requiere incluir:

1. Ejecutable(s) de la aplicación (`publisher`, `subscriber`, etc.)
2. Bibliotecas compartidas necesarias (`libOpenDDS_*.so`, `libACE.so`, `libTAO_*.so`)
3. Variables de entorno adecuadas (`LD_LIBRARY_PATH`)
4. Archivos de configuración si se utiliza `DCPSInfoRepo` o `RTPS`

Se recomienda construir contenedores dedicados o empaquetar usando herramientas como AppImage o CPack para evitar conflictos de dependencias en sistemas destino.


## Recursos adicionales

- [OpenDDS GitHub](https://github.com/OpenDDS/OpenDDS)
- [Documentación oficial](https://opendds.readthedocs.io/)
- [TAO y ACE](https://www.dre.vanderbilt.edu/~schmidt/TAO.html)
