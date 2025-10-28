#!/bin/bash

# Debug mode for GitHub Actions
if [ "$GITHUB_ACTIONS" = "true" ]; then
    set -x
fi

PATH_CLEANING_CORE_DUMP="$DIR_SCRIPTS/clear_core_dump.sh"

function run_and_collect()
{
    echo "DEBUG: run_and_collect - counting files in $DIR_TARGET"
    total_files=$(ls -1 $DIR_TARGET/* 2>/dev/null | wc -l)
    echo "DEBUG: Found $total_files files"
    current_file=1

    if [[ "$total_files" -eq 0 ]]; then
    {
        echo "❌ NO exe to run"
        exit 1
    }
    fi

    for exe in $DIR_TARGET/*; do
    {
        log_name=$(basename $exe); log_name="${log_name%.*}";
        
        echo "DEBUG: Running executable: $exe"
        # echo -e "\nRUN ($current_file/$total_files) - $exe"; ./$exe > $DIR_LOG/$log_name.log;
        echo -e "\nRUN ($current_file/$total_files) - $exe"; ./$exe
        echo "DEBUG: Executable $exe exit code: $?"

        current_file=$((current_file + 1))
    }
    done
}


# START #

echo "DEBUG: Starting production.sh"
./production.sh; echo -e "\n"
echo "DEBUG: production.sh exit code: $?"

echo "DEBUG: Changing to DIR_ROOT: $DIR_ROOT"
cd $DIR_ROOT
echo "DEBUG: Current directory: $(pwd)"

echo "DEBUG: Clearing directories"
clear_dir "$DIR_LOG"
echo "DEBUG: clear_dir LOG exit code: $?"
clear_dir "$DIR_OUTPUT"
echo "DEBUG: clear_dir OUTPUT exit code: $?"

echo "DEBUG: Running clear_core_dump"
./$PATH_CLEANING_CORE_DUMP
echo "DEBUG: clear_core_dump exit code: $?"

echo "DEBUG: Starting run_and_collect"
run_and_collect
echo "DEBUG: run_and_collect exit code: $?"
