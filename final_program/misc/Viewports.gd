extends Control

onready var tabs: Tabs = $Tabs

# -
func _ready() -> void:
	# populate tabs
	tabs.add_tab("Image")
	tabs.add_tab("Image (Smoothed)")
	tabs.add_tab("Metric")


# show the tab that was clicked on @ Tabs tab_changed
func _on_Tabs_tab_changed(tab: int) -> void:
	match tab:
		0:
			$FinalImageViewportContainer.raise()
		1:
			$SmoothedFinalImageViewportContainer.raise()
		2:
			$MetricViewportContainer.raise()
