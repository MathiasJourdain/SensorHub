# SensorHub

## Lancer l’application

```powershell
flutter.bat run --dart-define=SIMULATE_ERROR=false
```

Le chargement simulé dure trois secondes. Pour afficher une erreur au premier
chargement et réussir après avoir appuyé sur « Réessayer », lancez :

```powershell
flutter.bat run --dart-define=SIMULATE_ERROR=true
```

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
