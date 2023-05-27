#let project(title: "", authors: (), body) = {
  set document(author: authors, title: title)
  set page(numbering: "1", number-align: center)
  set text(font: "New Computer Modern", lang: "fr")
  set par(justify: true)

  show list: set block(below: 1pt)
  show math.equation: set text(weight: 400)
  show raw.where(block: false): box.with(
    fill: luma(240),
    inset: (x: 3pt, y: 0pt),
    outset: (y: 3pt),
    radius: 2pt,
)

  align(center)[#block(text(weight: 700, 1.75em, title))]
  linebreak()
  body
}

#show: project.with(
  title: "Reconnaissance de chiffres en Python",
  authors: ("Emanuel", "David"),
)

== Objectif :
Le but des exercices de cette feuille est de réussir à créer un algorithme en Python 
permettant de reconnaître un chiffre à travers une image. \
On implémentera ainsi différentes méthodes, plus ou moins simples,
pour ce qui est des images on pourra utiliser cette 
#link("https://github.com/emsquid/projet-chiffres/blob/main/chiffres.tar.gz")[#text("archive", fill: blue)].
(Pour l'extraire : ```bash tar -xzf chiffres.tar.gz```)

== Préparation :
Avant de reconnaître des chiffres on doit pouvoir lire et manipuler des images en Python. 
Dans toute la feuille on considére une image de largeur _*l*_ et de hauteur _*h*_.

+ Tout d'abord on aura besoin d'une fonction pour lire cette image depuis un fichier, 
  on pourra par exemple utiliser la classe ```python Image``` de la librairie ```python PIL```. \
  (Pour l'installer : ```bash pip3 install Pillow```) 

+ Ensuite il faut une fonction pour passer de l'image à un objet plus simple à manipuler, 
  on pourra la représenter comme une *matrice* de pixels 
  de taille $1 times bold(l) dot.op bold(h)$, par exemple avec la librairie ```python numpy```. 
  On devra aussi transformer les couleurs en une valeur dans $[bold(0), bold(1)]$. \ 
  (Remarque : On fera attention à ce que notre matrice soit bien 
  en 2 dimensions pour pouvoir utiliser le produit matriciel correctement)

+ Enfin on pourra faire une fonction pour récupérer une liste contenant 
  tous les couples de référence `(image, chiffre)` depuis un répertoire. \
  (Remarque : pour lister tous les fichiers d'un répertoire on pourra utiliser 
  la fonction ```python listdir(repertoire)``` de la librairie ```python os```)

== Partie 1 : Les k plus proches voisins
Dans cette partie on va considérer une image comme un *point* ou un *vecteur* 
de $[bold(0), bold(1)]^(bold(l) dot.op bold(h))$.
Ainsi en calculant la *distance* entre deux points ou le *produit scalaire* de deux vecteurs, 
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

+ On fera aussi une fonction pour calculer le *produit scalaire* 
  de deux vecteurs de $[bold(0), bold(1)]^(bold(l) dot.op bold(h))$.
  Encore une fois, la formule s'applique de la même manière que dans l'espace.

+ Enfin on peut créer une fonction pour reconnaître un chiffre depuis une image,
  pour ça on peut trouver les *k* images parmi les références 
  dont les points sont les *moins distants*, 
  ou dont les vecteurs se *ressemblent le plus*,
  et en déduire le chiffre. \
  On pourra comparer la méthode avec la distance et celle avec le produit scalaire
  pour voir laquelle fonctionne le mieux. \

== Partie 2 : Base d'un réseau neuronal
Dans cette partie on va toujours utiliser l'image comme une matrice _*m*_,
et on va vouloir calculer à partir de cette matrice une matrice de taille $1 times 10$, 
$bold(p) = mat(p_0, p_1, ..., p_8, p_9;)$,
où $p_n in [0, 1]$ représente la probabilité que $n$ soit le chiffre de l'image. \
Pour ça on va utiliser deux matrices, 
une matrice de poids _*W*_ de taille $bold(l) dot.op bold(h) times 10$ 
et une matrice de biais _*b*_ de taille $1 times 10$. \

1. On peut utiliser le module ```python random``` de la librairie ```python numpy```
  pour initialiser *W* et *b* avec des distributions aléatoires, 
  par exemple une distribution uniforme entre -1 et 1, à vous de trouver la meilleure.

Vous pouvez remarquer qu'en utilisant l'application affine 
$bold(p) = bold(m) dot.op bold(W) + bold(b)$
on peut obtenir la taille voulue pour *p*. 

2. On fait donc une fonction pour calculer ce résultat, 
  on pensera à faire attention à bien utiliser le produit matriciel 
  et à la taille de la matrice de sortie.

Mais on a un premier problème, les valeurs de *p* ne sont pas dans l'intervalle $[0, 1]$
et ne s'apparentent pas à des probabilités.

3. Pour régler ça, on peut utiliser la fonction 
  #link("https://fr.wikipedia.org/wiki/Sigmo%C3%AFde_(math%C3%A9matiques)")[#text("sigmoïde", fill: blue)]
  dont l'expression est $sigma(x) = 1 / (1 + e^(-x))$
  et l'appliquer à nos prédictions *p*.

En plus, dans ce calcul *W* et *b* ne nous apportent pour l'instant aucune information, 
il va falloir que notre réseau apprenne de ses erreurs.
Pour ça on va utiliser une 
#link("https://fr.wikipedia.org/wiki/Fonction_objectif")[#text("fonction objectif", fill: blue)],
ce type de fonction permet d'évaluer la qualité de nos prédictions, 
et on modifiera nos paramètres *W* et *b* en se basant sur sa dérivée. \
(Remarque : on s'intéresse à la dérivée car le but est de trouver un minimum,
ce qui revient à avoir fait une bonne prédiction)

4. Ici on va utiliser la fonction d'#link("https://fr.wikipedia.org/wiki/Erreur_quadratique_moyenne")[#text("erreur quadratique moyenne", fill: blue)],
  pour faire simple sa dérivée est
  $Delta(bold(p)) = bold(p) - mat(0, ..., 0, 1, 0, ..., 0;)$ 
  avec le 1 à l'indice $n$, où $n$ est le chiffre à prédire. 
  Vous pourrez essayer d'en trouver une meilleure.
  
Après l'avoir implémenter, on veut propager le résultat $Delta$ 
en retournant en arrière dans notre réseau neuronal. 

5. Pour ça on fait une fonction qui calcule la dérivée de la fonction sigmoïde en $bold(p)$ 
  et multiplie $Delta$ par le résultat terme à terme. \   
  (Remarque : si on voulait retourner plus en arrière 
  on pourrait continuer avec la dérivée de l'application affine
  $bold(m) dot.op bold(W) + bold(b)$)

Tout en propageant le résultat, on veut aussi améliorer *W* et *b*, 
on va pouvoir utiliser $Delta$ que l'on a calculé.

6. On crée une fonction pour modifier nos deux paramètres : 
  - Le changement que reçoit *b* est simplement $bold(b) arrow.l bold(b) - alpha dot.op Delta$
  - Le changement que reçoit *W* est donné par $bold(W) arrow.l bold(W) - alpha dot.op bold(m)^t dot.op Delta$
  Où $alpha in [0, 1]$ représente la *vitesse d'apprentissage*,
  et $bold(m)^t$ est la transposée (pour que le produit matriciel soit possible).

7. Avec tout ça on peut faire une fonction intermédiaire pour s'entraîner sur une image, 
  on commence par calculer une prédiction $bold(p) = sigma(bold(m) dot.op bold(W) + bold(b))$,
  puis on lui applique $Delta$ avant de retourner en arrière et d'ajuster nos paramètres. 

En répétant cette opération pour plusieurs images 
on améliore petit à petit nos paramètres et nos prédictions deviennent meilleures.

8. Pour terminer on peut donc faire une fonction qui s'entraînent sur un ensemble d'images, 
  on peut répéter plusieurs fois en mélangeant les images
  et calculer le pourcentage de réussite pour chaque génération sur des images de test.

En fonction de l'ensemble de base utilisé on peut rapidement arriver entre 80% et 90% de prédictions réussites.
En bonus on peut essayer de sauvegarder nos paramètres *W* et *b* lorsque le pourcentage de réussite augmente.

== Partie 3 : TODO
