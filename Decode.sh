#!/bin/bash

# Define banner text
BANNER="
  _______            _____       _           _     _     
 |__   __|          / ____|     (_)         | |   (_)    
    | |     _ __  | (___  _ __  _ _ __  ___| |__  _ ___ 
    | |    | '_ \  \___ \| '_ \| | '_ \/ __| '_ \| / __|
    | |    | |_) | ____) | |_) | | |_) \__ \ | | | \__ \\
    |_|    | .__/ |_____/| .__/|_| .__/|___/_| |_|_|___/
           | |           | |     | |                      
           |_|           |_|     |_|                      

    Steganography tool for extracting messages from images"

# Clear screen
clear

# Show banner
echo "$BANNER"
echo

# Check if steghide is already installed
if ! command -v steghide &> /dev/null; then
    # Check if the operating system is Termux
    if [[ $(uname -o) == *Android* ]]; then
        pkg update
        pkg install -y steghide
    # Check if the operating system is Linux
    elif [[ $(uname -s) == Linux* ]]; then
        sudo apt-get update
        sudo apt-get install -y steghide
    else
        # If the operating system is not Termux or Linux, exit with an error
        echo "Unsupported operating system."
        exit 1
    fi
fi

# clear screen 
clear

# show banner 
echo "$BANNER"
echo


# Parse command line arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -s|--secret)
        secret_image="$2"
        shift # past argument
        shift # past value
        ;;
        -p|--password)
        password="$2"
        shift # past argument
        shift # past value
        ;;
        *)    # unknown option
        echo "Unknown option: $1"
        exit 1
        ;;
    esac
done

# Prompt for secret image path if not provided
if [ -z "$secret_image" ]; then
    read -p "Enter secret image path: " secret_image
fi

# Prompt for password if not provided
if [ -z "$password" ]; then
    read -s -p "Enter password: " password
    echo
fi

# Check if the secret image and password were specified
if [ -z "$secret_image" ]; then
    echo "Secret image not specified."
    exit 1
fi
if [ -z "$password" ]; then
    echo "Password not specified."
    exit 1
fi

# Extract the message
steghide extract -sf "$secret_image" -p "$password" -xf message.txt

# Check if the message was extracted
if [ $? -ne 0 ]; then
    echo "Failed to extract message."
    exit 1
fi

# Display the message
echo "Message extracted from $secret_image:"
cat message.txt

# remove temporary file
rm -rf message.txt