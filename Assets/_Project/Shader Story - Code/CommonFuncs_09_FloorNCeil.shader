Shader "Custom/CommonFuncs_09_FloorNCeil"
{
     Properties
    {
        _UVTile("UVTile", Range(0.5, 10.0)) = 1.0
        _RemapFactor("RemapFactor", Range(2.0, 10.0)) = 3.0 
        [Toggle(USE_CEIL)]_UseCeil("useCeil", int) = 0
        [Toggle(USE_FLOOR)]_UseFloor("useFloor", int) = 0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" "RenderPipeline" = "UniversalPipeline" }

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #pragma shader_feature USE_CEIL
            #pragma shader_feature USE_FLOOR

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
            half _RemapFactor;
            half _UVTile;
            CBUFFER_END

            Varyings vert (Attributes IN)
            {
                Varyings OUT;

                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.uvs = IN.uvs;
                return OUT;
            }

            half2 map(half2 value, half inMin, half inMax, half outMin, half outMax)
            {
                half inRange = 1.0 / (inMax - inMin); 
                half outRange = outMax - outMin;      
                return (value - inMin) * inRange * outRange + outMin;
            }

            half4 frag(Varyings i) : SV_Target
            {
                half2 uvs = saturate(frac(i.uvs * _UVTile) - 0.5);
                half2 uvs_remap = map(uvs, 0, 1, 0, _RemapFactor);

                #ifdef USE_CEIL
                    half2 col_ceil = ceil(uvs_remap);
                #else
                    half2 col_ceil = uvs_remap;
                #endif

                #ifdef USE_FLOOR
                    half2 col_floor = floor(col_ceil);
                #else
                    half2 col_floor = col_ceil;
                #endif

                half2 col_output = saturate(mul(uvs, col_floor));

                return half4(col_output.x, col_output.x, col_output.x, 1.0);

            }

            ENDHLSL
        }
    }
}
