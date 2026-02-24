Shader "Custom/CommonFuncs_14_Lerp"
{
    Properties
    {
        _Tint_01("Tint_01", Color) = (1.0, 0.0, 0.0, 1.0)
        _Tint_02("Tint_02", Color) = (0.0, 0.0, 1.0, 1.0)
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
                half4 _Tint_01;
                half4 _Tint_02;
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
                return half4(lerp(_Tint_01.xyz, _Tint_02.xyz, IN.uvs.x), 1.0);  
            }
            ENDHLSL
        }
    }
}
