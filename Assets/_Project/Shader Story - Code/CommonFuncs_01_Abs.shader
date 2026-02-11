
Shader "NamPhuThuy/CommonFuncs/Abs"
{
    Properties
    {
        _UVTile("UVTile", Range(0.5, 10.0)) = 1.0
        [Toggle(USE_ABS)] _UseAbs("useAbs", Int) = 0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" "RenderPipeline" = "UniversalPipeline" }

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #pragma shader_feature USE_ABS

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
            half _UVTile;
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
                #ifdef USE_ABS
                    half2 abs_output = abs(frac(i.uvs * _UVTile) - 0.5);
                #else
                    half2 abs_output = frac(i.uvs * _UVTile) - 0.5;
                #endif

                half col_output = max(abs_output.x, abs_output.y);
                return half4(col_output, col_output, col_output, 1.0);
            }

            ENDHLSL
        }
    }
}

