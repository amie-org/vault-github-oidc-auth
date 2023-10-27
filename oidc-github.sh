# Configure OIDC auth for Github Actions
# https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-hashicorp-vault


# Configure a policy named github-actions that only grants access to the specific paths
vault policy write github-actions - <<EOF
# Read-only permission on 'secret/data/github-actions/*' path

path "secret/data/github-actions/*" {
  capabilities = [ "read" ]
}
EOF

# Configure roles to group different policies together. 
# If the authentication is successful, these policies are attached to the resulting Vault access token.auth/jwt/role/myproject-production -<<EOF
vault write auth/jwt/role/github-actions -<<EOF
{
  "role_type": "jwt",
  "user_claim": "actor",
  "bound_claims": {
    "repository": "amie-org/*"
  },
  "policies": ["github-actions"],
  "ttl": "15m"
}
EOF

# write a secret named my-secret at the kv v2 path
vault kv put secret/github-actions/my-secret hello=action 

vault kv put secret/github-actions hello=action 