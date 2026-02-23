Shader "Custom/WaterShader"
{
    Properties
    {
        _Color ("Color", Color) = (0.2, 0.5, 0.8, 0.5)
        _NormalTex1 ("Normal Texture 1", 2D) = "bump" {}
        _NormalTex2 ("Normal Texture 2", 2D) = "bump" {}
        _NoiseTex ("Noise Texture", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.8
        _Metallic ("Metallic", Range(0,1)) = 0.0
        
        _Scale ("Noise Scale", Range(0.01, 0.1)) = 0.03
        _Amplitude ("Wave Amplitude", Range(0.01, 0.5)) = 0.05
        _Speed ("Wave Speed", Range(0.01, 1.0)) = 0.15
        _NormalStrength ("Normal Strength", Range(0, 2)) = 1.0
        _NormalSpeed ("Normal Scroll Speed", Range(0.01, 1.0)) = 0.1
        _SoftFactor ("Soft Edge Factor", Range(0.01, 5.0)) = 1.0
        
        _DepthFactor ("Depth Fade Factor", Range(0.1, 5.0)) = 1.0
        _ShallowColor ("Shallow Water Color", Color) = (0.3, 0.7, 0.9, 0.5)
        _DeepColor ("Deep Water Color", Color) = (0.1, 0.3, 0.5, 0.9)
    }
    
    SubShader
    {
        Tags 
        { 
            "Queue"="Transparent"
            "RenderType"="Transparent"
            "IgnoreProjector"="True"
        }
        LOD 200
        
        CGPROGRAM
        #pragma surface surf Standard alpha:fade vertex:vert
        #pragma target 3.0
        
        sampler2D _NormalTex1;
        sampler2D _NormalTex2;
        sampler2D _NoiseTex;
        sampler2D_float _CameraDepthTexture;
        
        float4 _NormalTex1_ST;
        float4 _NormalTex2_ST;
        
        float _Scale;
        float _Amplitude;
        float _Speed;
        float _NormalStrength;
        float _NormalSpeed;
        float _SoftFactor;
        float _DepthFactor;
        
        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        fixed4 _ShallowColor;
        fixed4 _DeepColor;
        
        struct Input
        {
            float2 uv_NormalTex1;
            float2 uv_NormalTex2;
            float4 screenPos;
            float eyeDepth;
        };
        
        void vert(inout appdata_full v, out Input o)
        {
            UNITY_INITIALIZE_OUTPUT(Input, o);
            
            // Calculate noise UV with proper time offset
            float2 noiseUV = (v.texcoord.xy + _Time.y * _Speed) * _Scale;
            float noiseValue = tex2Dlod(_NoiseTex, float4(noiseUV, 0, 0)).x;
            
            // Apply wave displacement (centered around 0)
            float displacement = (noiseValue - 0.5) * _Amplitude * 2.0;
            v.vertex.y += displacement;
            
            // Calculate eye depth for soft particles
            COMPUTE_EYEDEPTH(o.eyeDepth);
        }
        
        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            // === DEPTH CALCULATION (Soft Edges) ===
            float rawZ = SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(IN.screenPos));
            float sceneZ = LinearEyeDepth(rawZ);
            float partZ = IN.eyeDepth;
            
            // Calculate depth difference
            float depthDiff = sceneZ - partZ;
            
            // Soft edge fade
            float softEdge = saturate(_SoftFactor * depthDiff);
            
            // Depth-based color fade
            float depthFade = saturate(_DepthFactor * depthDiff);
            
            // === ANIMATED NORMAL MAPS ===
            // Animate normal map UVs with different speeds and directions
            float2 normalUV1 = IN.uv_NormalTex1;
            normalUV1.x += _Time.y * _NormalSpeed;
            normalUV1.y += _Time.y * _NormalSpeed * 0.5;
            
            float2 normalUV2 = IN.uv_NormalTex2;
            normalUV2.x -= _Time.y * _NormalSpeed * 0.7;
            normalUV2.y += _Time.y * _NormalSpeed * 0.3;
            
            // Sample and blend normal maps
            fixed3 normal1 = UnpackNormal(tex2D(_NormalTex1, normalUV1));
            fixed3 normal2 = UnpackNormal(tex2D(_NormalTex2, normalUV2));
            
            // Blend normals properly
            fixed3 blendedNormal = normalize(fixed3(
                normal1.xy + normal2.xy,
                normal1.z * normal2.z
            ));
            
            // Apply normal strength
            blendedNormal.xy *= _NormalStrength;
            o.Normal = normalize(blendedNormal);
            
            // === COLOR ===
            // Blend between shallow and deep water colors based on depth
            fixed4 waterColor = lerp(_ShallowColor, _DeepColor, depthFade);
            
            o.Albedo = waterColor.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            
            // Alpha based on soft edge and depth
            o.Alpha = waterColor.a * softEdge;
        }
        ENDCG
    }
    
    FallBack "Transparent/Diffuse"
}