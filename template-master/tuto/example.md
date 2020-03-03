---
module:			B-MAT-100
title:			Pong
subtitle:		Vectors and Video Games

binary: 		101pong
repository: 	101pong
language:		#allLanguages
compilation:	#makfile
build:			no need here

author:			Pierre ROBERT
version:		2.0
---

#imageLeft(example.png, 90px, 11)

#space(1)
Pong, developed as an arcade game in 1972 by Ralph Baer (Atari), is the first ever successful video game. 
It was inspired by the very first video game, *Tennis for Two*, developped in 1958 by William Higinbotham on an oscilloscope.#br

The goal of this project is to work on a 3d version of this game (or of the Brick Break game by the way...). 
Only one bat will be considered, moving only in the 0-altitude plan (which happens to be (Oxy)).#br

Your program has then to print:

  * the coordinates of the ball speed vector,
  * the speed vectors of the ball in a given amount of time,
  * the angle at which the ball will hit the bat.

#hint(Pings and ends of games will not be taken into account. In other words\, **only the ball’s movement** will be considered\, regardless of the context.)

#terminal(./101pong -h
USAGE
#space(1) ./101pong x0 y0 z0 x1 y1 z1 n #br

DESCRIPTION
#array(m{1cm} m{0.8cm} l, 

#next x0  #next ball abscissa at time t-1
#next y0  #next ball ordinate at time t-1
#next z0  #next ball altitude at time t
#next x1  #next ball abscissa at time t
#next y1	#next ball ordinate at time t 
#next z1  #next ball altitude at time t
#next n  	#next time shift (greater than or equal to zero, integer))
)

You can customize your project by adding as many bonus points as possible:

* ball acceleration management,
* a graphical interface,
* a complete 2d Pong game,
* a complete 2d Brick Breaker game,
* a complete 3d Pong game,
* a complete 3d Brick Breaker game,
* a spherical paddle.



#newpage

# Examples

#warn(Your program output has to be strictly identical to the one below.)

#terminal(./101pong1 3 5 7 9 -2 4
The speed vector coordinates are:
(6.00;6.00;-7.00)
At time t+4\, ball coordinates will be:
(31.00;33.00;-33.00)
The ball won’t reach the paddle)

#terminal(./101pong1.1 3 5 -7 9 2 4
The speed vector coordinates are:
(-8.10;6.00;-3.00)
At time t+4\, ball coordinates will be:
(-39.00;33.00;-10.00)
The incidence angle is:
16.57 degrees)

#hint(The incidence angle should be between 0 and 90 degrees.)

#hint(Pay attention to the float numbers precision!)
