# Vault integration env with a JWKS endpoint

In this case, we are using a JWKS enpoint simulator to validate rules, roles and authentication methods for Vault. This allows us to generate JWT tokens similar to other JWT systems ( eg: Gitlab, GitHub and Kubernetes.) and validate role definitions and vault policy templates. 

# Startup 

To start, launch docker compose. 

    docker compose up -d --build

Our docker composes uses Hashicorp's vault container. It is started up with the root key as "root" to simplify the initial setup. Currently We use root for the initial setup of the systems. After that, we create userpass users and add what is required as needed.

## Initial provisioning 

The shell container has the initial provisioning scripts. : 

    docker compose exec shell /bin/bash -c setup-vault.sh

You can then run a simple test script to make sure evrything is ok - it sohuld give one error at the end when reading data it does not have permission to read..

    docker compose exec shell /bin/bash -c test-setup.sh

If you ever need to re-run the vault setup, you should run the reset-vault.sh script first or errors will occure for already existing systems.

    docker compose exec shell /bin/bash -c reset-vault.sh

## Notes:

- The UI is accessible from localhost:8200
- You can tests out things via the shell container, and exec into it :

    docker compose exec shell /bin/bash

