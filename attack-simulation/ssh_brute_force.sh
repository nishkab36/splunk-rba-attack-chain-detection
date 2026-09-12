#!/bin/bash

# ============================================================
# SSH Brute-Force Simulation
# Project: Splunk RBA Attack Chain Detection
# Environment: Controlled Kali Linux Lab
#
# Purpose:
# Generate controlled failed SSH authentication activity
# for behavioral detection and risk scoring in Splunk.
# ============================================================

# Step 1: Create a dedicated test SSH user
sudo useradd -m sshtestuser

# Step 2: Set the password for the test user
# This step is interactive.
sudo passwd sshtestuser

# Step 3: Create a password wordlist for the controlled lab
cat << 'EOF' > ~/test_passwords.txt
password123
admin123
letmein
TestPass123!
EOF

# Step 4: Run the controlled SSH brute-force simulation
hydra -l sshtestuser -P ~/test_passwords.txt ssh://127.0.0.1
