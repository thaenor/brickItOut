# brickItOut #
### Atari's Breakout clone ###

##### Contetxt #####
This project is part of a challenge and a learning exercise of [haxe](haxe.org) and [openfl](www.openfl.org). The use of aditional libraries like haxefixel or haxepunk is purposefully avoided.

**development time: 1 week**

#####  features #####
- Using some rudimentar (and sometimes random) physics, the game is playable using randomly generated and colored blocks.
- the background soundtrack is called [*"Mano Pando"*](https://soundcloud.com/thaenor/mano-pando) it was created by me for the [FAWM contest](fawm.org) last February. You can listen to other tracks [here](https://soundcloud.com/thaenor).
- The winnning sound effect was taken form [freesound.org](freesound.org) [link](http://freesound.org/people/jobro/sounds/60444/)
- the "fail" violin was quickly scrapped on my phone :-)

#####  folder structure #####
- Assets: used images and sound effects
- Export: exported (i.e compiled) versions
- Source: the source code. Simple class structure was used (some code cleanup is required, I know...)

#####  live version #####

!["live version"](http://i.imgur.com/cZg7O7O.png)

NOTE: the live version is the product of haxe's export to html5. It will open on a phone but won't be playable because the events were directly bound to keys (which won't be acessible on touch screen phones). The live version only serves as a mere demonstration but with some minor adjustments the code could be used to export a flash, mobile, windows or OSX version easily.

#####  know issues #####

- Some browsers don't seem do deal well the sound import. Chrome prefers .ogg but other browsers (or flash) work better with the mp3 version. Both are featured in the "Assets" folder
