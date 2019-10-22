﻿// MIT license
// Copyright (c) 2016 #NVJOB Nicholas Veselov - https://nvjob.github.io
// SkyBox Two Colors V1.1 - https://nvjob.github.io/unity/skyBox-two-colors


Shader "#NVJOB/SkyBox/Two Colors" {


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


Properties{
//----------------------------------------------

_ColorA("Color A", Color) = (0.0, 0.0, 0.0, 0)
_IntensityA("Intensity A", Float) = 1.1
_DirA("Direction A", Vector) = (0.18, -1.64, -0.19, 0)
[Space(5)]
_ColorB("Color B", Color) = (0.0, 0.4, 0.4, 0)
_IntensityB("Intensity B", Float) = 1.1
_DirB("Direction B", Vector) = (1.42, -2.26, -0.50, 0)
[Space(5)]
_NoiseScale("Noise Scale", Float) = 250
_NoiseIntensity("Noise Intensity", Float) = 1

//----------------------------------------------
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


CGINCLUDE

#include "UnityCG.cginc"

//----------------------------------------------

struct appdata {
float4 position : POSITION;
float3 texcoord : TEXCOORD0;
};

//----------------------------------------------

struct v2f {
float4 position : SV_POSITION;
float3 texcoord : TEXCOORD0;
float4 worldpos : any;
};

//----------------------------------------------

half4 _ColorA, _ColorB;
half4 _DirA, _DirB;
half _NoiseScale, _NoiseIntensity, _IntensityA, _IntensityB;


//----------------------------------------------

v2f vert(appdata v) {
v2f o;
o.position = UnityObjectToClipPos(v.position);
o.texcoord = v.texcoord;
o.worldpos = o.position;
return o;
}

//----------------------------------------------

half4 frag(v2f i) : COLOR{
float2 wc = (i.worldpos.xy / i.worldpos.w) * _NoiseScale;
float4 dither = (dot(float2(171.0f, 231.0f), wc.xy));
dither.rgb = frac(dither / float3(103.0f, 71.0f, 97.0f)) - float3(0.5f, 0.5f, 0.5f);
half d = dot(normalize(i.texcoord), _DirA) * (0.11f + _DirA.w) + _IntensityA;
half d2 = dot(normalize(i.texcoord), _DirB) * (0.11f + _DirB.w) + _IntensityB;
return (lerp(_ColorA, _ColorB, pow(d * d2, 2))) + (dither / 255.0f) * _NoiseIntensity;
}

//----------------------------------------------

ENDCG


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


SubShader {
//----------------------------------------------

Tags { "RenderType" = "Background" "Queue" = "Background" }

Pass {
ZWrite Off
Cull Off
Fog { Mode Off }
CGPROGRAM
#pragma fragmentoption ARB_precision_hint_fastest
#pragma vertex vert
#pragma fragment frag
ENDCG
}

//----------------------------------------------
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}