# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
Dummy::Application.config.secret_token = 'c7229d3064b76a518e3f12d5ea54451d688a469c130db7f1c96507327767f2c1bcb9a564392334b754e5cc999071bd341d5d10ee931922c749260a155c6c0dc2'
Dummy::Application.config.secret_key_base = Dummy::Application.config.secret_token
