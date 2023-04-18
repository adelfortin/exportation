#!/bin/bash

# Variables liées en majuscules
CHEMIN_SCRIPT=$(realpath $0)
TERMINAL_PAR_DEFAUT=xterm

# Fonction pour lancer le script dans un terminal
function lancer_dans_terminal {
if [[ -n "$1" ]]; then
TERMINAL=$1
else
TERMINAL=$TERMINAL_PAR_DEFAUT
fi
echo "Lancement du script dans le terminal $TERMINAL"
if [[ ! -x "$(command -v $TERMINAL)" ]]; then
echo "Erreur : le terminal $TERMINAL n'est pas disponible."
exit 1
fi
$TERMINAL -e "$CHEMIN_SCRIPT"
}

# Fonction pour redémarrer la machine
function redemarrer_machine {
echo "Redémarrage de la machine..."
if [[ $(id -u) -ne 0 ]]; then
echo "Erreur : cette action nécessite des privilèges d'administrateur."
exit 1
fi
shutdown -r now
}

# Fonction pour afficher l'utilisation du script
function usage {
echo "Usage: $0 [-t <terminal>] [-r]"
echo ""
echo "Options :"
echo "-t, --terminal <terminal> : Lancer le script dans le terminal spécifié"
echo "-r, --reboot : Redémarrer la machine"
}

# Traitement des arguments en ligne de commande
while [[ "$#" -gt 0 ]]; do
case $1 in
-t|--terminal) TERMINAL=$2; shift ;;
-r|--reboot) redemarrer_machine; exit 0 ;;
-h|--help) usage; exit 0 ;;
*) echo "Option non valide : $1"; usage; exit 1 ;;
esac
shift
done

# Appel de la fonction pour lancer le script dans un terminal
lancer_dans_terminal $TERMINAL_PAR_DEFAUT
