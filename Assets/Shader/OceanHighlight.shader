Shader "Ocean/Ocean Highlight" 
{
	Properties 
	{
		_SunPow("SunPow", float) = 256
		_SunColor("SunColor", Color) = (1,1,1,1)
		_IvnSunPow("Invers Sun Pow", float) = 1
	}
	SubShader 
	{
		Tags { "Queue"="Transparent-100" "RenderType"="Transparent" }
		LOD 200
		Lighting Off
		ZWrite Off
		Fog { Mode Off }
		Blend One One
		
		CGPROGRAM
			#pragma surface surf Lambert
			#pragma target 2.0
			#include "UnityCG.cginc"

			uniform sampler2D _Map;
			uniform float3 _SunDir;
		
			float _SunPow;
			float3 _SunColor;
			float _IvnSunPow;

			struct Input 
			{
				float3 worldPos;
			};

			float Sun(float3 V, float3 N)
			{
				float3 H = V+_SunDir;
				H.y = max(H.y, dot(V,_SunDir)*_IvnSunPow);
				H = normalize(H);
				return pow(abs(dot(H,N)), _SunPow);
			}
		
			void surf(Input IN, inout SurfaceOutput o) 
			{
				float2 uv = IN.worldPos.xz;
			
				float2 slope = tex2D(_Map, uv/12).xy*2.0-1.0;
			
				float3 N = normalize(float3(-slope.x, 0.5, -slope.y));
			
				float3 V = normalize(_WorldSpaceCameraPos-IN.worldPos);

				o.Albedo = _SunColor * Sun(V, N);
				o.Alpha = 1;
			}
		ENDCG
	} 
	FallBack Off
}
