# Flutter - Journey Diary

## Sommaire

1. [Définition du projet](README.md#1-définition-du-projet-)
2. [Rendu attendu](README.md#2-rendu-attendu-)
3. [Notation](README.md#3-notation-)
4. [Version Flutter/Dart](README.md#4-version-flutterdart-)
5. [Fonctionnalités](README.md#5-fonctionnalités-)
6. [API](README.md#6-api-)
7. [Utilisation](README.md#7-utilisation-)
8. [Contributeurs](README.md#8-contributeurs-)

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

- Auth/Inscription
- Auth/Connexion
- Auth/Mot de passe oublié
- Notebook/Accueil (recherche de lieux / carnet de voyage)
- Notebook/Détails (informations sur les lieux du carnet de voyage)
- Notebook/Ajout de voyage (création de lieu du carnet de voyage)
- Notebook/Liste de lieux à visiter (mémo)
- Google/Détails (informations sur le lieu de la recherche)
- Google/À visiter (liste des points d'intérêt proches de la recherche)
- Google/À visiter/Détails (informations sur le point d'intérêt)

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

## 7. Utilisation :

Exécuter les commandes suivantes :
> flutter pub get  
> flutter run

Compte utilisateur test :
Adresse e-mail - test@jd.com
Mot de passe - test123

## 8. Contributeurs :

Hugo TRINQUANT  
Thomas SÉGALEN
