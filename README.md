# Flutter - Journey Diary

## Sommaire

1. [Définition du projet](README.md#1-définition-du-projet-)
2. [Rendu attendu](README.md#2-rendu-attendu-)
3. [Notation](README.md#3-notation-)
4. [Version Flutter/Dart](README.md#4-version-flutterdart-)
5. [Fonctionnalités](README.md#5-fonctionnalités-)
6. [API](README.md#6-api-)
7. [Contributeurs](README.md#7-contributeurs-)

## 1. Définition du projet :

- Projet en binôme
- 5 séances (35h)
- Date de rendu : 6 juillet 2023

## 2. Rendu attendu :

- Accès aux sources via GIT (GitLab, GitHub, etc.)
- Fichier readme.md avec, au minimum, les informations suivantes :
    - la version de Flutter/Dart utilisée
    - les fonctionnalités de l'application
    - les API utilisées
- Projet à rendre avant le dimanche 12 juin minuit

## 3. Notation :

Pour la notation, les éléments suivants seront pris en compte :
- Fonctionnalités présentes
- Qualité UI/Design
- Architecture de l'application
- Qualité du code
- Présence de tests

## 4. Version Flutter/Dart :

Flutter **3.10.5**
Dart SDK **3.0.5**

## 5. Fonctionnalités :

L'application possède plusieurs écrans :
- Inscription
- Connexion
- Accueil (recherche lieu/carnet de voyage)
- Ajout de voyage
- Lieu - À visiter
- Lieu - Détails

Sur l'écran d'Accueil, il y a une recherche pour trouver des lieux à partir d'une ville. En cliquant sur l'un des lieux, vous êtes redirigés sur une page qui comporte les informations du lieu. Vous avez aussi la possibilité d'ajouter un voyage à votre carnet, celui-ci s'affiche dans la page Accueil sous forme de carousel. L'application est aussi équipée d'un stockage en base de données et d'un module d'authentification via Firebase.

## 6. API :

Pour réaliser ce projet, nous avons utilisé l'API [Amadeus](https://developers.amadeus.com/self-service).
  
Étant donné que nous avons utilisé la version de test, la recherche est limitée aux villes suivantes :
- Bangalore
- Barcelona
- Berlin
- Dallas
- London
- New York
- Paris
- San Francisco

À noter, qu'il y aura un maximum de 10 points d'intérêts par ville.

## 7. Contributeurs :

Hugo TRINQUANT
Thomas SÉGALEN
