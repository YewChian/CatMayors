extends Node2D

const TILE_LENGTH : int = 64
const DIRECTIONS : Array[Vector2] = [Vector2(1,0), Vector2(0,-1), Vector2(-1,0), Vector2(0,1)]
const SIZE : int = 2000
const GREEN_EXPANSION_PROBABILITY : float = 0.5
const RED_EXPANSION_PROBABILITY : float = 0.2
const TURN_DURATION: Dictionary = {
	"DraftUI": 30,
	"ChooseLocationUI": 30,
	"ObserveUI": 50,
	"EventUI": 15,
}
const MAX_ROUNDS: int = 4
const BASE_CURIOSITY: int = 5

var game_speed: float
var region: String
