extends SceneTree
func _init():
    var is_fs = null
    var text = "Exit" if is_fs else "Full"
    print(text)
    quit()
