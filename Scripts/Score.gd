extends Label

var score = 0 setget setScore, getScore

func _ready():
	self.text = "Score: " + str(score)
	pass
	
func setScore(newScore):
	score=newScore
	self.text="Score: " + str(score)
	pass
	
func getScore():
	return score
	pass
