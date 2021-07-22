


Sooty catalogues resources in a database so they can be more easily found and used without caring about organizing and writing things perfectly.

So, a sound file at:  
`res://audio/sfx/My Jingle 3 (credit=soundzzz.gov).mp3`  
can be got with:  
`Resources.sound("my_jingle")` or  
`Resources.sound("jingle")` or  
`Resources.sound("My Jingle 3")`

And if you later moved `My Jingle 3` to `res://audio/jingles/My Jingle 3...` everything would still work.
