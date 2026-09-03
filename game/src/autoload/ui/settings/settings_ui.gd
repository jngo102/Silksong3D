class_name SettingsUI extends MenuPage
## UI for modifying game settings

@onready var _settings_tabs: Control = _contents.get_node_or_null("SettingsTabs")
@onready var _pages: Control = _page.get_node_or_null("Pages")
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
		_show_page(value)

func _ready() -> void:
	_set_up_settings_tabs()

func _input(event: InputEvent) -> void:
	if not visible or _input_settings_page.rebinding:
		return
	# Check previous focus neighbor before next because Tab button is evaluated alone first
	if event.is_action_pressed(&"ui_tab_prev"):
		var tab_button_count: int = len(_settings_tab_buttons)
		_selected_tab_index = wrapi(_selected_tab_index - 1, 0, tab_button_count)
	elif event.is_action_pressed(&"ui_tab_next"):
		var tab_button_count: int = len(_settings_tab_buttons)
		_selected_tab_index = wrapi(_selected_tab_index + 1, 0, tab_button_count)

func _on_contents_visibility_changed() -> void:
	super._on_contents_visibility_changed()
	_page.update_focus.call_deferred()
	await get_tree().process_frame
	reset_focus()
	_reset(true)

func _set_up_settings_tabs() -> void:
	var tab_button_index: int = 0
	for tab_button in _settings_tab_buttons:
		if tab_button is Control:
			tab_button.mouse_entered.connect(func(): _show_page(tab_button_index))
			tab_button_index += 1

func _show_page(index: int) -> void:
	_cursor.show()
	var tab_button: Control = _settings_tab_buttons[index]
	_cursor.move_to(tab_button)
	var page_index: int = 0
	for page in _pages.get_children():
		if page_index == index:
			page.show()
		else:
			page.hide()
		page_index += 1
	_page.update_focus.call_deferred()
	await get_tree().process_frame
	reset_focus()
	_reset(true)
