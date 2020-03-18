#!/bin/bash
LINKER_SCRIPT_FOLDER=source/config/LinkerScripts
STARTUP_FILES_FOLDER=source/libs/cmsis/startup

echo -e "These are the supported linker scipts that you can use in the build.sh:\n"
ls -al ${LINKER_SCRIPT_FOLDER}/*/ | grep -E .ld | rev | cut -d' ' -f1 | rev

echo -e "\nThese are the supported startup files that you can use in the build.sh:\n"
ls -al ${STARTUP_FILES_FOLDER}/ | grep -E .s | rev | cut -d' ' -f1 | rev