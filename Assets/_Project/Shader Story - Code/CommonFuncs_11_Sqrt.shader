Shader "Custom/CommonFuncs_11_Sqrt"
{
    Properties
    {
        _Tint01("Tint01", Color) = (1, 1, 1, 1)
        _Tint02("Tint02", Color) = (1, 1, 1, 1)
        [Toggle(INVERSE_SQRT)] _SqrtInverse("inverseSqrt", Int) = 0
        
        [Toggle(SHOW_GRAPH)] _ShowGraph("showGraph", Int) = 0
        _GraphLineWidth("Graph_LineWitdh", Range(0.005, 0.025)) = 0.02
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

            #pragma shader_feature_local INVERSE_SQRT
            #pragma shader_feature_local SHOW_GRAPH
            
            struct Attributes
            {
                float4 positionOS : POSITION;
                float2 uvs : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                float2 uvs : TEXCOORD0;
            };

            CBUFFER_START(UnityPerMaterial)
            half3 _Tint01;
            half3 _Tint02;
            half _GraphLineWidth;
            CBUFFER_END

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.uvs = IN.uvs;

                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                #ifdef INVERSE_SQRT
                    half sqrt_output = saturate(rsqrt(IN.uvs.x + 0.001));
                #else
                    half sqrt_output = sqrt(IN.uvs.x + 0.001);
                #endif

                half3 col_output = lerp(_Tint01, _Tint02, sqrt_output);

                #ifdef SHOW_GRAPH
                    half graph_line = saturate(1 - smoothstep(0.0, _GraphLineWidth, abs(IN.uvs.y - sqrt_output)));
                    col_output += graph_line;
                #endif

                return half4(col_output, 1.0);
            }
            ENDHLSL
        }
    }
}
