// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Custom/Spec_vf" 
{
   Properties 
   {
	  _MipBias	 ("Mipmap Bias",Float) = -1.0
      _MainTex 	 ("Base(RGB)", 2D) =  "white" {}
	  _MaskTex 	 ("SpeculaMask", 2D) = "white" {}
      _Shininess ("Specular Shininess", Float) = 10	
      _SpecularBrightness ("Specular Brightness", Float) = 1	 
      _Diffuse("Diffuse", Float) = 0.8

   }

	SubShader 
	{
	 	Tags { "LightMode" = "ForwardBase" "Queue"="Geometry" "IgnoreProjector"="True" "RenderType"="Opaque"}
 		 		 			
		Pass 
		{  
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest	
			#pragma multi_compile_fog	
			#include "UnityCG.cginc"
			
			sampler2D 	 	_MainTex;			 		 	 	 		 
		 	sampler2D  		_MaskTex;
									 			 				 			 	 		       
		 	half 		 	_Shininess;
		 	half 		 	_SpecularBrightness; 

		 	fixed4 			_LightColor0;  	 
			half			_Diffuse;    
			half 			_MipBias;  					 		 	  			 		 	  			 		 	  			 		 	  

 			struct appdata_t 
			{
			    float4 vertex    : POSITION;
			    half2 texcoord   : TEXCOORD0;
			    half3 normal 	 : NORMAL;
			    half4 tangent 	 : TANGENT;
			};
			
			struct v2f
			{
			    float4  pos 			 : SV_POSITION;
			    half2   uv  			 : TEXCOORD0;		     			     
			    half3   diffuse       	 : TEXCOORD1;
			    half3   specular       	 : TEXCOORD2;
				UNITY_FOG_COORDS(4)    			    	    	    			    			    		    		    			         
			};
							
			  v2f vert (appdata_t v)
			{         	
            	v2f o;
			    float4x4 modelMatrix 		  = unity_ObjectToWorld;
			    float4x4 modelMatrixInverse   = unity_WorldToObject; 
			    		    
            	half3 normalVector 		= normalize(mul(half4(v.normal, 0.0), modelMatrixInverse).xyz);            			
				half3 lightVector		= normalize(_WorldSpaceLightPos0.xyz); 																																					
				half3 cameraVector		= normalize(_WorldSpaceCameraPos - mul(modelMatrix, v.vertex));
				half3 halfVector     	= normalize(cameraVector + lightVector);

				o.diffuse 			= max(0.0, dot(normalVector, lightVector));
				o.specular 			= pow(max(0.0, dot(halfVector,normalVector)),_Shininess) ;       

			    o.uv 		 	 	= v.texcoord;	
			    o.pos 			 	= UnityObjectToClipPos(v.vertex);


				UNITY_TRANSFER_FOG(o,o.pos);            
			    return o;				
			}

			fixed4 frag (v2f i) : COLOR
			{				
			 	fixed3 albedo 	  	 = tex2Dbias(_MainTex, fixed4(i.uv.x,i.uv.y,0.0,_MipBias));//offset miplevel 
			 	fixed3 mask 	  	 = tex2Dbias(_MaskTex, fixed4(i.uv.x,i.uv.y,0.0,_MipBias));//offset miplevel 
				fixed diffuse = saturate(i.diffuse + (1.0 - _Diffuse));        				   		     		                              		     		                              							                                          		                                 		    
				fixed3 	col = albedo * fixed3(1.0,1.0,1.0)* diffuse + i.specular * _SpecularBrightness * mask;
								UNITY_APPLY_FOG_COLOR(i.fogCoord, col, (fixed3)1.0); 				
		
			    return fixed4(col*_LightColor0.xyz,1.0);
			}

			ENDCG 
		}	
	}
}