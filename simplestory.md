---
title: Godot Quest
subtitle: The Begining
author: The Author
version: v1.0a
---
[[toc]]

# _characters_
[color=greenyellow]**Noob**[/color] - A noob.  
<font color=deepskyblue>**Godette**</font> - A game developer.  
<font color=dodgerblue>**Godot**</font> - A game engine.
<font color=dodgerblue>***icon.png***</font> - Texture placeholder.

# _achievements_
Good Ending - Learned about GODOT.  
    icon = godette head
    
Bad Ending - Went home.
    icon = godette head mad

# _quests_

## Learn Godot
Ask GODETTE about learning GODOT.
- Learn Functions
- Learn Arrays
    toll = 3

# Start
INT. CLASS STEPS
`music happytune`

.input noob.name "What is the characters name?"

Another *boring* school day ends.

@godette main; scale 0.3

.play hey
GODETTE: Oh NOOB, I was wondering...
    Have you ever heard of GODOT?  

.play laughter
GODETTE: Well, I should be going.

.play bye
@godette leaving

""
- Ask her about GODOT.
    n: Hey, wait!
    .play what
    @godette confused
    g: What? You want to learn about GODOT?
    -> Good Ending
- Go on with your day.
    GODETTE walks on away.
    n: Nah, not me. I could never make a game.
    -> Bad Ending

# Bad Ending
INT. CLASS_FRONT
.music no_hope
.ambient rain
@rain

NOOB: What was she talking about?
    Go-go-dot?
    I guess I'll never know.

.achieve bad_ending  
[[center]] This is the [color=red]***Bad Ending***[/color].  
.show_menu

# Good Ending
INT. CLASS_EXIT

@godette main; scale 0.3; at left;
.play hello
g: Oh, you showed up?

@godette; move center 0.5
g: I'm so glad you wanted to learn GODOT!

g: Oh, look who it is.

@godette; move centerleft
@icon_png; at midright;
g: This is ICON.PNG. You'll be seeing a lot of him around.

`achieve good_ending`  
[[center]] This is the [color=yellowgreen]***Good Ending***[/color]!
`show_menu`

# _config_
screen_size = 800, 600
menu_image = class_front
menu_music = intro theme

# _credits_
Graphics
- [Godette - Andrea Calabrò](https://github.com/godotengine/godot-design/tree/master/godette)
- [School Backgrounds - Uncle Mugen](https://alte.itch.io/uncle-mugens-school)

Sound Effects
- [Jingles - wobbleboxx](http://wobbleboxx.com/) <!-- https://opengameart.org/content/level-up-power-up-coin-get-13-sounds -->
- [Voice - cicifyre](https://opengameart.org/users/cicifyre)
- [Rain and Thunders - kindland](https://opengameart.org/users/kindland)

Music
- [Intro Theme - adn_adn](https://opengameart.org/users/adnadn)
- [Happy Tune - syncopika](https://opengameart.org/users/syncopika)
- [Game Over Theme - Cleyton Kauffman](https://soundcloud.com/cleytonkauffman) <!-- https://opengameart.org/content/game-over-theme -->

Godot
- [Juan Linietsky](https://github.com/reduz)
- Ariel Manzur

Sooty
- [teebar](https://github.com/teebarjunk)

Thanks for playing!
