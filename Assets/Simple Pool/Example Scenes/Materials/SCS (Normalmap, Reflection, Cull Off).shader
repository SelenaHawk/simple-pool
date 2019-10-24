﻿// MIT license - https://nvjob.github.io/mit-license
// #NVJOB Nicholas Veselov - https://nvjob.github.io
// NVJOB Specular Customizable Shaders V1.1.1 - https://github.com/nvjob/nvjob-specular-customizable-shaders


Shader "#NVJOB/SCS/Normalmap, Reflection, Cull Off" {


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



Properties{
//----------------------------------------------

_Color("Main Color", Color) = (1,1,1,1)
_SpecColor("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
_Shininess("Shininess", Range(0.03, 1)) = 0.078125
_MainTex("Base (RGB) Gloss (A)", 2D) = "white" {}
_BumpMap("Normalmap", 2D) = "bump" {}
_IntensityNm("Intensity Normalmap", Range(-20, 20)) = 1
_ReflectColor("Reflection Color", Color) = (1,1,1,0.5)
_IntensityRef("Intensity Reflection", Range(0, 20)) = 1
_Cube("Reflection Cubemap", Cube) = "" {}
_Saturation("Saturation", Range(0, 5)) = 1
_Brightness("Brightness", Range(0, 5)) = 1
_Contrast("Contrast", Range(0, 5)) = 1

//----------------------------------------------
}



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



SubShader{
//----------------------------------------------

Tags{ "RenderType" = "Opaque" }
Cull Off
LOD 200
CGPROGRAM
#pragma surface surf BlinnPhong exclude_path:prepass nolppv noforwardadd interpolateview novertexlights

//----------------------------------------------

sampler2D _MainTex, _BumpMap;
fixed4 _Color, _ReflectColor;
half _Shininess, _IntensityNm, _IntensityRef, _Saturation, _Contrast, _Brightness;
samplerCUBE _Cube;

//----------------------------------------------

struct Input {
float2 uv_MainTex;
float2 uv_BumpMap;
float3 viewDir;
float3 worldRefl;
INTERNAL_DATA
};

//----------------------------------------------

void surf(Input IN, inout SurfaceOutput o) {
fixed4 tex = tex2D(_MainTex, IN.uv_MainTex) * _Color;
float Lum = dot(tex, float3(0.2126, 0.7152, 0.0722));
half3 color = lerp(Lum.xxx, tex, _Saturation);
color = color * _Brightness;
o.Albedo = (color - 0.5) * _Contrast + 0.5;
o.Gloss = tex.a;
o.Specular = _Shininess;
fixed3 normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
normal.x *= _IntensityNm;
normal.y *= _IntensityNm;
o.Normal = normalize(normal);
fixed4 reflcol = texCUBE(_Cube, WorldReflectionVector(IN, o.Normal));
reflcol *= _IntensityRef;
reflcol *= tex.a;
o.Emission = reflcol.rgb * _ReflectColor.rgb;
}

//----------------------------------------------

ENDCG

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
}


Fallback "Legacy Shaders/VertexLit"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}