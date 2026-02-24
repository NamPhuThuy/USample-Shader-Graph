Shader "Custom/CommonFuncs_15_Dot"
{
    Properties
    {
        _Light_Direction("Light Direction", Vector) = (0, 1, 0, 0)
        _Tint_01("Tint_01", Color) = (0, 0, 0.2, 1)
        _Tint_02("Tint_02", Color) = (1, 1, 1, 1)
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                half3 normalOS : NORMAL;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                half3 normalWS : NORMAL;
            };

            CBUFFER_START(UnityPerMaterial)
                half3 _Light_Direction;
                half4 _Tint_01;
                half4 _Tint_02;
            CBUFFER_END

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.normalWS = TransformObjectToWorldNormal(IN.normalOS);
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                half3 n = normalize(IN.normalWS);
                half3 l = normalize(_Light_Direction);
                half d = saturate(dot(n, l));

                half3 col_output = lerp(_Tint_01.rgb, _Tint_02.rgb, d);
                return half4(col_output, 1.0);
            }
            ENDHLSL
        }
    }
}
