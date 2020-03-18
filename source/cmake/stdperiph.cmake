set(STDPERIPH_DIR ${CMAKE_SOURCE_DIR}/libs/STM32F4xx_StdPeriph_Driver)
set(CMSIS_DIR ${CMAKE_SOURCE_DIR}/libs/cmsis)
set(STM32_CPAL_Driver_DIR ${CMAKE_SOURCE_DIR}/libs/STM32_CPAL_Driver)
set(LINKER_SCRIPTS_DIR ${CMAKE_SOURCE_DIR}/config/LinkerScripts)

# Make sure that git submodule is initialized and updated
if (NOT EXISTS "${STDPERIPH_DIR}")
  message(FATAL_ERROR "stdperiph submodule not found. Initialize with 'git submodule update --init' in the source directory")
endif()

# Make sure that git submodule is initialized and updated
if (NOT EXISTS "${CMSIS_DIR}")
  message(FATAL_ERROR "cmsis submodule not found. Initialize with 'git submodule update --init' in the source directory")
endif()

# Make sure that git submodule is initialized and updated
if (NOT EXISTS "${STM32_CPAL_Driver_DIR}")
  message(FATAL_ERROR "CPAL submodule not found. Initialize with 'git submodule update --init' in the source directory")
endif()

include_directories(
    ${CMSIS_DIR}/core
    ${CMSIS_DIR}/device
    ${STM32_CPAL_Driver_DIR}/inc
    ${STM32_CPAL_Driver_DIR}/devices
    ${STDPERIPH_DIR}/inc
)

set(STDPERIPH_LIB_SRC
    ${CMSIS_DIR}/device/system_stm32f4xx.c
    # ${STM32_CPAL_Driver_DIR}/devices/cpal_i2c_hal_stm32f4xx.c
    # ${STM32_CPAL_Driver_DIR}/src/cpal_hal.c
    # ${STM32_CPAL_Driver_DIR}/src/cpal_i2c.c
    # ${STM32_CPAL_Driver_DIR}/src/cpal_usercallback_template.c
    ${STDPERIPH_DIR}/src/misc.c
    ${STDPERIPH_DIR}/src/stm32f4xx_adc.c
    ${STDPERIPH_DIR}/src/stm32f4xx_can.c
    ${STDPERIPH_DIR}/src/stm32f4xx_cec.c
    ${STDPERIPH_DIR}/src/stm32f4xx_crc.c
    ${STDPERIPH_DIR}/src/stm32f4xx_cryp_aes.c
    ${STDPERIPH_DIR}/src/stm32f4xx_cryp.c
    ${STDPERIPH_DIR}/src/stm32f4xx_cryp_des.c
    ${STDPERIPH_DIR}/src/stm32f4xx_cryp_tdes.c
    ${STDPERIPH_DIR}/src/stm32f4xx_dac.c
    ${STDPERIPH_DIR}/src/stm32f4xx_dbgmcu.c
    ${STDPERIPH_DIR}/src/stm32f4xx_dcmi.c
    ${STDPERIPH_DIR}/src/stm32f4xx_dfsdm.c
    ${STDPERIPH_DIR}/src/stm32f4xx_dma2d.c
    ${STDPERIPH_DIR}/src/stm32f4xx_dma.c
    ${STDPERIPH_DIR}/src/stm32f4xx_dsi.c
    ${STDPERIPH_DIR}/src/stm32f4xx_exti.c
    ${STDPERIPH_DIR}/src/stm32f4xx_flash.c
    ${STDPERIPH_DIR}/src/stm32f4xx_flash_ramfunc.c
    # ${STDPERIPH_DIR}/src/stm32f4xx_fmc.c
    ${STDPERIPH_DIR}/src/stm32f4xx_fmpi2c.c
    # ${STDPERIPH_DIR}/src/stm32f4xx_fsmc.c
    ${STDPERIPH_DIR}/src/stm32f4xx_gpio.c
    ${STDPERIPH_DIR}/src/stm32f4xx_hash.c
    ${STDPERIPH_DIR}/src/stm32f4xx_hash_md5.c
    ${STDPERIPH_DIR}/src/stm32f4xx_hash_sha1.c
    ${STDPERIPH_DIR}/src/stm32f4xx_i2c.c
    ${STDPERIPH_DIR}/src/stm32f4xx_iwdg.c
    ${STDPERIPH_DIR}/src/stm32f4xx_lptim.c
    ${STDPERIPH_DIR}/src/stm32f4xx_ltdc.c
    ${STDPERIPH_DIR}/src/stm32f4xx_pwr.c
    ${STDPERIPH_DIR}/src/stm32f4xx_qspi.c
    ${STDPERIPH_DIR}/src/stm32f4xx_rcc.c
    ${STDPERIPH_DIR}/src/stm32f4xx_rng.c
    ${STDPERIPH_DIR}/src/stm32f4xx_rtc.c
    ${STDPERIPH_DIR}/src/stm32f4xx_sai.c
    ${STDPERIPH_DIR}/src/stm32f4xx_sdio.c
    ${STDPERIPH_DIR}/src/stm32f4xx_spdifrx.c
    ${STDPERIPH_DIR}/src/stm32f4xx_spi.c
    ${STDPERIPH_DIR}/src/stm32f4xx_syscfg.c
    ${STDPERIPH_DIR}/src/stm32f4xx_tim.c
    ${STDPERIPH_DIR}/src/stm32f4xx_usart.c
    ${STDPERIPH_DIR}/src/stm32f4xx_wwdg.c
)

set(STM32_DEFINES "${STM32_DEFINES} -DUSE_STDPERIPH_DRIVER")

set_source_files_properties(${STDPERIPH_LIB_SRC}
    PROPERTIES COMPILE_FLAGS ${STM32_DEFINES}
)

add_library(stdperiph STATIC ${STDPERIPH_LIB_SRC})

set_target_properties(stdperiph PROPERTIES LINKER_LANGUAGE C)

# add startup and linker file
set(STARTUP_ASM_FILE "${CMSIS_DIR}/startup/${USE_STARTUP_FILE}")
set_property(SOURCE ${STARTUP_ASM_FILE} PROPERTY LANGUAGE ASM)
set(LINKER_FILE "${LINKER_SCRIPTS_DIR}/${USE_LINKER_SCRIPT}")

set(EXTERNAL_EXECUTABLES ${EXTERNAL_EXECUTABLES} ${STARTUP_ASM_FILE})

set(EXTERNAL_LIBS ${EXTERNAL_LIBS} stdperiph)