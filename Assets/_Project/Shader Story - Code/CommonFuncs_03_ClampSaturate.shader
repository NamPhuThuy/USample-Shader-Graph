Shader "Custom/CommonFuncs_03_ClampSaturate"
{
    Properties
    {
        _Tint("Tint", Color) = (1.0, 1.0, 1.0, 1.0)
        _Glow_Radius("Glow_Radius", Range(0.0, 1.0)) = 0.3
        _Glow_Falloff("Glow_Falloff", Range(0.01, 1.0)) = 0.3
        [Toggle(USE_CLAMP)]_UseClamp("useClamp", Int) = 0
        _Clamp_Min("Clamp_Min", Float) = 0.1
        _Clamp_Max("Clamp_Max", Float) = 0.9
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" "RenderPipeline" = "UniversalPipeline" }

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #pragma shader_feature_local USE_CLAMP

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
            half4 _Tint;
            half _Glow_Radius;
            half _Glow_Falloff;
            half _Clamp_Min;
            half _Clamp_Max;
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
                half2 center = half2(0.5, 0.5);
                half dist = distance(IN.uvs, center);

                half glow_raw = 1.0 - smoothstep(_Glow_Radius, _Glow_Radius + _Glow_Falloff, dist);

                #if defined(USE_CLAMP)
                    half glow_clamped = clamp(glow_raw, _Clamp_Min, _Clamp_Max);
                #else
                    half glow_clamped = saturate(glow_raw);
                #endif

                half3 col_output = glow_clamped * _Tint.xyz;
                return half4(col_output, 1.0);
            }

            ENDHLSL
        }
    }
}
