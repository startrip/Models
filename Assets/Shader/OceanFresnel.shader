Shader "Ocean/Ocean Fresnel" 
{
	Properties 
	{
		_SeaColor("SeaColor", Color) = (1,1,1,1)
	}
	SubShader 
	{
		Tags { "Queue"="AlphaTest" "RenderType"="Transparent" }
		LOD 200
		
		CGPROGRAM
			#pragma surface surf Lambert alpha
			#pragma target 2.0

			uniform sampler2D _Map;
		
			float3 _SeaColor;

			struct Input 
			{
				float3 worldPos;
			};
		
			float Fresnel(float3 V, float3 N)
			{
				float costhetai = abs(dot(V, N));
				return (pow(1-costhetai,6)) * 0.3;
			}
		
			void surf(Input IN, inout SurfaceOutput o) 
			{
				float2 uv = IN.worldPos.xz;
			
//				float2 slope = tex2D(_Map2, uv/28).xy*2.0-1.0;
			
//				float3 N = normalize(float3(-slope.x, 1.0, -slope.y)); //shallow normal

				float3 N = tex2D(_Map, uv/28).xyz*2.0-1.0;
			
				float3 V = normalize(_WorldSpaceCameraPos-IN.worldPos);

				float fresnel = Fresnel(V, N);

				o.Albedo = _SeaColor;
				o.Alpha = 1 - fresnel;
			}
		ENDCG
	} 
	FallBack Off
}
