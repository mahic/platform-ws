# Step 1 - Security

When building a data platform, we need to have some security.

In this task we will set up [KeyCloak](https://www.keycloak.org/), an Open Source Identity Provider.

1. Add below code to Docker Compose file

```
  keycloak_web:
    image: quay.io/keycloak/keycloak:26.0.1
    container_name: keycloak_web
    environment:
      KC_DB: postgres
      KC_DB_URL: jdbc:postgresql://keycloakdb:5432/keycloak
      KC_DB_USERNAME: keycloak
      KC_DB_PASSWORD: password
      KC_HOSTNAME: auth.platform.local
      KC_HOSTNAME_PORT: 8445
      KC_HOSTNAME_STRICT: true
      KC_HOSTNAME_STRICT_HTTPS: true
      KC_LOG_LEVEL: info
      KC_METRICS_ENABLED: true
      KC_HEALTH_ENABLED: true
      KC_BOOTSTRAP_ADMIN_USERNAME: admin
      KC_BOOTSTRAP_ADMIN_PASSWORD: admin
      KC_HTTPS_CERTIFICATE_FILE: /etc/x509/https/tls.crt
      KC_HTTPS_CERTIFICATE_KEY_FILE: /etc/x509/https/tls.key
    command: start-dev
    depends_on:
      - keycloakdb
    volumes:
      - ./certs/platform.local.crt:/etc/x509/https/tls.crt
      - ./certs/platform.local.key:/etc/x509/https/tls.key
    ports:
      - 8443:8443
    networks:
      platform-network: 
        aliases:
        - auth.platform.local
  keycloakdb:
    image: postgres:16.2
    volumes:
      - ./data/postgres/keycloak:/var/lib/postgresql/data
    environment:
      POSTGRES_DB: keycloak
      POSTGRES_USER: keycloak
      POSTGRES_PASSWORD: password
    networks:
      - platform-network
```

2. `docker compose down`
3. `docker compose up` and wait for Keycloak to boot up
4. Go to [https://auth.platform.local:8443](https://auth.platform.local:8443) and log in with admin/admin

If you are done, move on to [task 2](./task2.md)