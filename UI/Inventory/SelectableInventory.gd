extends Inventory
class_name SelectableInventory

var selected_index: int = 0
signal selection_changed

func increment_selected_index():
	selected_index = (selected_index+1)%self.items.size()
	selection_changed.emit(selected_index)

func decrement_selected_index():
	selected_index = selected_index-1
	if selected_index < 0: 
		selected_index = items.size()-1
	selection_changed.emit(selected_index)

func get_selected_item():
	return self.items[selected_index]
