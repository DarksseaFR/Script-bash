#!/bin/bash

# Déclaration des variables de chemins pour les dossiers source, backup, logs, et du fichier log

rep_source="$HOME"
rep_backup="$HOME/sauvegarde"
rep_log="$HOME/LOGS"
fichier_log="$rep_log/backup.log"
version="$0 v1" # Nom du script + version

# Fonction pour ecrire dans le fichier log

log_message() {
     message="$1"
     timestamp=$(date '+%Y-%m-%d %H:%M:%S') # Date et heure actuelles
    echo "[$timestamp] $message" >> "$fichier_log" # Ecris dans le fichier log la date de l'erreur et l'erreur en argument
}

# Fonction pour vérifier l’existence des dossiers de sauvegarde et de logs, et les créer si besoin

configuration() {
        # Vérifie que le répertoire backup existe
        if [ ! -d $rep_backup ]; then
                echo " création du repertoire sauvegarde "
                mkdir -p "$rep_backup"
                echo "$rep_backup"
        else
                echo " Le repertoire de sauvegarde existe deja "
        fi
        # Vérifie que le répertoire log existe
        if [ ! -d $rep_log ]; then
        echo " création du repertoire logs "
        mkdir -p "$rep_log"
                echo $rep_log
    else
        echo " Le repertoire log existe deja "
    fi

}

# Fonction pour créer la sauvegarde d'un repertoire utilisateur

creer_sauvegarde() {
    echo -e " === CRÉATION DE SAUVEGARDE === "
        # Vérifie que le répertoire source existe
    if [[ ! -d "$rep_source" ]]; then
        echo -e " Erreur : Le répertoire source n'existe pas : $rep_source"
        log_message " ERREUR: Répertoire source inexistant - $rep_source"
        return
    fi

    timestamp=$(date '+%d%m%Y_%H%M%S')
    backup_name="backup_${timestamp}.tar.gz"
    backup="$rep_backup/$backup_name"

    mkdir -p "$rep_backup"

    echo -e " Source : $rep_source"
    echo -e " Destination : $backup"
    echo
    read -p " Continuer ? (O/N) : " confirmation

    # Si l'utilisateur ne confirme pas avec 'O' ou 'o', annule la sauvegarde

        if [[ ! "$confirmation" =~ ^[oO]$ ]]; then
        echo -e " Sauvegarde annulée."
        log_message "Sauvegarde annulée"
                return
    fi

    echo -e " Création de la sauvegarde en cours..."
        tar -czf "$backup" "$rep_source"

        # Vérifie si la commande tar a réussi
        if [[ $? -eq 0 ]]; then
        echo -e " Sauvegarde créée avec succès !"
        echo -e " Fichier : $rep_backup"
        log_message "Sauvegarde créée : $rep_backup"
    else
        echo -e " Une erreur est survenue lors de la sauvegarde."
        log_message "ERREUR: échec de la sauvegarde $rep_backup"
    fi
}

# Fonction pour lister les sauvegardes dans le dossier backup

lister_backup() {
    ls -lh $rep_backup
        log_message "$USERS a lister les sauvegarde"
}

# Fonction pour restaurer une sauvegarde choisie par l'utilisateur

restaurer_backup() {
    echo " Quel est le backup que vous voulez restaurer ? "
        read rep
        fichier_sauvegarde="$rep"
    destination="$HOME"

    # Vérifie que le fichier de sauvegarde n'est pas vide

        if [[ -z "$fichier_sauvegarde" ]]; then
        echo "Erreur: Fichier de sauvegarde non spécifié"
                log_message " Erreur: Fichier de sauvegarde non spécifié "
        echo "Usage: restaurer_fichier <fichier_sauvegarde> [destination]"
    fi

        # Vérifie que le fichier de sauvegarde existe bien

        if [[ ! -f "$fichier_sauvegarde" ]]; then
        echo "Erreur: Fichier de sauvegarde introuvable: $fichier_sauvegarde"
                log_message "Erreur: Fichier de sauvegarde introuvable: $fichier_sauvegarde"
        exit
        fi

        echo "Restauration en cours..."
    echo "Source: $fichier_sauvegarde"
    echo "Destination: $destination"

    # Si le fichier est une archive tar.gz, on extrait, sinon on copie simplement

        if [[ "$fichier_sauvegarde" == *.tar.gz ]]; then
                tar -xzf "$fichier_sauvegarde" -C "$destination"
                echo "Restauration ok "
        else
        cp "$fichier_sauvegarde" "$destination"
        echo "Restauration ok "
        fi
}

# Fonction pour afficher le contenu du fichier log

afficher_log() {
    cat $fichier_log
}

# Fonction qui crée un fichier d’aide (help.txt) puis l’affiche

aide() {
    cat <<- EOF > help.txt
$0 v1

UTILISATION :
$0 [OPTIONS]

OPTIONS :
--help              Afficher cette aide
--version           Afficher la version
--config            Aller directement à la configuration
--backup            Lance une sauvegarde du profil qui execute le script

EXEMPLES :
$0                    # Lancer le menu interactif
$0 --backup           # Sauvegarde avec le profil par défaut
$0 --config           # Aller à la configuration
$0 --help             # Afficher l'aide

PROFILS DISPONIBLES : $(ls /home/)
EOF

cat help.txt
}

# Boucle principale du menu, tourne indéfiniment

while true; do

        # Si aucun argument n’est passé au script, affiche le menu interactif

        if [[ $# -eq 0 ]]; then
                echo -e " ╔══════════════════════════════════════════════════════════════╗ "
                echo -e " ║                             MENU                             ║ "
                echo -e " ╚══════════════════════════════════════════════════════════════╝ "
                echo
                echo -e " Choisissez une option : "
                echo
                echo -e "1. Créer une sauvegarde de votre répertoire personnel"
                echo -e "2. Lister les sauvegardes"
                echo -e "3. Restaurer une sauvegarde"
                echo -e "4. Voir les logs"
                echo -e "5. Configuration"
                echo -e "6. Aide"
                echo -e "7. Quitter"
                echo
                read -p " Votre choix : " choix
        else

                # Si un argument est passé, traite directement cet argument (option en ligne de commande)

                if [[ $1 ==  "--help" ]]; then
                        aide
                        exit
                fi

                if [[ $1 ==  "--version" ]]; then
            echo "$version"
            exit
        fi

                 if [[ $1 ==  "--config" ]]; then
            configuration
            exit
        fi

                if [[ $1 ==  "--backup" ]]; then
            creer_sauvegarde
            exit
        fi
        fi

    # Exécution des actions selon le choix dans le menu

        case $choix in
        1)
                        creer_sauvegarde
                ;;
                2)
                        lister_backup

                        ;;
                3)
                        restaurer_backup
                        ;;
        4)
                        afficher_log
                        ;;
                5)
                        configuration
                        ;;
                6)
                        aide
                        ;;
                7)
                echo " Au revoir !"
                exit 0
                ;;
        *)
                echo " Choix invalide."
                ;;
        esac
        echo ""  # ligne vide pour aérer
    read -p "Appuyez sur Entrée pour revenir au menu..."
    clear
done
