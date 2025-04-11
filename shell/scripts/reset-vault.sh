#!/usr/bin/env bash
#

# Using a preset Vault Root Token 
vault login root

vault auth disable jwt
vault secrets disable team-secrets

