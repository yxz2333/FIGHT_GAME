extends Control

@onready var still = [$SoloButton/PanelContainer/Still,
					  $PartyButton/PanelContainer/Still]
@onready var dynamic = [$SoloButton/PanelContainer/Dynamic,
						$PartyButton/PanelContainer/Dynamic]
## rich[i][j] : i选择1还是2，j选择solo还是party
@onready var rich = [[$SoloButton/PanelContainer/RichTextLabel,
					  $PartyButton/PanelContainer/RichTextLabel],
					 [$SoloButton/PanelContainer/RichTextLabel2,
					  $PartyButton/PanelContainer/RichTextLabel2]]

@onready var empty_button : Button = $EmptyButton
@onready var return_button : Sprite2D = $ReturnButton/Restart

# 创建一个新的Shader给return_button用
var shader : Shader = Shader.new()

func _ready():
	empty_button.grab_focus() # 初始聚焦点设成空按钮
	for i in dynamic:
		i.hide()
	for i in rich[1]:
		i.hide()
	
	## 初始化shader代码
	shader.code = """
	shader_type canvas_item;

	void fragment() {
		vec4 outlineColor = vec4(0.0, 1.0, 0.0, 1.0);  // 定义轮廓的颜色（绿色）和透明度（完全不透明）
		float outlineWidth = 0.04;  // 定义轮廓的宽度

		float alpha = texture(TEXTURE, UV).a;  // 获取当前像素的alpha值（透明度）
		float maxAlpha = 0.0;  // 初始化最大alpha值变量，用于确定周围像素的最大透明度

		for(int x = -1; x <= 1; x++) {
			for(int y = -1; y <= 1; y++) {
				vec2 offset = vec2(float(x), float(y)) * outlineWidth;  // 计算周围像素的偏移量
				maxAlpha = max(maxAlpha, texture(TEXTURE, UV + offset).a);  // 获取周围像素的alpha值，并更新最大alpha值
			}
		}

		if(maxAlpha > alpha)       // 如果周围像素的最大alpha值大于当前像素的alpha值
			COLOR = outlineColor;  // 将当前像素的颜色设置为轮廓颜色
		else                       // 否则，保持当前像素的原始颜色和透明度 
			COLOR = texture(TEXTURE, UV);
	}
	"""
	## 初始化shader
	return_button.material.shader = shader
	return_button.material.shader = null

func del_empty_button() -> void:     # 一开始随便定的一个用来出现选择框的空白按钮，这个函数来删掉
	if empty_button != null:
		empty_button.queue_free()

func solo_switch_hide_and_show() -> void:
	if still[0].visible == false:
		still[0].show()
		dynamic[0].hide()
		rich[0][0].show()
		rich[1][0].hide()
	else:
		still[0].hide()
		dynamic[0].show()
		rich[0][0].hide()
		rich[1][0].show()

func dynamic_switch_hide_and_show() -> void:
	if still[1].visible == false:
		still[1].show()
		dynamic[1].hide()
		rich[0][1].show()
		rich[1][1].hide()
	else:
		still[1].hide()
		dynamic[1].show()
		rich[0][1].hide()
		rich[1][1].show()


## solo 聚焦绑定
func _on_solo_button_focus_entered():
	solo_switch_hide_and_show()
	del_empty_button()

func _on_solo_button_focus_exited():
	solo_switch_hide_and_show()
	del_empty_button()

## party 聚焦绑定
func _on_party_button_focus_entered():
	dynamic_switch_hide_and_show()
	del_empty_button()

func _on_party_button_focus_exited():
	dynamic_switch_hide_and_show()
	del_empty_button()

func _on_solo_button_pressed():
	Transitions.tran_d_0_without_loading_and_out("res://UI/CharacterSelect.tscn")


func _on_party_button_pressed():
	pass # 选人 -> 大地图


func _on_return_button_focus_entered():
	return_button.material.shader = shader

func _on_return_button_focus_exited():
	return_button.material.shader = null

func _on_return_button_pressed():
	Transitions.tran_d_0_without_loading("res://UI/title_menu.tscn")
