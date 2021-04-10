extends VBoxContainer

const scoreline=preload("res://scenes/uiScenes/hboxScoreline.tscn")
func _ready():pass

func loadScoreboard():
	yield(SilentWolf.Scores.get_high_scores(5), "sw_scores_received")
	$strLoading.queue_free()
	var idx=1
	for score in SilentWolf.Scores.scores:
		var i=scoreline.instance()
		i.get_node("strPlayerPosition").text=str(idx)+'. '
		i.get_node('strPlayerName').text=score.player_name
		i.get_node('strPlayerScore').text=str(int(score.score))
		add_child(i)
		idx+=1
	if global.scoreId!='':
		yield(SilentWolf.Scores.get_score_position(global.scoreId), "sw_position_received")
		var playerPosition=SilentWolf.Scores.position
		if playerPosition>5:
			var i=scoreline.instance()
			i.get_node('playerPosition').text=str(playerPosition)+'. '
			i.get_node("playerName").text=global.playerName
			i.get_node('playerScore').text=str(int(global.score))
			add_child(i)
