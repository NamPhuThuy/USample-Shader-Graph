Shader "Custom/CommonFuncs_06_Remap"
{
   Properties
    {
        _BaseMap("BaseMap", 2D) = "white" {}
        _Remap_MinX_MinY_MaxX_MaxY("Remap_MinX_MinY_MaxX_MaxY", Vector) = (0,1,0,1)
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
                half2 uvs : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                half2 uvs : TEXCOORD0;
            };

            CBUFFER_START(UnityPerMaterial)

            TEXTURE2D(_BaseMap);
            SAMPLER(sampler_BaseMap);
            half4 _BaseMap_ST;
            half4 _Remap_MinX_MinY_MaxX_MaxY;

            CBUFFER_END

            half inverseLerp(half inputValue, half minValue, half maxValue)
            {
                return (inputValue - minValue) / (maxValue - minValue);
            }

            half remap(half inputValue, half inMin, half inMax, half outMin, half outMax)
            {
                half normalizedPos = inverseLerp(inputValue, inMin, inMax);
                return lerp(outMin, outMax, normalizedPos);
            }

            Varyings vert (Attributes IN)
            {
                Varyings OUT;

                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.uvs = TRANSFORM_TEX(IN.uvs, _BaseMap);

                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                half4 col_baseMap = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, IN.uvs);
                half col_Remap = remap(col_baseMap.r, _Remap_MinX_MinY_MaxX_MaxY.x, _Remap_MinX_MinY_MaxX_MaxY.y,_Remap_MinX_MinY_MaxX_MaxY.z,_Remap_MinX_MinY_MaxX_MaxY.w);

                half4 col_Output = half4(col_Remap, col_Remap, col_Remap, 1.0);
                return col_Output;
            }

            ENDHLSL
        }
    }
}
