#let project(title: "", authors: (), body) = {
  set document(author: authors, title: title)
  set page(numbering: "1", number-align: center)
  set text(font: "New Computer Modern", lang: "fr")
  set par(justify: true)

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
  de la forme $(1, bold(l) dot.op bold(h))$, par exemple avec la librairie ```python numpy```. 
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

#pagebreak()

== Partie 2 : Un réseau neuronal basique
Dans cette partie on va toujours utiliser l'image sous forme d'une matrice _*m*_,
et on va vouloir calculer à partir de cette matrice un vecteur de taille 10, 
$bold(p) = mat(p_0, p_1, ..., p_8, p_9;)$,
où $p_n in [0, 1]$ représente la probabilité que $n$ soit le chiffre de l'image. \
Pour ça on va utiliser deux matrices, 
une matrice de poids _*W*_ de la forme $(bold(l) dot.op bold(h), 10)$, 
et une matrice de biais _*b*_ de la forme $(1, 10)$. \

1. On peut utiliser le module ```python random``` de la librairie ```python numpy```
  pour initialiser *W* et *b* avec des distributions aléatoires, 
  par exemple une distribution uniforme entre -1 et 1, à vous de trouver le mieux.

Vous pouvez remarquer qu'en faisant $bold(p) = bold(m) dot.op bold(W) + bold(b)$
on peut obtenir la forme voulue. 

2. On fait donc une fonction pour calculer ce résultat, 
  on pensera à faire attention à la forme de la matrice de sortie.

Mais il y a deux problèmes, d'abord les valeurs de *p* ne sont pas dans l'intervalle $[0, 1]$,
et en plus en faisant ce calcul *W* et *b* ne nous apportent aucune information. 

3. Pour régler le premier problème, on peut utiliser la fonction 
  #link("https://fr.wikipedia.org/wiki/Sigmo%C3%AFde_(math%C3%A9matiques)")[#text("sigmoïde", fill: blue)]
  dont l'expression est $sigma(x) = 1 / (1 + e^(-x))$

Pour régler le deuxième problème il va falloir que notre programme apprenne de ses erreurs.
Pour ça on va utiliser une 
#link("https://fr.wikipedia.org/wiki/Fonction_objectif")[#text("fonction objectif", fill: blue)],
cette fonction permet d'évaluer la qualité de nos prédictions, 
et on modifiera nos poids *W* et nos biais *b* en fonction.

4. Ici on va utiliser la fonction d'#link("https://fr.wikipedia.org/wiki/Erreur_quadratique_moyenne")[#text("erreur quadratique moyenne", fill: blue)],
  pour faire simple ce qui nous intéresse est sa dérivée
  $Delta(bold(p)) = bold(p) - mat(..., 0, 1, 0, ...;)$ 
  avec le 1 à l'indice $n$, le chiffre à prédire. 
  Après l'avoir implémenter, on pourra propager le résultat en arrière pour ajuster *W* et *b*.

Pour apprendre en évitant de faire trop de calculs, 
on fait un certains nombre de prédictions pour des matrices $bold(m_k)$
pour lesquels on calcule $Delta_k$ avant de définir $Delta bold(W)$ et $Delta bold(b)$ comme suit :
$ Delta bold(W) &= sum_(k=1)^10 bold(m_k)^t dot.op Delta_k \
  Delta bold(b) &= sum_(k=1)^10 Delta_k $
Ici on a fait 10 prédictions, avec $bold(m_k)^t$ la transposée.

5. Ainsi pour revenir en arrière on fait une fonction qui 
  multiplie d'abord chaque terme de $Delta_k$ 
  par ceux de la *dérivée* de la fonction sigmoïde appliquée à $bold(m_k) dot.op bold(W) + bold(b)$,   
  puis ajoute respectivement $bold(m_k)^t dot.op Delta_k$ et $Delta_k$  
  à $Delta bold(W)$ et $Delta bold(b)$.

6. Ensuite on peut faire une fonction pour mettre à jour *W* et *b* 
  en leur soustrayant respectivement $alpha dot.op Delta bold(W)$ et $alpha dot.op Delta bold(b)$,
  où $alpha$ représente la *vitesse d'apprentissage* (on pourra prendre un nombre entre 0 et 1)

7. Avec tout ça on peut faire une fonction intermédiaire pour s'entraîner sur un groupe d'images, 
  pour chaque image
  on commence par calculer une prédiction $bold(p) = sigma(bold(m) dot.op bold(W) + bold(b))$,
  puis on lui applique $Delta$ avant de retourner en arrière pour ajuster nos paramètres. 

#pagebreak()

En répétant cette opération pour plusieurs groupes d'images 
on améliore petit à petit nos paramètres et nos prédictions deviennent meilleures.

7. Pour terminer on peut donc faire une fonction qui s'entraînent sur un ensemble d'images
  en les séparant en petits groupes, on peut répéter cet entraînement plusieurs fois 
  et calculer le pourcentage de réussite pour chaque génération sur des images de test.

En fonction de l'ensemble de base utilisé on peut rapidement arriver à 80\~90% de prédictions réussites.
En bonus on peut essayer de sauvegarder nos paramètres *W* et *b* lorsque le pourcentage de réussite augmente.
