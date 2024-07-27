#!/bin/bash

# Access the full path using ZED_FILE
full_path="$ZED_FILE"

# Extract filename with extension
filename_ext=$(basename "$full_path")

# Extract filename and extension
filename="${filename_ext%.*}"
extension="${filename_ext##*.}"

echo "[running $filename_ext]"

if [[ "$extension" == "cpp" ]]; then
    g++ "$full_path" -o "$filename" && ./"$filename"
elif [[ "$extension" == "c" ]]; then
    gcc "$full_path" -o "$filename" && ./"$filename"
elif [[ "$extension" == "java" ]]; then
    javac "$full_path" && java "$filename"
elif [[ "$extension" == "py" ]]; then
    python3 "$full_path"
elif [[ "$extension" == "asm" ]]; then
    # Prepare the file path for wine commands
    wine_full_path=$(winepath -w "$full_path")
    wine_filename=$(winepath -w "${filename}.obj")
    wine_exe=$(winepath -w "${filename}.exe")
    
    # Compile and run MASM assembly code
    wine "C:\\masm32\\bin\\ml.exe" /c /coff "$wine_full_path" && \
    wine "C:\\masm32\\bin\\link.exe" /subsystem:console "$wine_filename" && \
    wine "$wine_exe"
else
    echo "Unsupported file extension: $extension"
fi

