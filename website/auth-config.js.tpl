// Configuración MSAL para autenticación OIDC
const msalConfig = {
    auth: {
        clientId: '${client_id}',
        authority: 'https://login.microsoftonline.com/${tenant_id}',
        redirectUri: '${redirect_uri}'
    },
    cache: {
        cacheLocation: "localStorage",
        storeAuthStateInCookie: false
    }
};

// Configuración de solicitud de login
const loginRequest = {
    scopes: ["openid", "profile", "User.Read"]
};

// Configuración de solicitud de token
const tokenRequest = {
    scopes: ["User.Read"],
    forceRefresh: false
};

// Inicializar MSAL
const myMSALObj = new msal.PublicClientApplication(msalConfig);