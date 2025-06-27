# Script-bash

backup_system.sh
================

Script Bash permettant de gérer des sauvegardes automatiques d’un répertoire personnel sous Linux.
Il propose un menu interactif ainsi que des options en ligne de commande.

Fonctions principales
---------------------

- Sauvegarde compressée (.tar.gz) du répertoire personnel
- Liste des sauvegardes disponibles
- Restauration à partir d’un fichier de sauvegarde
- Configuration automatique des répertoires
- Affichage des logs d’activité
- Aide et version accessibles via options CLI

Utilisation
-----------

Exécution simple (menu interactif) :

    ./backup_system.sh

Ou avec des options :

    ./backup_system.sh [OPTION]

Options disponibles :

    --help       : Affiche l’aide dans le terminal
    --version    : Affiche la version du script
    --config     : Lance uniquement la configuration
    --backup     : Lance une sauvegarde sans passer par le menu

Structure des répertoires utilisés
----------------------------------

- Répertoire source         : $HOME
- Répertoire de sauvegarde  : $HOME/sauvegarde
- Répertoire de logs        : $HOME/LOGS
- Fichier de log            : $HOME/LOGS/backup.log

Menu interactif
---------------

1. Créer une sauvegarde
2. Lister les sauvegardes
3. Restaurer une sauvegarde existante
4. Voir les logs
5. Configurer les répertoires
6. Afficher l'aide
7. Quitter

Exemples de commandes
---------------------

    ./backup_system.sh --backup      # Lancer une sauvegarde directe
    ./backup_system.sh --help        # Voir l’aide
    ./backup_system.sh --config      # Configurer les répertoires nécessaires

Remarques
---------

- Le script vérifie que les dossiers existent avant de lancer les opérations.
- Il journalise chaque action dans un fichier backup.log.
- Le nom des fichiers de sauvegarde est horodaté, par exemple : backup_27062025_101245.tar.gz
