extends RichTextLabel


# opens the link to the consent form @ RichTextLabel meta_clicked
func _on_RichTextLabel_meta_clicked(meta) -> void:
	OS.shell_open(str(meta))
