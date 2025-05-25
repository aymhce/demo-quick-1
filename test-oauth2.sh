#!/bin/bash

# Configuration
CLIENT_ID="client"  # Remplace par l'ID de ton client
CLIENT_SECRET="secret"  # Remplace par le secret de ton client
REDIRECT_URI="http://localhost:8080/login/oauth2/code/client"  # Remplace par ton URI de redirection
#REDIRECT_URI="https://aymhce.duckdns.org/login/oauth2/code/client"  # Remplace par ton URI de redirection
API_ENDPOINT="http://localhost:8080/resource" # Remplace par ton endpoint
AUTHORIZE_ENDPOINT="http://localhost:8080/oauth2/authorize"
TOKEN_ENDPOINT="http://localhost:8080/oauth2/token"

# Encoder Client ID et Secret en Base64
CLIENT_CREDENTIALS=$(echo -n "$CLIENT_ID:$CLIENT_SECRET" | base64)

# 1. Obtenir le Code d'Autorisation
# (Nécessite une interaction manuelle dans le navigateur)
echo "Ouvre cette URL dans ton navigateur pour obtenir le code d'autorisation :"
echo "$AUTHORIZE_ENDPOINT?response_type=code&client_id=$CLIENT_ID&scope=openid%20scope.read&redirect_uri=$REDIRECT_URI&grant_type=authorization_code"
read -p "Après la redirection, entre le code d'autorisation ici : " AUTHORIZATION_CODE

# Vérification que le code d'autorisation a été saisi
if [ -z "$AUTHORIZATION_CODE" ]; then
  echo "Erreur : Le code d'autorisation est vide.  Vérifie que tu l'as bien copié après la redirection."
  exit 1
fi

# 2. Échanger le Code d'Autorisation contre un Token d'Accès
echo "Échange du code d'autorisation contre un token d'accès..."
TOKEN_RESPONSE=$(curl -s -X POST \
  "$TOKEN_ENDPOINT" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "Authorization: Basic $CLIENT_CREDENTIALS" \
  -d "grant_type=authorization_code&code=$AUTHORIZATION_CODE&redirect_uri=$REDIRECT_URI")

# Extraction de l'access_token, du refresh_token et de l'expires_in
ACCESS_TOKEN=$(echo "$TOKEN_RESPONSE" | jq -r '.access_token')
REFRESH_TOKEN=$(echo "$TOKEN_RESPONSE" | jq -r '.refresh_token')
EXPIRES_IN=$(echo "$TOKEN_RESPONSE" | jq -r '.expires_in')

# Vérification que l'access_token a été récupéré
if [ -z "$ACCESS_TOKEN" ]; then
  echo "Erreur : Impossible de récupérer le token d'accès. Vérifie tes identifiants et ton code d'autorisation."
  echo "Réponse du serveur : $TOKEN_RESPONSE"
  exit 1
fi

echo "Token d'accès obtenu : $ACCESS_TOKEN"
echo "Token de rafraîchissement obtenu : $REFRESH_TOKEN"
echo "Le token expire dans : $EXPIRES_IN secondes"

# 3. Appeler l'API avec le Token d'Accès
echo "Appel de l'API..."
API_RESPONSE=$(curl -s -X GET \
  "$API_ENDPOINT" \
  -H "Authorization: Bearer $ACCESS_TOKEN")

echo "Réponse de l'API : $API_RESPONSE"

# 4. Rafraîchir le Token d'Accès (après un délai simulé)
sleep 5  # Simule un délai avant de rafraîchir le token

echo "Rafraîchissement du token d'accès..."
REFRESH_RESPONSE=$(curl -s -X POST \
  "$TOKEN_ENDPOINT" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "Authorization: Basic $CLIENT_CREDENTIALS" \
  -d "grant_type=refresh_token&refresh_token=$REFRESH_TOKEN")

NEW_ACCESS_TOKEN=$(echo "$REFRESH_RESPONSE" | jq -r '.access_token')
NEW_REFRESH_TOKEN=$(echo "$REFRESH_RESPONSE" | jq -r '.refresh_token')

if [ -z "$NEW_ACCESS_TOKEN" ]; then
  echo "Erreur : Impossible de rafraîchir le token d'accès."
  echo "Réponse du serveur : $REFRESH_RESPONSE"
  exit 1
fi

echo "Nouveau token d'accès obtenu : $NEW_ACCESS_TOKEN"
echo "Nouveau token de rafraîchissement obtenu : $NEW_REFRESH_TOKEN"

# Fin du script
echo "Script terminé."
exit 0
