Shader "Custom/CommonFuncs_02_Step"
{
    Properties
    {
        _Step("Step", Range(0.0 ,1.0)) = 1.0
    }

    SubShader
    {
        // "Queue" controls the rendering order. Common values: Background, Geometry, AlphaTest, Transparent, Overlay.
        // "RenderType" categorizes shaders (e.g., Opaque, Transparent) for replacement or post-processing.
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" "Queue" = "Geometry" }

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            CBUFFER_START(UnityPerMaterial)
            half _Step;
            CBUFFER_END

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.uv = IN.uv;
                return OUT;
            }

            half4 frag(Varyings i) : SV_Target
            {
                half col_step = step(_Step, i.uv.x);
                half4 col_output = half4(col_step, col_step, col_step, 1.0);
                return col_output;
            }
            ENDHLSL
        }
    }
}
