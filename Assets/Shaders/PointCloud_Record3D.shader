Shader "PointCloud/Record3D" {
    
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _DispTex ("Displacement Texture", 2D) = "gray" {}
        _Displacement ("Displacement", Range(0, 1.0)) = 0.1
        _ChannelFactor ("ChannelFactor (r,g,b)", Vector) = (1,0,0)
        _Range ("Range (min,max)", Vector) = (0,0.5,0)
        _ClipRange ("ClipRange [0,1]", float) = 0.8
	}
 
    SubShader {
        Tags { "RenderType"="Opaque" }
        Cull Front
        Lighting Off 
        LOD 300
 
        CGPROGRAM
        #pragma surface surf Lambert vertex:disp nolightmap
        #pragma target 3.0
        #pragma glsl
 
        sampler2D _DispTex;
        float _Displacement;
        float3 _ChannelFactor;
        float2 _Range;
        float _ClipRange;
 
		// Modified "rgb2hsv()" from this source: https://stackoverflow.com/a/17897228
		float rgb2hue(float3 c) {
			float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
			float4 p = lerp(float4(c.bg, K.wz), float4(c.gb, K.xy), step(c.b, c.g));
			float4 q = lerp(float4(p.xyw, c.r), float4(c.r, p.yzx), step(p.x, c.r));

			float d = q.x - min(q.w, q.y);
			float e = 1.0e-10;
			return abs(q.z + (q.w - q.y) / (6.0 * d + e));
		}

		float getPixelDepth(float3 c) {
			float hue = rgb2hue(c);
			float pixelDepth = 3.0 * hue;
			return pixelDepth;
		}

        struct Input {
            float2 uv_DispTex;
			float2 uv_MainTex;
        };
 
        void disp(inout appdata_full v) {
            float3 dcolor = tex2Dlod (_DispTex, float4(v.texcoord.xy,0,0));
            float d = (dcolor.r*_ChannelFactor.r + dcolor.g*_ChannelFactor.g + dcolor.b*_ChannelFactor.b);
            v.vertex.xyz += v.normal * d * _Displacement;
        }
 
        sampler2D _MainTex;
		
		void surf(Input IN, inout SurfaceOutput o) {
			fixed4 mainTex = tex2D(_MainTex, IN.uv_MainTex);
			o.Emission = mainTex.rgb;
		}
        
        ENDCG
    }

    FallBack "Diffuse"

}