# Wefrag

Il s'agit du code source du site [Wefrag](http://www.wefrag.com "Wefrag") développé
en Ruby on Rails.

## Installation

Récupérez le code et ses dépendences :

    git clone git://github.com/hc/wefrag.git
    cd wefrag
    git submodule init
    git submodule update

Configurez et initialisez l'application :

    cp config/database.yml.example config/database.yml
    vim config/database.yml
    ./script/generate custom_config
    rake db:create db:migrate db:fixtures:load

Vous aurez peut-être besoin d'au moins un minimum de gems :

    sudo gem install mysql memcache-client ruby-openid chronic rmagick

## Serveur web

Démarrez le serveur web :

    ./script/server

Accèdez au site à l'adresse [http://localhost:3000](http://localhost:3000). 
Vous pouvez vous identifier avec les comptes joe/joe et root/root

# Contact

* ced {at} wal {dot} fr

