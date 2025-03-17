# RestService

Basic and **very** simple rest service for displaying `CS2` skins and basic decription about them.

# Usage

To start the project run:
```
mix run --no-halt
```

Then proceed to

```
http://localhost:4000/home
```
on browser

Or just use the API:

```
http://localhost:4000/v1/weapon/{cs2_weapon_type}/{any number | 'all'}
```

The server uses public skin APIs to get information and filter it acording to the request :)


### Why?

This was just a simple and dirty way to learn about `plug`, `tesla`, `jason` and mix in general. I always wanted to do something à la *steam market+*. Unfortunately, every api that I could find for market pursposes is not free, and I am not paying 20$/month for this. So instead I did

Other important reason why I did it like I did was to do RESTful API as close to the ground I wanted to. This was just for getting better understanding of this (and mix in general)

