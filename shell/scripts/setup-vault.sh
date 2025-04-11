#!/usr/bin/env bash
#

# Using a preset Vault Root Token 
vault login root

# Add team-secrets kv2
vault secrets enable -path=team-secrets kv-v2

# Enable vault user-pass 
vault auth enable jwt

vault write auth/jwt/config \
    jwks_url="http://jwks:8080/.well-known/jwks.json" \
    aud="abc123"

# Enable role based policy template
ROLE_ACCESSOR=$(vault auth list -format=json  | jq -r 'to_entries[] | select( .value.type | test( "jwt")) | .value.accessor' )


vault policy write role_template - <<EOF
path "team-secrets/data/jwt_role/{{identity.entity.aliases.${ROLE_ACCESSOR}.metadata.role}}" {
    capabilities = ["list", "read", "create", "update"]
}
path "team-secrets/data/jwt_role/{{identity.entity.aliases.${ROLE_ACCESSOR}.metadata.role}}/*" {
    capabilities = ["list", "read", "create", "update"]
}
path "team-secrets/metadata/jwt_role/{{identity.entity.aliases.${ROLE_ACCESSOR}.metadata.role}}" {
    capabilities = ["list", "read"]
}
path "team-secrets/metadata/jwt_role/{{identity.entity.aliases.${ROLE_ACCESSOR}.metadata.role}}/*" {
    capabilities = ["list", "read"]
}

EOF


vault write auth/jwt/role/role1 -<<EOF
{
  "user_claim": "sub",
  "bound_audiences": "abc123",
  "role_type": "jwt",
  "policies": "role_template",
  "ttl": "5m",
  "bound_claims": { "project": ["1"] }
}
EOF



vault write auth/jwt/role/role2 -<<EOF
{
  "user_claim": "sub",
  "bound_audiences": "abc123",
  "role_type": "jwt",
  "policies": "role_template",
  "ttl": "5m",
  "bound_claims": { "project": ["2"] }
}
EOF
