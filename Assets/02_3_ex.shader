Shader "Unlit/02_3_ex"
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
                float3 worldPosition : TEXCOORD1;
                float3 normal : NORMAL;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.worldPosition = mul(unity_ObjectToWorld, v.vertex);

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

                float intensity = saturate(dot(normalize(i.normal), _WorldSpaceLightPos0));
                fixed4 diffuse = color * intensity * _LightColor0;

                float3 eyeDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPosition);
                float3 lightDir = normalize(_WorldSpaceLightPos0);
                i.normal = normalize(i.normal);
                float3 reflectDir = -lightDir + 2 * i.normal * dot(i.normal,lightDir);
                fixed4 specular = pow(saturate(dot(reflectDir, eyeDir)), 20) * _LightColor0 * color;

                fixed4 phong = ambient + diffuse + specular;

                return toon + ambient;
            }
            ENDCG
        }
    }
}
