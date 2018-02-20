# Szablon aplikacji

Poniższe repozytorium zawiera template aplikacji oraz profil InSpec do testowania template. 

## Szablon aplikacji oraz jego testowanie

Szablon w zależności od aplikacji może się znacząco różnić, dlatego najlepszą metodą na testowanie szablonu jest sprawdzanie czy zawiera on elementy które są wymagane lub pożądane.
W tym celu jest używane narzędzie InSpec które umożliwia przeprowadzenie testów takiego szablonu aplikacji. 

### Testowanie szablonu

W katalogu `app` znajduje się plik [`template.yaml`](app/template.yaml) który można traktować jako szablon wyjściowy dla aplikacji. W przypadku kiedy chcemy przetestować nasz szablon, musi się on znaleźć pod ścieżka `app/template.yaml`.

Do przeprowadzenia testów jest również wymagane narzędzie [InSpec](https://www.inspec.io/downloads/).

Uruchomienie testów wykonujemy poprzez wydanie komendy `inspec exec profile`

```bash
~# inspec exec profile

Profile: InSpec Profile (openshift_template)
Version: 0.1.0
Target:  local://

  ✔  health_check: Verify health checks
     ✔  livenessprobe check should cmp == true
     ✔  readinessprobe check should cmp == true
  ✔  resources: Verify whether container has had set resources
     ✔  {"requests"=>{"memory"=>"0.5G", "cpu"=>"0.2"}, "limits"=>{"memory"=>"0.5G"}} ["requests", "cpu"] should cmp >= 0.1

[...]

Profile Summary: 6 successful controls, 0 control failures, 0 controls skipped
Test Summary: 30 successful, 0 failures, 0 skipped
```

### Co jest sprawdzane podczas testów?

 Nazwa kontroli | Opis
-----------------|-----
 [`basic`](profile/controls/basic.rb) | testuje czy podany plik jest faktycznie szablonem dla openshift
 [`health_check`](profile/controls/health_check.rb) | testuje czy kontener aplikacji zawiera `livenessProbe` oraz `readinessProbe`
 [`parameters`](profile/controls/parameters.rb) | testuje czy szablon zawiera wymagane parametry
 [`resources`](profile/controls/resources.rb) | testuje czy kontener ma ustawione zasoby jakie są wymagane przez aplikacje
 [`route`](profile/controls/route.rb) | testuje czy zasób `route` nie zawiera błędów
 [`service`](profile/controls/service.rb) | testuje czy zasób `service` nie zawiera błędów
