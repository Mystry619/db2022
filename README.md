I kursen DB2022 på IT-Högskolan skulle vi redovisa på färdigheter i SQL, Normalisering samt Java mot en relationsdatabas. 
Detta är min redovisning från denna kurs.


## Enitity Relationship Diagram

[![](https://mermaid.ink/img/pako:eNp1k92OgyAQhV-FcN2-ALe72Z9k02ziXnqDMq0kCg0MTYz23ZcCumhZr5zjmW9OBpxoqwVQRsG8Sn4xfKhVhU6AQjLPx6OeyHenFRBGOm6fvqWyajute-_hiKDEv74P3TRjETUvlnfDxX7aVCviH-nNSfkUtbJopLqQN2ksnvgAq_LFF-HuESFajLFJywgoo_veksWUjwnCY8pDSdzIzIQXiWMckoPLaZ_Jvi_uo7wjqW66v4FNrowa6mK2vyj7nkKSFeO74ta3QZaTSGtKpowZ6oVYlXPsewo5VozvCncts4d6s75tf5r6M163J3NyQwPGI-mBDmAGLoW_4wFcU-zAh6TMvwo4c9djTaOVO9TVqFrK0Dg4UHcVHCH9GJSdeW_h_gtEtyHu?type=png)](https://mermaid.live/edit#pako:eNp1k92OgyAQhV-FcN2-ALe72Z9k02ziXnqDMq0kCg0MTYz23ZcCumhZr5zjmW9OBpxoqwVQRsG8Sn4xfKhVhU6AQjLPx6OeyHenFRBGOm6fvqWyajute-_hiKDEv74P3TRjETUvlnfDxX7aVCviH-nNSfkUtbJopLqQN2ksnvgAq_LFF-HuESFajLFJywgoo_veksWUjwnCY8pDSdzIzIQXiWMckoPLaZ_Jvi_uo7wjqW66v4FNrowa6mK2vyj7nkKSFeO74ta3QZaTSGtKpowZ6oVYlXPsewo5VozvCncts4d6s75tf5r6M163J3NyQwPGI-mBDmAGLoW_4wFcU-zAh6TMvwo4c9djTaOVO9TVqFrK0Dg4UHcVHCH9GJSdeW_h_gtEtyHu)

## Normalisera databas


cd ws

cd db2022

docker exec -i iths-mysql mysql -uiths -piths < Normalisering.sql



## Köra java app på main grenen
Vi ansluter till MySQL och Chinook databasen och gör en lite komplexare ORM (Object Relational Mapping).

cd ws

cd db2022

gradle run


När vi köra den här koden kommer vi få ArtistId, Artists Name, AlbumId, Albums Title och antal Tracks på varje Album.


## Köra java app på test grenen
CRUD är ett begrepp man ofta använder i utveckling, och framförallt med databaser. Den står för Create, Read, Update samt Delete.

cd ws

cd db2022

gradle check

Vi får en livscykel för entiteter i databaser.

