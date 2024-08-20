## What's fun?
1. To watch residents interact with the buildings you have placed
2. To make a unique and pretty city every game (think carcassonne)
3. To infer and manage the needs of your residents
4. Also cats


## Summary
Competitive and fast-paced turn-based City Builder for 2 players


## Core Gameplay Loop
1. Choose a Structure (Out of 3 Structures)
2. Choose a location 
Take turns till each player has taken 15 turns
Each turn takes 20 seconds
Highest Score Wins


## Scoring
Residents will interact with your structures automatically.
Each resident has the following needs:
1. Tricks
2. Naps
3. Snacks

You score cat points when cats visit respective Paradise locations:
1. Tower Tree : Scores tricks 
2. Sunspot : Scores naps
3. Fountain : Scores snacks


##  Introducting Randomness
Let the player make choices, but limit their options greatly
1. Intialise the map randomly with 5 of the following
	a. River
	b. Lake
	c. Hill
	(e.g. 2 Rivers, 1 Lake and 2 Hills)
2. Provide 2 random structures to choose from every turn
3. The remaining structure goes to the opponent. do this twice.
4. Pick 3 out of the 4 structures in your hand to build


## Structure Themes
The structures follow the themes of snacks, tricks and naps.
snacks
symbolises: abundance, greed
mechanics: These buildings improve with more nearby buildings. However, exceeding
a threshold would ruin the building instead

tricks
symbolises: change, chaos
mechanics: these buildings have varying effects depending on the next building you play, allowing flexible play.
- roads: provide tiles that make it easier for cats to travel around on e.g. white tiles, green tiles, bridge tiles

naps
symbolises: peace, rigidity
mechanics: these buildings make your future plays have more constraints, but they provide strong upsides.
- blueprints: create a "blueprint" tile with a condition. when the condition is met, target buildings will receive various effects


## Structure Ideas
1. Bobcat Workshop (Bustle)
	_A small hut surrounded by woody forests on three sides. Plenty of lumber._
	Allows you to build better buildings
    +1 tricks
	+2 cats
	Creates a layer of *RED Rugged* tiles behind the forests

2. Fishing Hut (Nature)
	_A small, old cabin with fishing equipment and a fireplace._
    +2 snacks
	+1 cats

3. Catnip Alley (Bustle)
	_The shallow drains between two old buildings on a quiet street make a good hideout for kittens and catnip dealers_
	+3 cats
	Creates 2 layers of *GREY* tiles in front of it 

4. Hidden Junkyard (Bustle)
	_Junkyards provide cover for kittens and disrupts the orderliness in the city._
	+1 cats
	+1 nap
	Creates 1 layer of *RED* tiles all around.

5. Cardboard Community (Bustle)
	_3 scattered cardboard boxes provide the bare minimum for abandoned kittens_
	+6 cats
	Creates a large triangle of *GREY* tiles between the cardboard boxes.

6. Numbered cat shrines (Special)
	_The cat guardian blesses all cats in a vicinity similar to its shape on a die_
	Upgrade all structures in its respective shape (3 shrine would upgrade 3 small regions diagonally

7. Jaguar tribe (Nature)
	_Group of cats descended from jaguars. Live in a cluster of 4 trees with bridges in between.They love sweet fruits._
	+3 cats
	+1 snacks
	+2 tricks
	Creates a cross shaped *RED* area between the trees

8. Lazy Rooftops (Bustle)
	_No better place to have a nap on a cloudy day._
	+1 cats
	+3 nap
	+3 tricks
	Creates a *GREY* zone between two rows of rooftops.

9. Playground (Bustle)
	_Small structure that provides shelter_
	+1 cats
	+2 nap

10. Bench Pathway (Nature)
	_Scattered benches for weary legs._
	+1 cats
	+2 nap
	+1 snacks

11. Tuna Factory (Nature) 
    _Looks like a can. Fish for a long time._
    +2 cats
    +3 snacks

12. Cat Post Office (Bustle)
    _Send letters? Scratch others?
    +2 cats
    +3 tricks

13. Recycling Bin Complex
    _Comically large bins for scavenging. Really popular

14. 

	
## Tiles
Strutures are placed on tiles that measure 64x64. Each tile determines the kind of structure that can be placed on it.
1. Green (Neutral)
	Green tiles are the best. Build anything on it!. Green tiles turn brown over time when cats
	walk on them.
2. Red (Rugged)
	Red tiles symbolise an uneven or hilly terrain. *Bustle* can't be built here.
3. Grey (Paved)
	Paved tiles are bad for vibes. *Nature* can't be built here.
4. Blue (Water)
	Water tiles cannot be built on.


	

## Event Ideas

## What do cats think?
cats will wander to any nearby structure from their home.
from that structure, cats will wander to nearby structures.
when they run out of curiosity, they will make their way home
nearby structures are structures less than x tiles away, where x is their curiosity


## Optimal gameplay:
since we want our cats to have high stats, we will naturally place buildings nearby each other
penalty for overcrowding? why wouldnt cats all hang out in the city?
1. cats slap other cats. mildly
2. cats hunt mice
3. cats stalk birds
4. cats are territorial
