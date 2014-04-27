## Kadootjr webservice

- Cron job haalt voor de ingestelde categorieen alle producten binnen,
  en update de "product:id" hashes, voegt ze toe aan de sorted set van
  de categorie "category:id:ranking".

- De categorieen kunnen laten ook nog wel in Redis.

- Elke swipe zend een POST naar de server. Daar slaan we de
