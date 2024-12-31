#!/bin/bash

set -e

# Display a header
display_header() {
    clear
    echo -e "\e[1;34m=============================================\e[m"
    echo -e "\e[1;32m   Cat Forensic Collection Tool (forenscat)\e[m"
    echo -e "\e[1;34m=============================================\e[m"
    echo -e " \e[36mCreated by Xafiq - Made with ❤️\e[m\n"
}

# Function to check for necessary tools
tool_check() {
    display_header
    echo "🔍 Checking for required tools..."
    local tools=(tcpdump iftop rkhunter lynis netstat ss tar sha256sum)
    local missing_tools=()

    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            missing_tools+=("$tool")
        fi
    done

    if [[ "${#missing_tools[@]}" -ne 0 ]]; then
        echo "The following tools are missing: ${missing_tools[*]}"
        read -p "Do you want to install them? (y/n): " INSTALL
        if [[ "$INSTALL" == "y" ]]; then
            for tool in "${missing_tools[@]}"; do
                sudo apt-get install -y "$tool"
            done
        else
            echo "⚠️ Missing tools may limit functionality."
        fi
    fi
}

# Collect evidence
collect_evidence() {
    local evidence_dir
    read -p "Enter the directory to store evidence: " evidence_dir
    mkdir -p "$evidence_dir/logs" "$evidence_dir/configs" "$evidence_dir/files" "$evidence_dir/network"

    # Collect logs
    echo "🔍 Collecting logs..."
    cp -r /var/log/* "$evidence_dir/logs/" 2>/dev/null || echo "⚠️ Failed to copy some logs."

    # Collect configurations
    echo "🔍 Collecting configurations..."
    cp -r /etc/* "$evidence_dir/configs/" 2>/dev/null || echo "⚠️ Failed to copy some configs."

    # Collect hidden files
    echo "🔍 Collecting hidden files..."
    find / -name '.*' -exec cp -R '{}' "$evidence_dir/files/" \; 2>/dev/null || echo "⚠️ Failed to copy some hidden files."

    # Collect network data
    echo "🔍 Collecting network data..."
    netstat -an > "$evidence_dir/network/netstat.txt"
    ss -tuln > "$evidence_dir/network/ss.txt"
    echo "Network data collection complete."
}

# Create archive and hash
create_archive() {
    local evidence_dir=$1
    local archive_name=$(basename "$evidence_dir")
    echo "🔒 Creating compressed archive..."
    tar -czf "${archive_name}.tar.gz" -C "$(dirname "$evidence_dir")" "$archive_name"
    sha256sum "${archive_name}.tar.gz" > "${archive_name}.sha256"
    echo "✅ Archive and hash created: ${archive_name}.tar.gz, ${archive_name}.sha256"
}

# Clean up traces
clean_up() {
    echo "🧹 Cleaning up traces..."
    rm -- "$0"
    echo "✅ Cleanup complete. Only evidence directory remains."
}

# Main CLI
main_cli() {
    while true; do
        display_header
        echo "1. Check Tools"
        echo "2. Collect Evidence"
        echo "3. Create Archive and Hash"
        echo "4. Exit"
        read -p "Select an option: " choice

        case $choice in
            1) tool_check ;;
            2) collect_evidence ;;
            3)
                read -p "Enter evidence directory to archive: " evidence_dir
                create_archive "$evidence_dir"
                ;;
            4) clean_up; exit 0 ;;
            *) echo "Invalid option. Please try again." ;;
        esac
        read -p "Press Enter to return to menu..."
    done
}

# Entry point
main_cli
