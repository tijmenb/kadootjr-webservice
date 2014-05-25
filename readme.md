# Kadootjr webservice

## `GET /v1/lists`

Returns alle lijsten voor Kadootjr.

#### Data

```json
  [
    {
      "id": "vriendje",
      "name": "Vriend",
      "url": "http://api.kadootjr.nl:80/v1/lists/vriendje"
    },
    ...
    {
      "id": "vriendinnetje",
      "name": "Vriendin",
      "url": "http://api.kadootjr.nl:80/v1/lists/vriendinnetje"
    },
  ]
```

#### List object

Key | Value | Desc
------------- | ------------- | -------------
`id` | string | ID van de lijst, blijft altijd hetzelfde
`name` | string | blijft altijd hetzelfde
`url` | url | API URL van de lijst, voor development.

## `GET /v1/lists/:id?page=0&limit=25`

Returns alle producten in een bepaalde lijst.

#### Data

```json
[
  {
    "id": "9200000016123356",
    "title": "The Rosie Project",
    "description": "The Rosie Project by Graeme Simsion is a story about love, life and lobsters..<br/><br/>Meet Don Tillman.<br/><br/>Don is getting married.<br/><br/>He just doesn't know who to yet.<br/><br/>But he has designed a very detailed questionnaire to help him find the perfect woman.<br/><br/>One thing he already knows, though, is that it's not Rosie.<br/><br/>Absolutely, completely, definitely not.<br/><br/>Don Tillman is a socially challenged genetics professor who's decided the time has come to find a wife. His questionnaire is intended to weed out anyone who's unsuitab...",
    "price": 10.0,
    "url": "http://tips.kadootjr.nl/2il4lnsmzmk",
    "image_url": "http://s.s-bol.com/imgbase0/imagebase/large/FC/6/5/3/3/9200000016123356.jpg"
  },
  {
    "id": "9200000017128168",
    "title": "Oud Hollands Keezenspel",
    "description": "Oud Hollands Keezenspel<br/>Het gezelligste bord- én kaartspel van Holland!<br/>Het spel Ontdek het originele Oud Hollandse gezelschapspel: KEEZEN!<br/><br/>Keezen is een combinatie van pesten en Mens Erger Je Niet. <br/>De speelkaart die je opgooit, bepaalt wat je met je pion mag doen. Zorg dat je je pionnen als eerste op de thuishonken hebt en probeer met pestkaarten te voorkomen dat je tegenspelers hetzelfde doel bereiken. <br/>Lukt het jou om als eerste al je pionnen op de juiste plaats te krijgen?<br/>Het Keezenspel kun je a...",
    "price": 14.99,
    "url": "http://tips.kadootjr.nl/2il4lnt8iy0",
    "image_url": "http://s.s-bol.com/imgbase0/imagebase/large/FC/8/6/1/8/9200000017128168.jpg"
  },
  ...
]
```

#### Product object

Key | Value | Desc
------------- | ------------- | -------------
`id` | string | Bol.com ID van het product
`title` | string | Titel van product
`description` | string | Omschrijving van product van Bol. Zit tjokvol HTML-troep.
`price` | float | Meest actuele prijs van Bol.
`url` | url | Affiliate URL naar de Kadootjr-redirector
`image_url` | url | URL van de grootst mogelijke afbeelding bij Bol. Geen garanties over size/kwaliteit.


#### Params

Param | Desc
------------- | -------------
`page` (optional, default: 0) | Welke pagina
`limit` (optional, default: 25) | Hoeveel resultaten

#### Kadootjr-redirector URL

`tips.kadootjr.nl` stuurt users direct door naar Bol.com, met de goede affiliate-link. Om onderscheid te maken in de affiliate-inkomsten, krijgt een de links een suffix met de afzender.

Dit zijn de opties:

```sh
http://tips.kadootjr.nl/2il4lnt8iy0-s # afkomstig van de website
http://tips.kadootjr.nl/2il4lnt8iy0-i # afkomstig van iOS app
http://tips.kadootjr.nl/2il4lnt8iy0-a # afkomstig van Android app
http://tips.kadootjr.nl/2il4lnt8iy0-w # afkomstig van Windows Phone app
```

Als er geen suffix aanwezig is, wordt de user geredirect met de identifier `other` en weten we niet waar het vandaan komt.


## `POST /swipes`

Stuur een array van swipes voor analytics en updaten van ranglijsten.

De POST body die je opstuurt:

```json
{ "swipes": [{ "group_id" : "vriendje", "product_id": "9200000017128168", "direction": "rejected" }, { "group_id" : "vriendje", "product_id": "9200000017128168", "direction": "rejected" }]}
```

Alles goed? Dan krijg je `200` en `{ "message": "OK" }` terug.

#### Params voor een swipe object

Param | Type | Desc
------------- | ------------- | -------------
`group_id` | string | De ID van de lijst/groep (eg. `oma`, `opa`, `vriendje`)
`product_id` | string | Bol.com product ID
`direction` | string | `added` of `rejected`
