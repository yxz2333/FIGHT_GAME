# Shader
一般用的``ShaderMaterial``中的``Shader``
-  ``ShaderMaterial.set_shader_parameter("属性", 值)``
    - 例如：``set_shader_param("outlineColor", Color(1, 0, 0, 1))``，修改着色器``set_shader_param``颜色

***
<br>

## ``duplicate()``
``duplicate()``方法用于创建一个对象的副本，即**拷贝实例化对象**，用于**唯一化**不同资源，防止多个节点共用一个会发生动态修改的资源

***
<br>