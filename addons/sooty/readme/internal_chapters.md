Any chapter wrapped in `_` is treated as internal.  
Case doesn't matter.

# `_init_`

Initialize variables here, and any code you want added to the main script.
~~~
# _init_
score = 0
found_princess = false

```gd
func my_func(a, b):
  print(a + b)
```
~~~

# `_characters_`
Define characters.
```
# _characters_
Mary - The main character
John - The friend
Paul - A cat

## Villains
Mr. Pitts - The antagonist
Henchman 1
Henchman 2
```

# `_achievements_`
Define achievements.
```
# _achievements_
Good Ending - Reached the good ending.

Bad Ending - Reached the bad ending.

No Stone Unturned - Found all secret areas.
  toll: 3

Baddie Killer - Killed 10 Baddies.
  toll: 10
```

# `_quests_`
Define quests.
```
# _quests_

## Bakers Quest
Bake a cake for the event.
- Collect Eggs
  toll: 4
- Collect Milk
  toll: 2
- Bake The Cake
- Bring it to the event

## Dragon Slayer
Slay the dragon at the root of The Last Mountain.
- Talk to Morgo
- Talk to Vinder
```

# `_config_`
Config is for setting Congigurations vars.

```
# _config_
screen_size = 800, 600
menu_image = class_front
```

# `_credits_`
Define credits.

```
# _credits_
Graphics
- [Backgrounds - gman66](#www.gman66.ca)
- [Other Backgrounds - John Doo](#www.google.com)

Sound Design
- Misc - music_maker_911
```
