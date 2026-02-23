Shader "Custom/CommonFuncs_04_Smoothstep"
{
    Properties
    {
        _Tint01("Tint01", Color) = (1,1,1,1)
        _Tint02("Tint02", Color) = (1,1,1,1)
        _StepEdgeStart("StepEdgeStart", Range(0.0 ,1.0)) = 1.0
        _StepEdgeEnd("StepEdgeEnd", Range(0.0 ,1.0)) = 1.0
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
            half4 _Tint01;
            half4 _Tint02;
            half _StepEdgeStart;
            half _StepEdgeEnd;
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
                half edge_step = smoothstep(_StepEdgeStart, _StepEdgeEnd, i.uvs.x);

                half3 col_smoothstep = lerp(_Tint01.xyz, _Tint02.xyz, edge_step);
                half4 col_output = half4(col_smoothstep, 1.0);
                return col_output;
            }

            ENDHLSL
        }
    }
}
