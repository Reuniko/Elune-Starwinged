// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "@Xxuebi/Ring_FireEnd_V02"
{
	Properties
	{
		[HDR]_M_Color("M_Color", Color) = (0,0,0,0)
		_Main_Tex("Main_Tex", 2D) = "white" {}
		_Main_Int("Main_Int", Float) = 0
		_Main_U("Main_U", Float) = 0
		_Main_V("Main_V", Float) = 0
		_Mask_01("Mask_01", 2D) = "white" {}
		_Mask_01_Int("Mask_01_Int", Float) = 0
		_Mask1_U("Mask1_U", Float) = 0
		_Mask1_V("Mask1_V", Float) = 0
		_Mask_02("Mask_02", 2D) = "white" {}
		_Mask2_U("Mask2_U", Float) = 0
		_Mask2_V("Mask2_V", Float) = 0
		_Noise_Tex("Noise_Tex", 2D) = "white" {}
		_Noise_U("Noise_U", Float) = 0
		_Noise_V("Noise_V", Float) = 0
		_Noise_Int("Noise_Int", Float) = 0

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" "Queue"="Transparent+3000" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite Off
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float4 _M_Color;
			uniform float _Main_Int;
			uniform sampler2D _Main_Tex;
			uniform float _Main_U;
			uniform float _Main_V;
			uniform float _Noise_Int;
			uniform sampler2D _Noise_Tex;
			SamplerState sampler_Noise_Tex;
			uniform float _Noise_U;
			uniform float _Noise_V;
			uniform float4 _Noise_Tex_ST;
			uniform float4 _Main_Tex_ST;
			uniform float _Mask_01_Int;
			uniform sampler2D _Mask_01;
			SamplerState sampler_Mask_01;
			uniform float _Mask1_U;
			uniform float _Mask1_V;
			uniform float4 _Mask_01_ST;
			uniform sampler2D _Mask_02;
			SamplerState sampler_Mask_02;
			uniform float _Mask2_U;
			uniform float _Mask2_V;
			uniform float4 _Mask_02_ST;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 appendResult52 = (float2(_Main_U , _Main_V));
				float2 appendResult127 = (float2(_Noise_U , _Noise_V));
				float2 uv_Noise_Tex = i.ase_texcoord1.xy * _Noise_Tex_ST.xy + _Noise_Tex_ST.zw;
				float2 panner124 = ( 1.0 * _Time.y * appendResult127 + uv_Noise_Tex);
				float2 uv_Main_Tex = i.ase_texcoord1.xy * _Main_Tex_ST.xy + _Main_Tex_ST.zw;
				float2 panner53 = ( 1.0 * _Time.y * appendResult52 + ( ( _Noise_Int * tex2D( _Noise_Tex, panner124 ).r ) + uv_Main_Tex ));
				float2 appendResult105 = (float2(_Mask1_U , _Mask1_V));
				float2 uv_Mask_01 = i.ase_texcoord1.xy * _Mask_01_ST.xy + _Mask_01_ST.zw;
				float2 panner107 = ( 1.0 * _Time.y * appendResult105 + uv_Mask_01);
				float temp_output_117_0 = ( _Mask_01_Int * tex2D( _Mask_01, panner107 ).r );
				float2 appendResult112 = (float2(_Mask2_U , _Mask2_V));
				float2 uv_Mask_02 = i.ase_texcoord1.xy * _Mask_02_ST.xy + _Mask_02_ST.zw;
				float2 panner114 = ( 1.0 * _Time.y * appendResult112 + uv_Mask_02);
				float4 tex2DNode115 = tex2D( _Mask_02, panner114 );
				float clampResult120 = clamp( ( temp_output_117_0 * tex2DNode115.r ) , 0.0 , 1.0 );
				
				
				finalColor = ( _M_Color * ( ( _Main_Int * tex2D( _Main_Tex, panner53 ) ) * clampResult120 ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	Fallback "True"
}
/*ASEBEGIN
Version=18600
270;460;1926;688;4060.561;202.5361;3.750762;True;True
Node;AmplifyShaderEditor.RangedFloatNode;125;-2260.393,282.11;Inherit;False;Property;_Noise_U;Noise_U;13;0;Create;True;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;126;-2259.102,431.5972;Inherit;False;Property;_Noise_V;Noise_V;14;0;Create;True;0;0;False;0;False;0;-0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;127;-2027.038,300.3536;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;128;-2202.829,22.45737;Inherit;False;0;122;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;104;-1720.39,1223.463;Inherit;False;Property;_Mask1_U;Mask1_U;7;0;Create;True;0;0;False;0;False;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;103;-1719.099,1372.95;Inherit;False;Property;_Mask1_V;Mask1_V;8;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;124;-1813.67,192.4169;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;111;-1433.586,1780.394;Inherit;False;Property;_Mask2_U;Mask2_U;10;0;Create;True;0;0;False;0;False;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;106;-1659.027,1045.087;Inherit;False;0;108;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;110;-1432.295,1929.881;Inherit;False;Property;_Mask2_V;Mask2_V;11;0;Create;True;0;0;False;0;False;0;-0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;105;-1439.382,1267.121;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;122;-1484.868,295.6634;Inherit;True;Property;_Noise_Tex;Noise_Tex;12;0;Create;True;0;0;False;0;False;-1;None;f00e90e9a7d9431448c952d9020b0776;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;129;-1297.439,114.585;Inherit;False;Property;_Noise_Int;Noise_Int;15;0;Create;True;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;113;-1372.223,1602.018;Inherit;False;0;115;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;112;-1152.579,1824.053;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;51;-1493.721,662.1474;Inherit;False;0;55;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;48;-1571.203,757.6251;Inherit;False;Property;_Main_U;Main_U;3;0;Create;True;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-1569.912,907.1122;Inherit;False;Property;_Main_V;Main_V;4;0;Create;True;0;0;False;0;False;0;-0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;107;-1207.53,1116.519;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;130;-1132.244,305.1936;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;114;-920.7288,1673.451;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;108;-848.8367,1191.935;Inherit;True;Property;_Mask_01;Mask_01;5;0;Create;True;0;0;False;0;False;-1;None;8de25b8e74a375d4591062842a707dce;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;116;-638.0181,1077.478;Inherit;False;Property;_Mask_01_Int;Mask_01_Int;6;0;Create;True;0;0;False;0;False;0;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;123;-844.9401,476.3149;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;52;-1290.195,801.2832;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;115;-538.5499,1662.753;Inherit;True;Property;_Mask_02;Mask_02;9;0;Create;True;0;0;False;0;False;-1;None;f00e90e9a7d9431448c952d9020b0776;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;-420.9099,1148.996;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;53;-584.2529,692.6368;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;55;-244.666,757.1281;Inherit;True;Property;_Main_Tex;Main_Tex;1;0;Create;True;0;0;False;0;False;-1;None;8a58b267ba953c94aa6982b53b9ec56c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;121;-240.888,1302.225;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;132;-73.03863,530.3961;Inherit;False;Property;_Main_Int;Main_Int;2;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;120;-23.80348,1141.424;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;108.7203,700.6928;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;215.345,980.0558;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;43;262.8541,594.1989;Inherit;False;Property;_M_Color;M_Color;0;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;1,1,1,0.7411765;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;526.2019,744.1262;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;118;-204.8192,1393.118;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;86;802.2235,652.4025;Float;False;True;-1;2;ASEMaterialInspector;100;1;@Xxuebi/Ring_FireEnd_V02;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;0;5;False;-1;10;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;2;RenderType=Opaque=RenderType;Queue=Transparent=Queue=3000;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;True;0;0;-1;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;127;0;125;0
WireConnection;127;1;126;0
WireConnection;124;0;128;0
WireConnection;124;2;127;0
WireConnection;105;0;104;0
WireConnection;105;1;103;0
WireConnection;122;1;124;0
WireConnection;112;0;111;0
WireConnection;112;1;110;0
WireConnection;107;0;106;0
WireConnection;107;2;105;0
WireConnection;130;0;129;0
WireConnection;130;1;122;1
WireConnection;114;0;113;0
WireConnection;114;2;112;0
WireConnection;108;1;107;0
WireConnection;123;0;130;0
WireConnection;123;1;51;0
WireConnection;52;0;48;0
WireConnection;52;1;49;0
WireConnection;115;1;114;0
WireConnection;117;0;116;0
WireConnection;117;1;108;1
WireConnection;53;0;123;0
WireConnection;53;2;52;0
WireConnection;55;1;53;0
WireConnection;121;0;117;0
WireConnection;121;1;115;1
WireConnection;120;0;121;0
WireConnection;133;0;132;0
WireConnection;133;1;55;0
WireConnection;109;0;133;0
WireConnection;109;1;120;0
WireConnection;44;0;43;0
WireConnection;44;1;109;0
WireConnection;118;0;117;0
WireConnection;118;1;115;1
WireConnection;86;0;44;0
ASEEND*/
//CHKSM=D646585B485A042796C8C87917813D07F18F9A0C