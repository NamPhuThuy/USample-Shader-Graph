Shader "Custom/CommonFuncs_17_Normalize"
{
    Properties
    {
        _Tint_01("Tint_01", Color) = (1, 1, 1, 1)
        _Tint_02("Tint_02", Color) = (1, 1, 1, 1)
        [Toggle(NORMALIZE)] _Normalize("Normalize", Int) = 0
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #pragma shader_feature_local NORMALIZE

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
                half3 _Tint_01;
                half3 _Tint_02;
            CBUFFER_END

            half2 remap(half2 In, half2 InMinMax, half2 OutMinMax)
            {
                return OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.uvs = IN.uvs;
                
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                half lerp_shape = saturate(1 - distance(remap(IN.uvs, half2(0, 1), half2(-1, 1)), half2(0, 0)));
                half3 lerp_color = lerp(_Tint_01.xyz, _Tint_02.xyz, lerp_shape) ;

                #ifdef  NORMALIZE
                    half3 col_output = normalize(lerp_color);
                #else
                    half3 col_output = lerp_color;
                #endif
                
                return half4(col_output, 1.0);
            }
            ENDHLSL
        }
    }
}
