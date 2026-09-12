#!/bin/bash

# ============================================================
# Privilege Escalation Simulation
# Project: Splunk RBA Attack Chain Detection
# Environment: Controlled Kali Linux Lab
#
# Purpose:
# Simulate suspicious privilege-related changes and generate
# Linux Auditd telemetry for Splunk behavioral detection.
# ============================================================


# ------------------------------------------------------------
# Step 1: Enable Auditd
# ------------------------------------------------------------

sudo systemctl enable --now auditd


# ------------------------------------------------------------
# Step 2: Configure Auditd rules
# ------------------------------------------------------------

# Monitor changes to /etc/passwd
sudo auditctl -w /etc/passwd -p wa -k passwd_changes

# Monitor changes to /etc/sudoers
sudo auditctl -w /etc/sudoers -p wa -k sudoers_changes

# Monitor commands executed with root privileges
sudo auditctl -a always,exit -F arch=b64 -S execve -F euid=0 -k root_commands


# ------------------------------------------------------------
# Step 3: Verify Auditd rules
# ------------------------------------------------------------

sudo auditctl -l


# ------------------------------------------------------------
# Step 4: Create a test user
# ------------------------------------------------------------

sudo useradd testattacker

# Set password interactively
sudo passwd testattacker


# ------------------------------------------------------------
# Step 5: Add the test user to the sudo group
# ------------------------------------------------------------

sudo usermod -aG sudo testattacker

# Verify sudo privileges
sudo -u testattacker sudo -l


# ------------------------------------------------------------
# Step 6: Create a second test user
# ------------------------------------------------------------

sudo useradd testattacker2

# Set password interactively
sudo passwd testattacker2


# ------------------------------------------------------------
# Step 7: Add the second test user to the sudo group
# ------------------------------------------------------------

sudo usermod -aG sudo testattacker2


# ------------------------------------------------------------
# Step 8: Simulate a sudoers privilege modification
# ------------------------------------------------------------

echo "testattacker2 ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
