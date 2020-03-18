STM32F4xx cmake template
----

[![dimtass](https://circleci.com/gh/dimtass/stm32f4xx-cmake-template.svg?style=svg)](https://circleci.com/gh/dimtass/stm32f4xx-cmake-template)

This is a template cmake project for the stm32f4xx. So what's
so special about it? Well, it supports the following things:

* STM32 Standard Peripheral Library
* FreeRTOS

To select the which libraries you want to use you need to provide
cmake with the proper options. By default all the options are set
to `OFF`. The supported options are:

* `USE_STDPERIPH_DRIVER`: If set to `ON` enables the stdperiph library
* `USE_FREERTOS`: If set to `ON` enables FreeRTOS

You also need to provide cmake with the source folder by pointing
the folder to the `SRC` parameter. In this case those two parameters
are supported:
```sh
SRC=src_stdperiph
SCR=src_freertos
```

Finally, you also need to provide the path of the toolchain to
use in the `CMAKE_TOOLCHAIN`.

To enable the UART debug print (`TRACE()`) then you need to enable
the `USE_DBGUART` build flag. This will enable a UART port with the
following pinout with 115200 bps baudrate:

UART TX | UART RX
-|-
PA9 | PA10

For the debug uart, by default there's full support for printf, but
if you want a light-weight printf then you can enable the
`USE_TINY_PRINTF` build flag. This printf won't support uint32_t and
float.

Finally, you need to specify the MCU type using these parameters:
```sh
USE_LINKER_SCRIPT
USE_STARTUP_FILE
USE_DEVICE
```

The default values in the `build.sh` script are:
```sh
: ${USE_LINKER_SCRIPT:=STM32F411xE/STM32F411RETx_FLASH.ld}
: ${USE_STARTUP_FILE:=startup_stm32f411xe.s}
: ${USE_DEVICE:=STM32F411xE}
```

In order to find the supported devices you can run this command:
```sh
./list-supported-devices.sh
```

The linker files are located in `source/config/LinkerScripts/` and
the startup files in `source/libs/cmsis/startup/`. Just have in mind
that only for the linker script you also need to include the top folder
name (see the default `build.sh` script).

## Cloning the code
Because this repo has dependencies on other submodules, in order to
fetch the repo use the following command:

```sh
git clone --recursive -j8 https://dimtass@bitbucket.org/dimtass/stm32f4xx-cmake-template.git
```

## Examples
To use the `stdperiph` library example run this command:
```sh
CLEANBUILD=true USE_DBGUART=ON USE_STDPERIPH_DRIVER=ON SRC=src_stdperiph ./build.sh
```

To use the `freertos` example run this command:
```sh
CLEANBUILD=true USE_DBGUART=ON USE_STDPERIPH_DRIVER=ON USE_FREERTOS=ON SRC=src_freertos ./build.sh
```

## Using docker
Instead of setting up a build environment, then if you have docker you can
use my CDE image to build the code without much hassle. Just clone the code
like this:

```sh
docker run --rm -it -v $(pwd):/tmp -w=/tmp dimtass/stm32-cde-image:0.1 -c "CLEANBUILD=true USE_DBGUART=ON USE_STDPERIPH_DRIVER=ON SRC=src_stdperiph ./build.sh"
```

or

```sh
docker run --rm -it -v $(pwd):/tmp -w=/tmp dimtass/stm32-cde-image:0.1 -c "CLEANBUILD=true USE_DBGUART=ON USE_STDPERIPH_DRIVER=ON USE_FREERTOS=ON SRC=src_freertos ./build.sh"
```

## Flashing the firmware
To flash the firmware in Linux you need the texane/stlink tool.
Then you can use the flash script like this:

```sh
./flash.sh
```

Otherwise you can build the firmware and then use any programmer you like.
The elf, hex and bin firmwares are located in the `build-stm32` folder

```sh
./build-stm32/*/stm32f4xx-cmake-template.bin
./build-stm32/*/stm32f4xx-cmake-template.hex
./build-stm32/*/stm32f4xx-cmake-template.elf
```

To flash the HEX file in windows use st-link utility like this:
```"C:\Program Files (x86)\STMicroelectronics\STM32 ST-LINK Utility\ST-LINK Utility\ST-LINK_CLI.exe" -c SWD -p build-stm32\src_stdperiph\stm32f4xx-cmake-template.hex -Rst```

To flash the bin in Linux:
```st-flash --reset write build-stm32/src_stdperiph/stm32f4xx-cmake-template.bin 0x8000000```

## FW details
* `CMSIS version`: 5.0.4
* `StdPeriph Library version`: 1.8.0
* `STM3 USB Driver version`: 1.2.1
* `FreeRTOS`: v10.2.1


## Resources
The default MCU for this template is the `STM32F411CEU6`.
You can find more resources and tools for this MCU [here](https://www.st.com/en/microcontrollers-microprocessors/stm32f411ce.html)