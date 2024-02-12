#!/bin/bash

# Define the command version
VERSION="v0.1.0"

# Function to display the manual page
display_manual() {
    echo "NAME"
    echo "    internsctl - custom Linux command for operations"
    echo ""
    echo "SYNOPSIS"
    echo "    internsctl [COMMAND] [OPTIONS] [ARGUMENTS]"
    echo ""
    echo "DESCRIPTION"
    echo "    internsctl is a custom Linux command designed to provide various system information"
    echo "    and perform operations related to user management and file information."
    echo ""
    echo "COMMANDS"
    echo "    cpu getinfo         Display CPU information"
    echo "    memory getinfo      Display memory information"
    echo "    user create         Create a new user"
    echo "    user list           List all regular users"
    echo "    user list --sudo-only   List all users with sudo permissions"
    echo "    file getinfo        Get information about a file"
    echo ""
    echo "OPTIONS"
    echo "    --size, -s          Print size of the specified file"
    echo "    --permissions, -p  Print file permissions"
    echo "    --owner, -o         Print file owner"
    echo "    --last-modified, -m Print last modified time of the specified file"
    echo ""
    echo "VERSION"
    echo "    internsctl $VERSION"
}

# Function to display help
display_help() {
    display_manual
}

# Function to display version
display_version() {
    echo "internsctl $VERSION"
}

# Main function to handle commands
main() {
    case $1 in
        "--help" )
            display_help
            ;;
        "--version" )
            display_version
            ;;
        "cpu" )
            if [ "$2" == "getinfo" ]; then
                # Implement CPU information retrieval logic here
                echo "CPU information:"
                lscpu
            else
                display_manual
            fi
            ;;
        "memory" )
            if [ "$2" == "getinfo" ]; then
                # Implement memory information retrieval logic here
                echo "Memory information:"
                free -h
            else
                display_manual
            fi
            ;;
        "user" )
            if [ "$2" == "create" ]; then
                # Implement user creation logic here
                username="$3"
                sudo useradd -m "$username"
                echo "User $username created"
            elif [ "$2" == "list" ]; then
                if [ "$3" == "--sudo-only" ]; then
                    # Implement listing of users with sudo permissions logic here
                    echo "Users with sudo permissions:"
                    grep -Po '^sudo.+:\K.*$' /etc/group | tr ',' '\n'
                else
                    # Implement listing of all regular users logic here
                    echo "Regular users:"
                    cut -d: -f1 /etc/passwd
                fi
            else
                display_manual
            fi
            ;;
        "file" )
            if [ "$2" == "getinfo" ]; then
                # Implement file information retrieval logic here
                filename="$3"
                echo "File information for $filename:"
                stat --format="File: %n%nAccess: %A%nSize(B): %s%nOwner: %U%nModify: %y" "$filename"
                if [ "$4" == "--size" ]; then
                    echo "Size(B): $(stat --format="%s" "$filename")"
                elif [ "$4" == "--permissions" ]; then
                    echo "Permissions: $(stat --format="%A" "$filename")"
                elif [ "$4" == "--owner" ]; then
                    echo "Owner: $(stat --format="%U" "$filename")"
                elif [ "$4" == "--last-modified" ]; then
                    echo "Last Modified: $(stat --format="%y" "$filename")"
                fi
            else
                display_manual
            fi
            ;;
        * )
            display_manual
            ;;
    esac
}

main $@

