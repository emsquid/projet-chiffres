#let project(title: "", authors: (), body) = {
  set document(author: authors, title: title)
  set page(numbering: "1", number-align: center)
  set text(font: "New Computer Modern", lang: "fr")
  set par(justify: true)
  show math.equation: set text(weight: 400)

  align(center)[#block(text(weight: 700, 1.75em, title))]
  linebreak()
  body
}

#show: project.with(
  title: "Reconnaissance de chiffres en Python",
  authors: ("Emanuel", "David", "Elise"),
)

== Objectif :
Le but des exercices de cette feuille est de réussir à créer un algorithme en Python 
permettant de reconnaître un chiffre à travers une image. \
On implémentera ainsi différentes méthodes, plus ou moins simples,
pour ce qui est des images on pourra utiliser cette 
#link("https://github.com/emsquid/projet-chiffres/blob/main/chiffres.tar.gz")[#text("archive", fill: blue)].
(Pour l'extraire : ```bash tar -xzf chiffres.tar.gz```)

== Préparation :
Avant de reconnaître des chiffres on doit pouvoir lire des images en Python.
+ Tout d'abord on aura besoin d'une fonction pour lire une image depuis un fichier, 
  on pourra par exemple utiliser la classe ```python Image``` de la librairie ```python PIL```. \
  (Pour l'installer : ```bash pip3 install Pillow```) 
+ Ensuite il faut une fonction pour passer d'une image à un élément simple à manipuler, 
  on pourra la représenter comme une *matrice* de pixel 
  de taille $(1, bold(l) dot.op bold(h))$, 
  par exemple avec la librairie ```python numpy```. 
  On devra aussi transformer les couleurs 
  en une valeur dans $[bold(0), bold(1)]$. \ 
  (Remarque : On fera attention à ce que notre matrice soit bien 
  en 2 dimensions pour pouvoir utiliser le produit matriciel)
+ Enfin on pourra faire une fonction pour récupérer une liste contenant 
  tous les couples de références `(image, chiffre)` depuis un répertoire. \
  (Remarque: pour lister tous les fichiers d'un répertoire on pourra utiliser 
  la fonction ```python listdir(repertoire)``` de la librairie ```python os```)

== Partie 1 : Les k plus proches voisins
Dans cette partie on va considérer qu'une image de largeur _*l*_ et de hauteur _*h*_ 
peut être représentée comme un *point* ou un *vecteur* 
appartenant à $[bold(0), bold(1)]^(bold(l) dot.op bold(h))$.
Ainsi en calculant la *distance* entre deux points 
ou le *produit scalaire* de deux vecteurs, 
on peut obtenir une mesure de la ressemblance d'une image à une autre 
et utiliser la méthode des 
#link("https://fr.wikipedia.org/wiki/M%C3%A9thode_des_k_plus_proches_voisins")[#text("k plus proches voisins.", fill: blue)]
+ D'abord on crée une fonction pour calculer la *distance* 
  entre deux points de $[bold(0), bold(1)]^(bold(l) dot.op bold(h))$. \
  On pourra appliquer la formule de la distance euclidienne 
  de la même manière que dans l'espace, 
  ou une autre si vous trouvez plus intéressant. \
  (Remarque : pour les performances on pourra enlever la racine carré dans
  la formule de la distance euclidienne qui n'est pas nécessaire ici)
+ On fera aussi une fonction pour calculer le *produit scalaire* de deux vecteurs de $[bold(0), bold(1)]^(bold(l) dot.op bold(h))$.
  Encore une fois, la formule s'applique de la même manière que dans l'espace.
+ Enfin on crée une fonction pour reconnaître un chiffre depuis une image,
  pour ça on peut trouver les *k* images parmi les références 
  dont les points sont les *moins distants*, 
  ou dont les vecteurs se *ressemblent le plus*,
  et en déduire le chiffre. \
  On pourra comparer les deux méthodes et voir laquelle fonctionne le mieux. \
  

== Partie 2: Un réseau neuronal
TODO

