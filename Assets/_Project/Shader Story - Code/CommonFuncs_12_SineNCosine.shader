Shader "Custom/CommonFuncs_12_SineNCosine"
{
    Properties
    {
        _Frequency("Frequency", Range(0.01, 10.0)) = 1.0
        [Toggle(USE_COSINE)] _UseCosine("useCosine", Int) = 0        
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
                float2 uvs : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                float2 uvs : TEXCOORD0;
            };

            CBUFFER_START(UnityPerMaterial)
            half _Frequency;
            CBUFFER_END
            
            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.uvs = IN.uvs;
                return OUT;
            }

            half2 remap(half2 In, half2 InMinMax, half2 OutMinMax)
            {
                return OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }

            half4 frag(Varyings IN) : SV_Target
            {
                half time = _TimeParameters.x * _Frequency;

                #ifdef USE_COSINE
                    half oscillation = cos(time);
                #else
                    half oscillation = sin(time);
                #endif

                half2 shape = remap(IN.uvs, half2(0, 1), half2(-1, 1));
                shape = saturate(1 - distance(half2(0, 0), shape));

                oscillation = (oscillation - 1) + shape;

                half4 col_output = half4(oscillation.xxx, 1.0);
                return col_output;
                
            }
            ENDHLSL
        }
    }
}
