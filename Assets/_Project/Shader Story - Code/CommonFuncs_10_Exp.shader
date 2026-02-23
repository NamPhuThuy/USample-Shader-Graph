Shader "Custom/CommonFuncs_10_Exp"
{
    Properties
    {
        _Tint01("Tint01", Color) = (1,1,1,1)
        _Tint02("Tint02", Color) = (1,1,1,1)
        _ExpFactor("ExpFactor", Range(0.01, 3.0)) = 3.0
        [Toggle(USE_EXP2)] _UseExp2("useExp2", Int) = 0

        [Toggle(SHOW_GRAPH)] _ShowGraph("showGraph", Int) = 0
        _GraphLineWidth("Graph_LineWidth", Range(0.005, 0.025)) = 0.02
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" "RenderPipeline" = "UniversalPipeline" }

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            #pragma shader_feature_local USE_EXP2
            #pragma shader_feature_local SHOW_GRAPH

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
            half3 _Tint01;
            half3 _Tint02;
            half _ExpFactor;
            half _GraphLineWidth;
            CBUFFER_END

            Varyings vert (Attributes IN)
            {
                Varyings OUT;

                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.uvs = IN.uvs;
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                half uvsX = -IN.uvs.x * _ExpFactor;
                #ifdef USE_EXP2
                    half exp_output = saturate(exp2(uvsX + 0.001));
                #else
                    half exp_output = saturate(exp(uvsX + 0.001));
                #endif

                half3 col_output = lerp(_Tint01, _Tint02, exp_output);

                #ifdef SHOW_GRAPH
                    half graph_line = saturate(1 - smoothstep(0.0, _GraphLineWidth, abs(IN.uvs.y - exp_output)));
                    col_output += graph_line;
                #endif

                return half4(col_output, 1.0);
            }

            ENDHLSL
        }
    }
}
