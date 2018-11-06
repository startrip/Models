Shader "Ocean/Ocean Reflect" 
{
	Properties 
	{
		_SkyBox("SkyBox", CUBE) = "" {}
	}
	SubShader 
	{
		Tags { "Queue"="Geometry" "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
			#pragma surface surf Lambert
			#pragma target 2.0

			uniform sampler2D _Map;
		
			samplerCUBE _SkyBox;

			struct Input 
			{
				float3 worldPos;
				float3 worldRefl;
				INTERNAL_DATA
			};
		
			void surf(Input IN, inout SurfaceOutput o) 
			{
				float2 uv = IN.worldPos.xz;
			
//				float2 slope = tex2D(_Map2, uv/28).xy*2.0-1.0;
			
//				float3 N = normalize(float3(-slope.x, 1.0, -slope.y)); //shallow normal

				float3 N = tex2D(_Map, uv/28).xyz*2.0-1.0;

				float3 skyColor = texCUBE(_SkyBox, WorldReflectionVector(IN, N.xzy)*float3(-1,1,1)).rgb;

				o.Albedo = skyColor;
				o.Alpha = 1;
			}
		ENDCG
	} 
	FallBack Off
}
