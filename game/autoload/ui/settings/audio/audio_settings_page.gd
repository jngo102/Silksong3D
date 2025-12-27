## UI for adjusting audio levels
class_name AudioSettingsPage extends VBoxContainer

## Control for master volume
@onready var _master_volume_slider: SettingValueSlider = $MasterVolumeSlider
## Control for music volume
@onready var _music_volume_slider: SettingValueSlider = $MusicVolumeSlider
## Control for SFX volume
@onready var _sfx_volume_slider: SettingValueSlider = $SFXVolumeSlider

func _ready() -> void:
	# Initialize audio settings from save settings file
	_master_volume_slider.slider_value = SaveManager.settings.master_volume
	_music_volume_slider.slider_value = SaveManager.settings.music_volume
	_sfx_volume_slider.slider_value = SaveManager.settings.sfx_volume

func _on_master_volume_slider_value_changed(value: float) -> void:
	SaveManager.settings.master_volume = value
	AudioManager.update_music_volume()
	
func _on_music_volume_slider_value_changed(value: float) -> void:
	SaveManager.settings.music_volume = value
	AudioManager.update_music_volume()
	
func _on_sfx_volume_slider_value_changed(value: float) -> void:
	SaveManager.settings.sfx_volume = value
