Shader "Custom/CommonFuncs_16_Cross"
{
    Properties
    {
        [Toggle(CROSS_BXA)]_Cross_BxA("Cross_BxA", Int) = 0
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #pragma shader_feature_local CROSS_BXA
            
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                half3 normalOS : NORMAL;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                half3 normalVS : TEXCOORD0;
                half3 tangentTS : TEXCOORD1;
            };

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                half3 normalWS = TransformObjectToWorldNormal(IN.normalOS);
                OUT.normalVS = mul((float3x3)UNITY_MATRIX_V, normalWS);
                OUT.tangentTS = half3(1, 0, 0); // In tangent space, the tangent vector is always (1, 0, 0)

                
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                #ifdef CROSS_BXA
                    half3 col_output = cross(IN.tangentTS, IN.normalVS);
                #else
                    half3 col_output = cross(IN.normalVS, IN.tangentTS);
                #endif
                

                return half4(col_output, 1.0);
            }
            ENDHLSL
        }
    }
}
