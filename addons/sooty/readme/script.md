## Meta
At the top of a Markdown file, optional meta data can be included.  
Here is where you can set the stories name, among other things.

Meta data starts at the top of the file with a `---` and ends with `---`.

`res://my_story.md`
```
---
title: My Story
subtitle: The Begining
author: Me
version: 1.01
---

# Chapter 1
...
```

## Chapters
Chapters begin with `#`.

Special internal chapters are wrapped in `_`. Learn about them [here](#/internal_chapters.md)

Stories will begin on the first defined chapter.

```
# _init_
score = 0

# How it all Started
Here is how everything started...
```

After a chapter finishes, nothing happens.  
If instead you want to go to the next chapter, use `->`.  
If you want to go to a specific chapter, enter it's name after `->`.  
Case doesn't matter.

```
# How it all Started
...
->

# How it went.
...
-> the end

# The End
And that was that.
```

If you want to run a chapter and then return to where you were, use `::` instead of `->`.

```
# add a day
`time.day += 1`
He woke up.
It was a {time.day_of_week} morning.

# Day 1
:: add a day
Time to get to things.
...
->

# Day 2
:: add a day
"The weekend is coming up." He thought to himself.
...
```

## Functions
Preceded with a `.` or wrapped in `` ` ``.  
Spaces are treated as breaks between arguments.
```
.music my_song 0.5
.music "My Song" .5
`music my_song`
```
Becomes:
```
music("my_song", 0.5)
music("My Song", 0.5)
music("my_song")
```

## Keyword Arguments
Sooty allows keyword arguments (kwargs), like in python.
```
.music song 1 fade=in time=1.0
```
Becomes:
```
music("song", 1, {"fade": "in", "time": 1.0})
```

## Scenes
To change the scene in Godot you can use:
- `.scene scene_name`
- `INT. SCENE NAME`
- `EXT. SCENE NAME`

If there is no `scenes/scene_name.tscn`, then a BG Object will be created with `images/scene_name.png`.

## Objects
To populate a scene, we add and manipulate objects.  
This starts with `@`.
```
@character happy color=red
```
Becomes something like:
```
var o = get_object("character")
o._main(["happy"], {"color": "red"})
```

If there is no `scenes/character.tscn`, then an Image Object will be created and use `images/character happy.png`. (or .jpg, .webp...)

## Object Actions
Follow an object id with `;` to call it's functions.
```
@character; move left; shake 1.0; fade out time=1.0
```
Becomes something like.
```
character.move("left")
character.shake(1.0)
character.fade("out", {"time": 1.0})
```

## Dialogue
The `_characters_` chapter can setup characters.
```
# _Characters_
Mary - The main character
John - The friend
Paul - A cat.
```
Becomes:
```
var mary = CharacterInfo.new({"name": "Mary"})
var john = CharacterInfo.new({"name": "John"})
var paul = CharacterInfo.new({"name": "Paul"})
```

### Styling
Writing names in ALL CAPS will cause them to be replaced with `{name}`.
```
MARY went to see JOHN. >> "{mary} went to see {john}."
```

This is useful for styling.  
You can style names in the `_characters_` chapter.

```
<font color=red>**Mary**</font> - The main character.
**John** - The friend.

Becomes:

var mary = CharacterInfo.new({"name": "Mary", "form": "[color=red][b]%s[/b][/color]"})
var john = CharacterInfo.new({"name": "John", "form": "[b]%s[/b]"})
```

`MARY went to see JOHN.`
`>>`
<font color=red>**Mary**</font> went to see **John**.

### Writing
```
This line has no speaker.

"???": This line will show ??? as the speaker.

The following lines all have the same speaker.  
JOHN: Hello.  
john: Hello.  
j: Hello.

JOHN: When someone has a lot to say
  you can add indented lines.
  These are still spoken by John.
  (But this one is spoken by no one.)
  This one is John again.
  MARY: Now Mary is speaking.
  And she will continue to speak...
  JOHN: Until someone else does.
```

Since Markdown doesn't display whitespace, like tabs, here is how the above text is rendered:

---

This line has no speaker.

"???": This line will show ??? as the speaker.

The following lines all have the same speaker.  
JOHN: Hello.  
john: Hello.  
j: Hello.  

JOHN: When someone has a lot to say
  you can add indented lines.
  These are still spoken by John.
  (But this one is spoken by no one.)
  This one is John again.
  MARY: Now Mary is speaking.
  And she will continue to speak...
  JOHN: Until someone else does.

---

## Menus
Menus are built on Markdown lists.
```
The first line before a list is treated as it's text.
- Option 1
- Option 2
- Option 3
```

### Automatic GOTO
You can include a `->` on the same line, for convenience.  
The following menus would work the same.
```
""
- Go West -> West
  You head off to the west.
- Go East -> East
  You head off to the east.

""
- Go West
  You head off to the west.
  -> West
- Go East
  You head off to the east.
  -> East
```

### Conditionals
You can include an `` `if` `` to show/hide options.
```
""
- Ask about the Quest `if apples > 5`
- Ask about the Princess `if learned_of_princess`
- Leave
```

## Random
If the first line of the list is a `?`, a random list item will be chosen.
```
?
- NPC: Greetings traveler.
- NPC: Hello there.
- NPC: Fine day, isn't it?
```

## Conditionals
Currently `if`, `elif`, `else` work as they do in Godot.

```
You enter the dirty saloon.

if reputation < 0:
  The barkeep looks up.
  .play danger_noise
  BARKEEP: I thought I told you not to come back in here.

elif reputation == 0:
  No one seems to notice you.

else:
  BARKEEP: Well look who it is!
  .play crowd_cheering
  The patrons all turn and rise to cheer.
```
Markdown wont render newlines, but you can add a double space to the end of a line.

---

You enter the dirty saloon.

if reputation < 0:  
  The barkeep looks up.  
  .play danger_noise  
  BARKEEP: I thought I told you not to come back in here.

elif reputation == 0:  
  No one seems to notice you.

else:
  BARKEEP: Well look who it is!  
  .play crowd_cheering  
  The patrons all turn and rise to cheer.

---
