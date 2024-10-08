#!/bin/bash
trap "echo -e '\033[0;31m Script execution aborted. \033[0m'; exit 1" INT
file1="./stock-rom/flash_all.sh"
file2="./stock-rom/flash_all_lock.sh"
file3="./stock-rom/flash_all_except_*.sh"

sudo chmod +x $file1 $file2 $file3
sudo -k

echo -e "\033[0;32m Succeed! CHMOD EXECUTED!
    \033[0m"

look="fastboot"
replace="./stock-rom/fastboot"

# Perform search and replace using awk
if [ ! -f $file1 ]; then
    echo -e "\033[0;31m $file1 file is not found \033[0m";
    exit 1;    
fi

if [ ! -f $file2 ]; then
    echo -e "\033[0;31m $file2 file is not found \033[0m";
    exit 1;    
fi


if ! grep -q "$replace" "$file1"; then
    awk '{ gsub(/'"$look"'/, "'"$replace"'"); print }' "$file1" > flash_all.txt && mv flash_all.txt "$file1"

    awk -v search="/images/" -v replace="/stock-rom/images/" '{ gsub(search, replace); print }' "$file1" > flash_all.txt && mv flash_all.txt "$file1"
fi

if ! grep -q "$replace" "$file2"; then
    awk '{ gsub(/'"$look"'/, "'"$replace"'"); print }' "$file2" > flash_all_lock.txt && mv flash_all_lock.txt "$file2"

    awk -v search="/images/" -v replace="/stock-rom/images/" '{ gsub(search, replace); print }' "$file2" > flash_all.txt && mv flash_all.txt "$file2"
fi

# Use a loop to handle multiple files that match the pattern
for file in ./stock-rom/flash_all_except_*.sh; do
    if [[ -f "$file" ]]; then
        echo "Processing file: $file"

        if ! grep -q "$replace" "$file"; then
            # Replace 'look' with 'replace' in the file
            awk '{ gsub(/'"$look"'/, "'"$replace"'"); print }' "$file" > flash_all.txt && mv flash_all.txt "$file"

            # Replace '/images/' with '/stock-rom/images/' in the file
            awk -v search="/images/" -v replace="/stock-rom/images/" '{ gsub(search, replace); print }' "$file" > flash_all.txt && mv flash_all.txt "$file"
        fi
    else
        echo "No files found matching the pattern."
    fi
done


if [ $? -eq 0 ]; then
    echo -e "\033[0;32m Modifying Flash file Succeed!
    \033[0m"
fi

cp -R "./platform-tools"/* "./stock-rom/"
echo -e "\033[0;32m Copying files completed
    \033[0m"

echo -e "\033[0;33m What do you want to do?
1. Flash without lock bootloader
2. Flash and lock bootloader
3. Flash except data storage
4. Restore all modified files which are required to execute flash script.
(Press Any key to Exit or input your choice.)
\033[0m";

read -p "Choice: " flasher

case $flasher in
    "1")
        source $file1
    ;;
    "2")
        source $file2
    ;;
    "3")
        source $file3
    ;;
    "4")
        if grep -q "$replace" "$file1"; then
            awk -v search="$replace" -v replace="$look" '{ gsub(search, replace); print }' "$file1" > flash_all.txt && mv flash_all.txt "$file1"

            awk -v search="/stock-rom/images/" -v replace="/images/" '{ gsub(search, replace); print }' "$file1" > flash_all.txt && mv flash_all.txt "$file1"
        fi

        if grep -q "$replace" "$file2"; then
            awk -v search="$replace" -v replace="$look" '{ gsub(search, replace); print }' "$file2" > flash_all.txt && mv flash_all.txt "$file2"

            awk -v search="/stock-rom/images/" -v replace="/images/" '{ gsub(search, replace); print }' "$file2" > flash_all.txt && mv flash_all.txt "$file2"
        fi

        if grep -q "$replace" "$file3"; then
            awk -v search="$replace" -v replace="$look" '{ gsub(search, replace); print }' "$file3" > flash_all.txt && mv flash_all.txt "$file3"

            awk -v search="/stock-rom/images/" -v replace="/images/" '{ gsub(search, replace); print }' "$file3" > flash_all.txt && mv flash_all.txt "$file3"
        fi

        echo -e "\033[0;32m Modified Flash file restored! \033[0m"

        source ./flash.sh
    ;;
    *)
        echo "Aborting..."


        if grep -q "$replace" "$file1"; then
            awk -v search="$replace" -v replace="$look" '{ gsub(search, replace); print }' "$file1" > flash_all.txt && mv flash_all.txt "$file1"

            awk -v search="/stock-rom/images/" -v replace="/images/" '{ gsub(search, replace); print }' "$file1" > flash_all.txt && mv flash_all.txt "$file1"
        fi

        if grep -q "$replace" "$file2"; then
            awk -v search="$replace" -v replace="$look" '{ gsub(search, replace); print }' "$file2" > flash_all.txt && mv flash_all.txt "$file2"

            awk -v search="/stock-rom/images/" -v replace="/images/" '{ gsub(search, replace); print }' "$file2" > flash_all.txt && mv flash_all.txt "$file2"
        fi

        if grep -q "$replace" "$file3"; then
            awk -v search="$replace" -v replace="$look" '{ gsub(search, replace); print }' "$file3" > flash_all.txt && mv flash_all.txt "$file3"

            awk -v search="/stock-rom/images/" -v replace="/images/" '{ gsub(search, replace); print }' "$file3" > flash_all.txt && mv flash_all.txt "$file3"
        fi

        echo -e "\033[0;32m Modified Flash file restored! \033[0m"

        source ./flash.sh
    ;;
esac