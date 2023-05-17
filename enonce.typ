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

== Objectif:
Le but des exercices de cette feuille est de réussir à créer un algorithme en Python 
permettant de reconnaître un chiffre à travers une image. #linebreak()
On implémentera ainsi différentes méthodes, plus ou moins simples,
pour ce qui est des images on pourra utiliser cette #link("https://github.com/emsquid/projet-chiffres/blob/main/chiffres.tar.gz")[#text("archive", fill: blue)].
(Pour l'extraire: ```bash tar -xzf chiffres.tar.gz```)

== Partie 1: Les k plus proches voisins
Dans cette partie on va considérer qu'une image de largeur _*l*_ et de hauteur _*h*_ peut être représentée comme un *point* appartenant à $[bold(0), bold(1)]^(bold(l) dot.op bold(h))$.
Ainsi en calculant la *distance* entre deux points, on peut obtenir une mesure de la ressemblance d'une image à une autre 
et utiliser la méthode des #link("https://fr.wikipedia.org/wiki/M%C3%A9thode_des_k_plus_proches_voisins")[#text("k plus proches voisins.", fill: blue)]
+ Tout d'abord on aura besoin d'une fonction pour lire une image depuis un fichier, 
  on pourra par exemple utiliser la classe ```python Image``` de la librairie ```python PIL```. #linebreak()
  (Pour l'installer: ```bash pip3 install Pillow```)
+ Ensuite il faut une fonction pour passer d'une image à un point, 
  on pourra le représenter comme une matrice de pixel de taille $bold(l) dot.op bold(h)$, par exemple avec la librairie ```python numpy```. #linebreak()
  On trouvera aussi un moyen pour transformer les couleurs en une valeur dans $[bold(0), bold(1)]$.
+ Puis on va créer une fonction pour calculer la distance entre deux points de $[bold(0), bold(1)]^(bold(l) dot.op bold(h))$.
  On pourra appliquer la formule de la distance euclidienne de la même manière que dans l'espace, ou une autre si vous trouvez plus intéressant. #linebreak()
  (Remarque: pour les performances on pourra enlever la racine carré dans la formule de la distance euclidienne qui n'est pas nécessaire ici)
+ Enfin on crée une fonction pour reconnaître un chiffre depuis une image, 
  pour ça on peut trouver les *k* images les plus ressemblantes parmi les références et en déduire le chiffre. #linebreak()
  (Remarque: pour lister tous les fichiers d'un répertoire on pourra utiliser la fonction ```python listdir(repertoire)``` de la librairie ```python os```)

== Partie 2: Un réseau neuronal
TODO

