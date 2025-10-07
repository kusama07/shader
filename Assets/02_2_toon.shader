Shader "Unlit/02_2_toon"
{
    Properties
    {
       _Color("Color",Color) = (1,0,0,1)
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            fixed4 _Color;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float a = 0.5;
                float b = 0.55;
                float x = saturate(dot(normalize(i.normal), _WorldSpaceLightPos0));
                float shard = smoothstep(a,b,x);

                fixed4 color = _Color;
                
                fixed4 ambient = color * 0.3 * _LightColor0;
                
                fixed4 toon = color * shard * _LightColor0;



                return toon + ambient;
            }
            ENDCG
        }
    }
}
