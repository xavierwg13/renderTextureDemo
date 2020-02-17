Shader "Hidden/Blur 1"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;

            fixed4 frag (v2f i) : SV_Target
            {
                float weight1[] = {0.003, 0.015, 0.02, 0.015, 0.003};
                float weight2[] = {0.015, 0.059, 0.095, 0.059, 0.015};
                float weight3[] = {0.023, 0.095, 0.150, 0.095, 0.023};

                float4 col = float4(0, 0, 0, 0);
                float texelSize = 0.0075;

                for(int x = 0; x < 5; x++) {
                    col += weight1[x] * tex2D(_MainTex, i.uv + float2(x - 2, -2) * texelSize);
                }
                for(x = 0; x < 5; x++) {
                    col += weight2[x] * tex2D(_MainTex, i.uv + float2(x - 2, -1) * texelSize);
                }
                for(x = 0; x < 5; x++) {
                    col += weight3[x] * tex2D(_MainTex, i.uv + float2(x - 2, 0) * texelSize);
                }
                for(x = 0; x < 5; x++) {
                    col += weight2[x] * tex2D(_MainTex, i.uv + float2(x - 2, 1) * texelSize);
                }
                for(x = 0; x < 5; x++) {
                    col += weight1[x] * tex2D(_MainTex, i.uv + float2(x - 2, 2) * texelSize);
                }

                return col;
            }
            ENDCG
        }
    }
}
