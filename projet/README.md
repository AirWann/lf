### ENS Paris-Saclay, cours de Langages Formels
# Projet Analyse syntaxique
## Maena QUEMENER & Erwann LOULERGUE

### Travail effectué
Nous avons atteint le niveau 1. Nous avons donc implémenté une grammaire, ainsi qu'un _"pretty print"_ des variables (sous forme naturelle de liste chaînée), des processus (la profondeur de l'arbre étant représentée par des tabulations), et des spécifications. \
Le _pretty print_ est fait à partir des données générées par le parser et non durant la lecture.

### Travail restant
L'arbre syntaxique actuel est équivalent au programme donné, comme on peut voir lors de l'impression. Cependant pour pouvoir simuler une exécution, il faudrait faire un parcours de l'arbre, et vérifier à ce moment-là si le programme est bien formé. Comme notre analyse est lexicale seulement, on ne peut pas encore repérer des problèmes comme l'utilisation d'une variable non déclarée. Ce parcours passerait par des fonctions 