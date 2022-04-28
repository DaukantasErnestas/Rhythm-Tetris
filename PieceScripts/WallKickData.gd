extends Node

var wall_kick_data_main = {"cw":
	[
	[Vector2(0,0),Vector2(-1,0),Vector2(-1,1),Vector2(0,-2),Vector2(-1,-2)], # #3>>0
	[Vector2(0,0),Vector2(-1,0),Vector2(-1,-1),Vector2(0,2),Vector2(-1,2)], #0>>1
	[Vector2(0,0),Vector2(1,0),Vector2(1,1),Vector2(0,-2),Vector2(1,-2)], #1>>2
	[Vector2(0,0),Vector2(1,0),Vector2(1,-1),Vector2(0,2),Vector2(1,2)] #2>>3
	],"ccw":
	[
	[Vector2(0,0),Vector2(1,0),Vector2(1,1),Vector2(0,-2),Vector2(1,-2)], #1>>0
	[Vector2(0,0),Vector2(-1,0),Vector2(-1,-1),Vector2(0,2),Vector2(-1,2)], #2>>1
	[Vector2(0,0),Vector2(-1,0),Vector2(-1,1),Vector2(0,-2),Vector2(-1,-2)], #3>>2
	[Vector2(0,0),Vector2(1,0),Vector2(1,-1),Vector2(0,2),Vector2(1,2)] #0>>3
	]
}

var wall_kick_data_I = {"cw":
	[
	[Vector2(0,0),Vector2(1,0),Vector2(-2,0),Vector2(1,2),Vector2(-2,-1)], #3>>0
	[Vector2(0,0),Vector2(-2,0),Vector2(1,0),Vector2(-2,1),Vector2(1,-2)], #0>>1
	[Vector2(0,0),Vector2(-1,0),Vector2(2,0),Vector2(-1,-2),Vector2(2,1)], #1>>2
	[Vector2(0,0),Vector2(2,0),Vector2(-1,0),Vector2(2,-1),Vector2(-1,2)] #2>>3
	],"ccw":
	[
	[Vector2(0,0),Vector2(2,0),Vector2(-1,0),Vector2(2,-1),Vector2(-1,2)], #1>>0
	[Vector2(0,0),Vector2(1,0),Vector2(-2,0),Vector2(1,2),Vector2(-2,-1)], #2>>1
	[Vector2(0,0),Vector2(-2,0),Vector2(1,0),Vector2(-2,1),Vector2(1,-2)], #3>>2
	[Vector2(0,0),Vector2(-1,0),Vector2(2,0),Vector2(-1,-2),Vector2(2,-1)] #0>>3
	]
}

var wall_kick_data_main_180 = [
	[Vector2(0,0),Vector2(0,1),Vector2(-1,1),Vector2(1,1),Vector2(-1,0),Vector2(1,0)], #2>>0
	[Vector2(0,0),Vector2(-1,0),Vector2(-1,-2),Vector2(-1,-1),Vector2(0,-2),Vector2(0,-1)], #3>>1
	[Vector2(0,0),Vector2(0,-1),Vector2(1,-1),Vector2(-1,-1),Vector2(1,0),Vector2(-1, 0)], #0>>2
	[Vector2(0,0),Vector2(1,0),Vector2(1,-2),Vector2(1,-1),Vector2(0,-2),Vector2(0,-1)] #1>>3
]

var wall_kick_data_I_180 = [
	[Vector2(0,0),Vector2(1,0),Vector2(2,0),Vector2(-1,0),Vector2(-2,0),Vector2( 0,1)], #2>>0
	[Vector2(0,0),Vector2(-1,0),Vector2(-1,-2),Vector2(-1,-1),Vector2(0,-2),Vector2(0,-1)], #3>>1
	[Vector2(0,0),Vector2(-1, 0),Vector2(-2, 0),Vector2( 1, 0),Vector2( 2, 0),Vector2( 0, -1)], #0>>2
	[Vector2(0,0),Vector2(1,0),Vector2(1,-2),Vector2(1,-1),Vector2(0,-2),Vector2(0,-1)] #1>>3
]
