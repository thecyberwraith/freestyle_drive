extends Resource

class_name PlayerInfo

var input: InputProfile
var character: CharacterInfo
var player_name: String
var instance: PlayerVehicle

func _init(
	an_input: InputProfile=InputProfile.new(), 
	a_char: CharacterInfo=CharacterInfo.new(), 
	a_player_name: String=''
	):
	input = an_input
	character = a_char
	player_name = a_player_name
	instance=null
