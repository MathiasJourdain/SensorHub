# SensorHub

## Lancer l’application

```powershell
flutter.bat run
```

Le premier chargement simulé dure trois secondes puis affiche une erreur.
Appuyez sur « Réessayer » pour relancer le chargement et afficher les capteurs.
Les tentatives suivantes réussissent. Aucun `--dart-define` n’est nécessaire.

Les actualisations sont sérialisées dans le ViewModel : les demandes faites
pendant un chargement en cours sont ignorées. Le FakeRepository expose son
compteur `loadCount` pour vérifier le nombre d’appels effectués.

Le tableau de bord affiche l’heure de la dernière actualisation réussie et
signale les données comme anciennes après 30 secondes. Une erreur ne remplace
pas l’heure du dernier succès.

## Tests

```powershell
flutter.bat test
```
