shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

uniform bool active=true;//控制图片闪烁

void fragment() {
	vec4 previous_color=texture(TEXTURE,UV);//获取图片每一个像素的颜色
	vec4 write_color=vec4(1.0,1.0,1.0,previous_color.a);//设置图片颜色（红，绿，蓝，透明度）
	vec4 new_color=previous_color;//原本图片颜色，恢复作用
	if(active==true){
		COLOR=write_color;//输出图片颜色
	}
	else{
		COLOR=new_color;//恢复为原状
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
