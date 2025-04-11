#!/usr/bin/env bash
#

# Get a signed JWT token for testing
iat=$(date +%s)
exp=$(($iat + 3600))

cat > jwt-data.json <<EOF 
{
  "alg": "RS256",
  "typ": "JWT",
  "sub": "alain.chiasson",
    "aud": "abc123",
    "iat": $iat,
    "exp": $exp,
    "project": "1"
}
EOF

JWT=$( curl -X POST -H "Content-Type: application/json" -d @jwt-data.json http://jwks:8080/jwt/sign | jq -r '.jwt' )

# Login to vault using the JWT token as role1
export VAULT_TOKEN=$(vault write -field=token auth/jwt/login jwt=$JWT role=role1)

echo "ROLE1 Policies"
vault read -format=json sys/internal/ui/resultant-acl | jq '.data.exact_paths | to_entries | map(select(.key | match("team-secrets"))) | map(.key, .value)'
vault read -format=json sys/internal/ui/resultant-acl | jq '.data.glob_paths | to_entries | map(select(.key | match("team-secrets"))) | map(.key, .value)'

# Login to vault using the JWT token as role1
echo "Failed login to role2"
export VAULT_TOKEN=$(vault write -field=token auth/jwt/login jwt=$JWT role=role2)



# Get a signed JWT token for testing
iat=$(date +%s)
exp=$(($iat + 3600))

cat > jwt-data.json <<EOF 
{
  "alg": "RS256",
  "typ": "JWT",
  "sub": "alain.chiasson",
    "aud": "abc123",
    "iat": $iat,
    "exp": $exp,
    "project": "2"
}
EOF

JWT=$( curl -X POST -H "Content-Type: application/json" -d @jwt-data.json http://jwks:8080/jwt/sign | jq -r '.jwt' )

# Login to vault using the JWT token as role1
export VAULT_TOKEN=$(vault write -field=token auth/jwt/login jwt=$JWT role=role2)

echo "ROLE2 Policies"
vault read -format=json sys/internal/ui/resultant-acl | jq '.data.exact_paths | to_entries | map(select(.key | match("team-secrets"))) | map(.key, .value)'
vault read -format=json sys/internal/ui/resultant-acl | jq '.data.glob_paths | to_entries | map(select(.key | match("team-secrets"))) | map(.key, .value)'
