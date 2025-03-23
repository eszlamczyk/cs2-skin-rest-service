# RestService

Basic and **very** simple rest service for displaying `CS2` skins (or stickers) and basic decription about them.

# Usage

To start the project run:
```
mix run --no-halt
```

## API:

Endpoints work on `http://localhost:4000` by default

Exposed endpoints:

### GET: /home

This endpoint returns html of home page to select skins/stickers you would like to see

### GET: /v1/stickers/{from}/{to}

Display stickers and basic information about themselves:

- `return type`: text/html
- `from`: integer between 0 and 7984
- `to`: integer between 0 and 7984, larger then `from`

### GET: /v1/weapons/{weapon-type}/{num}

Display specific weapon type skins and basic information about them:

- `return type`: text/html
- `weapon-type`: String from `weapon-types` list (given below)
- `num`: Positive integer or literal `all`

### Why?

This was just a simple and dirty way to learn about `plug`, `tesla`, `jason` and mix in general. I always wanted to do something à la *steam market+*. Unfortunately, every api that I could find for market pursposes is not free, and I am not paying 20$/month for this. So instead I did

Other important reason why I did it like I did was to do RESTful API as close to the ground I wanted to. This was just for getting better understanding of this (and mix in general)


#### Weapon-types

Here are provided weapon types that can ge used in `v1/weapons` endpoint:
- "CZ75-Auto",
- "Desert Eagle",
- "Dual Berettas",
- "Five-SeveN",
- "Glock-18",
- "P2000",
- "P250",
- "R8 Revolver",
- "Tec-9",
- "USP-S",
- "MAG-7",
- "Nova",
- "Sawed-Off",
- "XM1014",
- "M249",
- "Negev",
- "MAC-10",
- "MP5-SD",
- "MP7",
- "MP9",
- "P90",
- "PP-Bizon",
- "UMP-45",
- "AK-47",
- "AUG",
- "FAMAS",
- "Galil AR",
- "M4A1-S",
- "M4A4",
- "SG 553",
- "SSG 08",
- "AWP",
- "G3SG1",
- "SCAR-20",
- "Zeus x27",
- "M9 Bayonet",
- "Butterfly Knife",
- "Bowie Knife",
- "Classic Knife",
- "Falchion Knife",
- "Flip Knife",
- "Gut Knife",
- "Huntsman Knife",
- "Karambit",
- "Kukri Knife",
- "Navaja Knife",
- "Nomad Knife",
- "Paracord Knife",
- "Shadow Daggers",
- "Skeleton Knife",
- "Stiletto Knife",
- "Survival Knife",
- "Talon Knife",
- "Ursus Knife"