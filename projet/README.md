### ENS Paris-Saclay, cours de Langages Formels
# Projet Analyse syntaxique
## Maena QUEMENER & Erwann LOULERGUE

### Travail effectué
Nous avons atteint le niveau 1. Nous avons donc implémenté une grammaire, ainsi qu'un _"pretty print"_ des variables (sous forme naturelle de liste chaînée), des processus (la profondeur de l'arbre étant représentée par des tabulations), et des spécifications. \
Le _pretty print_ est fait à partir des données générées par le parser et non durant la lecture.
![image](https://user-images.githubusercontent.com/93213861/168488774-7b967375-8178-421c-b429-fe3b6aeabb1c.png)


### Travail restant
L'arbre syntaxique actuel est équivalent au programme donné, comme on peut voir lors de l'impression. Cependant pour pouvoir simuler une exécution, il faudrait faire un parcours de l'arbre, et vérifier à ce moment-là si le programme est bien formé. Comme notre analyse est lexicale seulement, on ne peut pas encore repérer des problèmes comme l'utilisation d'une variable non déclarée. \
Ce parcours passerait par des fonctions d'évaluation des expressions, et surtout des fonctions "étape" pour avancer dans les statements les uns après les autres. Pour les choix, si plusieurs sont possibles, on tirerait au hasard uniformément lequel on effectue. \
Pour vérifier les spécifications, on aurait par exemple une fonction `do_one` qui exécuterait un statement dans un des processus, et qui vérifie les spécifications ensuite. L'exécution répétée de cette fonction permettrait la simulation d'une exécution du programme. \
Pour savoir ou on en est, il faudrait par exemple dans la structure `stmt` un champ booléen `here` qui vaut `1` si le statement est le prochain à exécuter et `0` sinon.
