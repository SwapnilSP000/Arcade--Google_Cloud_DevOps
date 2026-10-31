#!/usr/bin/env bash
# ==============================================================================
# Script: 04-connect-to-alloydb.sh
# Lab: GSP395 - Create and Manage AlloyDB Instances
# Environment: 
#   Step 1 runs in Google Cloud Shell (SSH to VM).
#   Step 2 runs inside the alloydb-client VM terminal.
# Description: Connect to the alloydb-client VM and launch psql with SSL.
# ==============================================================================

# ------------------------------------------------------------------------------
# Part 1: Execute in Google Cloud Shell
# ------------------------------------------------------------------------------
# SSH into the alloydb-client VM located in us-west1-b:
#
# gcloud compute ssh alloydb-client --zone=us-west1-b

# ------------------------------------------------------------------------------
# Part 2: Execute in alloydb-client VM Terminal
# ------------------------------------------------------------------------------
# Once logged in to student@alloydb-client:
# Export the private IP of the primary AlloyDB instance:
#
# export ALLOYDB_IP="<PRIMARY_INSTANCE_PRIVATE_IP>"
#
# Connect securely using PostgreSQL client (psql) requiring SSL encryption:
#
# psql -h "${ALLOYDB_IP}" -U postgres -d postgres "sslmode=require"
#
# You will be prompted to enter the database password:
# Password for user postgres: <ENTER_PASSWORD>
#
# Upon successful connection, the PostgreSQL console prompt appears:
# postgres=>

