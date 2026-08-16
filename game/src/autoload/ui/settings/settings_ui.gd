class_name SettingsUI extends MenuPage
## UI for modifying game settings

@onready var _settings_tabs: Control = _contents.get_node_or_null("SettingsTabs")
@onready var _pages: Control = _contents.get_node_or_null("Pages")
@onready var _input_settings_page: InputSettingsPage = _pages.get_node_or_null("InputSettingsPage")
@onready var _cursor: Cursor = _settings_tabs.get_child(0).get_node_or_null("Cursor")

var _settings_tab_buttons: Array[Node]:
	get:
		return _settings_tabs.get_children().filter(func(tab): 
			return tab is Button)

var _current_tab_button: Button:
	get:
		var currently_selected: Control = get_viewport().gui_get_focus_owner()
		if _settings_tab_buttons.has(currently_selected):
			return currently_selected
		return null

var _selected_tab_index: int:
	set(value):
		_selected_tab_index = value
		var next_focused: Control = _settings_tab_buttons[value]
		next_focused.grab_focus.call_deferred()

func _ready() -> void:
	_set_up_settings_tabs()

func _input(event: InputEvent) -> void:
	if not visible or _input_settings_page.rebinding:
		return
	# Check previous focus neighbor before next so because Tab button is evaluated alone first
	if event.is_action_pressed(&"ui_prev_tab"):
		var tab_button_count: int = len(_settings_tab_buttons)
		_selected_tab_index = (_selected_tab_index - 1 + tab_button_count) % tab_button_count
	elif event.is_action_pressed(&"ui_next_tab"):
		var tab_button_count: int = len(_settings_tab_buttons)
		_selected_tab_index = (_selected_tab_index + 1) % tab_button_count

func _set_up_settings_tabs() -> void:
	var tab_button_index: int = 0
	for tab_button in _settings_tab_buttons:
		if tab_button is Control:
			tab_button.mouse_entered.connect(tab_button.grab_focus)
			tab_button.focus_entered.connect(func():
				_cursor.show()
				_cursor.move_to(tab_button)
				var page_index: int = 0
				for page in _pages.get_children():
					if page_index == tab_button_index:
						page.show()
					else:
						page.hide()
					page_index += 1
			)
			tab_button_index += 1
		var first_tab_button: Button = _settings_tab_buttons[0]
