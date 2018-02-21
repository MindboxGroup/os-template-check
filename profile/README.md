# InSpec Profile

Ten profil InSpec służy do testowania szablonu aplikacji dla openshift.

# Kontrola

W katalogu [`controls`](controls) znajdują się pliki z definicją kontroli jaka jest przeprowadzana na szablonie. Poniżesz można znaleźć tabele z listą kontroli oraz ich opisem.

 Nazwa kontroli | Opis
-----------------|-----
 [`basic`](controls/basic.rb) | testuje czy podany plik jest faktycznie szablonem dla openshift
 [`health_check`](controls/health_check.rb) | testuje czy kontener aplikacji zawiera `livenessProbe` oraz `readinessProbe`
 [`parameters`](controls/parameters.rb) | testuje czy szablon zawiera wymagane parametry
 [`resources`](controls/resources.rb) | testuje czy kontener ma ustawione zasoby jakie są wymagane przez aplikacje
 [`route`](controls/route.rb) | testuje czy zasób `route` nie zawiera błędów
 [`service`](controls/service.rb) | testuje czy zasób `service` nie zawiera błędów

## basic

Kontrola `basic` sprawdza czy podany plik jest szablonem aplikacji dla openshift. 

```yaml
apiVersion: v1 # wersja api musi być 'v1'
kind: Template # kind musi być 'Template'
metadata:
  name: our_application # nazwa szablonu nie może być pusta
```

## health_check

Kontrola `health_check` sprawdza czy kontener zawiera check `livenessProbe` oraz `readinessProbe`.

```yaml
[...]
          livenessProbe:
            failureThreshold: 3 # wartość musi być większa od 0
            httpGet:
              path: /healthcheck
              port: 8080
              scheme: HTTP
            initialDelaySeconds: 180 # wartość musi być większa od 0
            periodSeconds: 10 # wartość musi być większa od 0
            successThreshold: 1 # wartość musi być większa od 0
            timeoutSeconds: 1 # wartość musi być większa od 0
          readinessProbe:
            failureThreshold: 3 # wartość musi być większa od 0
            httpGet:
              path: /healthcheck
              port: 8080
              scheme: HTTP
            initialDelaySeconds: 60 # wartość musi być większa od 0
            periodSeconds: 10 # wartość musi być większa od 0
            successThreshold: 1 # wartość musi być większa od 0
            timeoutSeconds: 1 # wartość musi być większa od 0
[...]
```

### Biblioteka

Do kontroli jest używana metoda `check` która znajduje się w bibliotece [`libraries/livenessprobe.rb`](libraries/livenessprobe.rb).

```ruby
# wywołanie metody

describe livenessprobe(container['livenessProbe']) do
  its('check') { should cmp true }
end
```

## parameters

Kontrola `parameters` sprawdza czy szablon zawiera wymagane parametry oraz czy parametry spełniają wymagania.

```yaml
parameters:
  - name: PROJECT # nazwa nie może być pusta
    description: "Name of this project" # opis nie może być pusty
```

### Sprawdzanie wymaganych parametrów 

W celu przeprowadzania kontroli czy szablon zawiera wymagany parametr, trzeba pierw nazwę takiego parametru dodać do listy w pliku [`controls/parameters.rb`](controls/parameters.rb).

```ruby
# controls/parameters.rb

  required_parameters = [
    'PROJECT',
  ]
```

W powyższym przykładzie wymagamy aby szablon zawierał parametr `PROJECT`.

### Biblioteka

Do sprawdzenia czy wymagany parametr jest zawarty w szablonie, używana jest metoda `required_parameters` która znajduje się w klasie `ParametersTemplate`. Klasa zdefiniowana jest w pliku [`libraries/parameters.rb`](libraries/parameters.rb)

```ruby
# wywołanie metody

# metoda parameters jako pierwszy argument przyjmuje parametry szablonu
# drugi argument to tablica z parametrami które są wymagane
describe parameters(template['parameters'], required_parameters) do
  its('required_parameters') { should cmp true }
end
```

## resources

Kontrola `resources` sprawdza czy kontener ma ustawione zasoby jakie wymaga do działania oraz limity. 

```yaml
[...]
          resources:
            requests:
              memory: "0.5G" # nie może być pusta
              cpu: "0.2" # musi być >= 0.1
            limits:
              memory: "0.5G" # nie może być pusta
[...]
```

## route

Kontrola `route` sprawdza czy `Route` spełnia wymagania. Kontrola jest przeprowadzana tylko w momencie kiedy zasób znajduje się w szablonie. 

```yaml
- apiVersion: v1 # musi być 'v1'
  kind: Route
  metadata:
    labels:
      app: app_name
      area: area_name
      stack: stack_name
    name: app # nazwa nie moży być pusta
  spec:
    port:
      targetPort: 8080-tcp # nie może być puste
    tls:
      termination: edge # musi być 'edge'
    to:
      kind: Service # musi być 'Service'
      name: app_name # nie może być puste
      weight: 100 # musi być > 0
     wildcardPolicy: None
```

## service 

Kontrola `service` sprawdza czy `Service` spełnia wymagania. Kontrola jest przeprowadzana tylko w momencie kiedy zasób znajduje się w szablonie.

```yaml
- apiVersion: v1 # musi być v1
  kind: Service
  metadata:
    labels:
      app: app_name
      stack: stack_name
    name: app_name # nie może być puste
  spec:
    ports:
    - name: 8080-tcp # nie może być puste 
      port: 8080 # nie może być puste
      protocol: TCP # wartość musi być /UDP|TCP/
      targetPort: 8080 # nie może być puste
    selector: # selector musi być zdefiniowany
      app: app_name
      deploymentconfig: app_name
      stack: stack_name
    sessionAffinity: None
    type: ClusterIP # wartość musi spełniać warunek /ClusterIP|LoadBalancer|NodePort|ExternalName/
```
