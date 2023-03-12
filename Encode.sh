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

    Steganography tool for hiding messages in images"

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
        -m|--message)
        message="$2"
        shift # past argument
        shift # past value
        ;;
        -c|--cover)
        cover_image="$2"
        shift # past argument
        shift # past value
        ;;
        -p|--password)
        password="$2"
        shift # past argument
        shift # past value
        ;;
        -o|--output)
        output_image="$2"
        shift # past argument
        shift # past value
        ;;
        *)    # unknown option
        echo "Unknown option: $1"
        exit 1
        ;;
    esac
done

# Prompt for message if not provided
if [ -z "$message" ]; then
    read -p "Enter message: " message
fi

# Prompt for cover image path if not provided
if [ -z "$cover_image" ]; then
    read -p "Enter cover image path: " cover_image
fi

# Prompt for password if not provided
if [ -z "$password" ]; then
    read -s -p "Enter password: " password
    echo
fi

# Prompt for output image name if not provided
if [ -z "$output_image" ]; then
    read -p "Enter name for output image (default: secret.png): " output_image
    if [ -z "$output_image" ]; then
        output_image="secret.png"
    fi
fi

# Check if the message, cover image, and password were specified
if [ -z "$message" ]; then
    echo "Message not specified."
    exit 1
fi
if [ -z "$cover_image" ]; then
    echo "Cover image not specified."
    exit 1
fi
if [ -z "$password" ]; then
    echo "Password not specified."
    exit 1
fi

# Save message to a file
echo "$message" > message.txt

# Hide the message
steghide embed -ef message.txt -cf "$cover_image" -sf "$output_image" -p "$password"

echo "Message hidden in $cover_image as $output_image."

# remove temporary file
rm -rf message.txt