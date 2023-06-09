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


# Help function
function help {
    echo "Usage: $0 [OPTIONS]"
    echo "Extract message from image."
    echo "Options:"
    echo "  -s, --secret SECRET_IMAGE   path to secret image"
    echo "  -p, --password PASSWORD     password for encryption"
    echo "  -h, --help                  display this help and exit"
}

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
        -h|--help)
        help
        exit 0
        ;;
        *)    # unknown option
        echo "Unknown option: $1"
        exit 1
        ;;
    esac
done

# Display help if no arguments are provided
if [[ -z "$secret_image" || -z "$password" ]]; then
    help
    exit 0
fi

# Prompt for password if not provided
if [ -z "$password" ]; then
    read -s -p "Enter password: " password
    echo
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
if [ -f message.txt ]; then
    rm -f message.txt
fi

# Display the message
echo "Message extracted from $secret_image:"
cat message.txt

# remove temporary file
rm -rf message.txt
