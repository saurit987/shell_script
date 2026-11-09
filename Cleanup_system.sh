#!/bin/bash

# This part of the script will Cleanup a linux system's junk files. 
echo "Cleaning up system junk data"
echo "If you agree, only then this script will delete the junk files"
# Cleaning user cache
echo "Do you want to clear current user cache data?(y/n)"
read response1
    if [ "$response1" = y ]; then
        sudo find ~/.cache/ -type f -delete

    else
        echo "Skipping this"
    fi

#System cache data
echo "Do you want to clear system cache data?(y/n)"
read response2
    if [ "$response2" = y ]; then
        sudo find /var/cache -type f -delete
    else
        echo "Skipping this"
    fi

# # temp files
echo "Do you want to clear temporary files(tmp)?(y/n)"
read response3
    if [ "$response3" = y ]; then
        rm -rf /tmp/*
    else
        echo "Skipping this"
    fi   

# Cleaning up package manager cache

echo "Do you want to cleanup cache of your package manager?(y/n)"
read response4

    if [ "$response4" = y ]; then

        if command -v apt >/dev/null 2>&1; then
            sudo apt-get clean
        elif command -v dnf >/dev/null 2>&1; then
            sudo dnf clean all
        elif command -v pacman >/dev/null 2>&1; then
            sudo pacman -Sc
        fi
    else
        echo "Skipping this part"
    fi