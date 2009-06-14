# Wefrag

Il s'agit du code source du site [Wefrag](http://www.wefrag.com "Wefrag") développé
en Ruby on Rails.

## Installation

Récupérez et configurez :

    $ git clone git://github.com/hc/wefrag.git
    $ cd wefrag
    $ git submodule init
    $ git submodule update
    $ ./script/generate custom_config

Configurez et initialisez l'accès à la base de données :

    $ cp config/database.yml.example config/database.yml
    $ vim config/database.yml
    $ rake db:create db:migrate db:fixtures:load

Vous aurez peut-être besoin d'au moins un minimum de gems :

    $sudo gem install mysql ruby-openid chronic rmagick

## Serveur web

Démarrez le serveur web :

    $ ./script/server

Accèdez au site à l'adresse [http://localhost:3000](http://localhost:3000). 
Vous pouvez vous identifier avec les comptes joe/joe et root/root

