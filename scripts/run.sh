#!/bin/bash

PATH_CLEANING_CORE_DUMP="$DIR_SCRIPTS/clear_core_dump.sh"

function run_and_collect()
{
    total_files=$(ls -1 $DIR_TARGET/* 2>/dev/null | wc -l)
    current_file=1

    if [[ "$total_files" -eq 0 ]]; then
    {
        if [ "$FLAG_BUILDING_LIBRARY" != "Yes" ]; then
            echo "❌ NO exe to run"
            exit 1
        else
            lib_files=$(ls -1 $DIR_BUILD/*.{so,a} 2>/dev/null | wc -l)
            if [[ "$lib_files" -eq 0 ]]; then
                echo "❌ NO library files (.so/.a) found in $DIR_BUILD"
                exit 1
            else
                echo -e "✅ Found $lib_files library files:\n"
                ls -1 $DIR_BUILD/*.{so,a} 2>/dev/null
            fi
        fi
    }
    fi

    # Only run executables if we're not building libraries
    if [ "$FLAG_BUILDING_LIBRARY" != "Yes" ]; then
        for exe in $DIR_TARGET/*; do
        {
            log_name=$(basename $exe); log_name="${log_name%.*}";
            
            # echo -e "\nRUN ($current_file/$total_files) - $exe"; ./$exe > $DIR_LOG/$log_name.log;
            echo -e "\nRUN ($current_file/$total_files) - $exe"; ./$exe

            current_file=$((current_file + 1))
        }
        done
    fi
}


# START #

./production.sh; echo -e "\n"

cd $DIR_ROOT
clear_dir "$DIR_LOG"
clear_dir "$DIR_OUTPUT"
./$PATH_CLEANING_CORE_DUMP

run_and_collect
