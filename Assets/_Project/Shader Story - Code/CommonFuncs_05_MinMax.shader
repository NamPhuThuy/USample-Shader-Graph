Shader "Custom/CommonFuncs_05_MinMax"
{
    Properties
    {
        _Min("Min", Range(0.0, 1.0)) = 0.0
        _Max("Max", Range(0.0, 1.0)) = 0.0
        [Toggle(SHOW_MAX)] _ShowMax("showMax", Int) = 0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" "RenderPipeline" = "UniversalPipeline" }

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #pragma shader_feature SHOW_MAX

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                half2 uvs: TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                half2 uvs: TEXCOORD0;
            };

            CBUFFER_START(UnityPerMaterial)
            half _Min;
            half _Max;
            CBUFFER_END

            Varyings vert (Attributes IN)
            {
                Varyings OUT;

                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.uvs = IN.uvs;
                return OUT;
            }

            half4 frag(Varyings i) : SV_Target
            {
                #ifdef SHOW_MAX
                    half result = max(i.uvs.x, _Max);
                #else
                    half result = min(i.uvs.x, _Min);
                #endif

                return half4(result, result, result, 1.0);
            }

            ENDHLSL
        }
    }
}
