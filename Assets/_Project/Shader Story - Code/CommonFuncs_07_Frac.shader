Shader "Custom/CommonFuncs_07_Frac"
{
     Properties
        {
            _UVTile("UVTile", Range(0.5, 10.0)) = 1.0
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
                    return half4(frac(i.uvs * _UVTile), 0.0, 1.0);
                }
    
                ENDHLSL
            }
        }
}
