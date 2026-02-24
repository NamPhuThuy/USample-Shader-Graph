Some learning sources:
- https://danielilett.com/2023-09-26-tut7-3-intro-to-shader-graph/
  - Shader Graph Basics: https://danielilett.com/2023-09-26-tut7-3-intro-to-shader-graph/
  - Shader Code Basics: https://danielilett.com/2025-10-15-tut10-01-your-first-shader/
  - 10 Shaders Explained Quickly: https://danielilett.com/2023-04-07-tut6-5-10-shaders-quickly/
  - URP Series: https://danielilett.com/2020-03-21-tut5-1-urp-cel-shading/
- https://github.com/DeGGeD/ShaderStory
- https://ameye.dev/
- https://www.shadertoy.com/
- https://fragcoord.xyz/
- https://learn.unity.com/course/introduction-to-lwrp-and-shader-graph-for-2d-games-toolkit-2019-2/tutorial/understanding-scriptable-render-pipelines-2019-3


<p align="right">(<a href="#readme-top">back to top</a>)</p>

| Scenario | RenderType | Queue | Why? | 
| :--- | :--- | :--- | :--- | 
| Solid Object | "Opaque" | "Geometry" (2000) | Drawn first to write to the depth buffer. Efficient. | 
| Cutout (Fence/Leaf) | "TransparentCutout" | "AlphaTest" (2450) | Drawn after solids but before true transparency. | 
| Glass / Ghost | "Transparent" | "Transparent" (3000) | Drawn last (back-to-front) so they blend over solids. | 
| UI / Overlay | "Overlay" | "Overlay" (4000) | Drawn on top of everything else. |


## Keyword
**Culling** decides which triangle faces are rendered based on their winding order.
Triangles have a front and back side determined by vertex order.
_Cull Back_   → default (don’t draw back faces)
_Cull Front_  → draw only back faces
_Cull Off_    → draw both sides

**ZBuffering** (Depth Buffer)
The ZBuffer stores depth per pixel so GPU knows what is in front.
Without it:
- Objects render in draw order
- Visual artifacts appear

- The value of ZBuffer is determined by _ZTest_

**ZTest**
Determines when pixel passes depth test.
- ZTest LEqual (default)
- ZTest Always
- ZTest Greater

**ZWrite / Alpha Blending**
What it does? - Writes object depth into depth buffer
- ZWrite On   → solid objects (Opaque)
- ZWrite Off  → transparent objects

**Matrix Manipulations**
What it is? Matrices convert positions between spaces:
- Space chain: Object → World → View → Clip → Screen

**Pass**
A Pass = one full GPU draw of your object with a specific render state + vertex + fragment program.
- Render State: ZWrite, ZTest, Cull, Blend, ColorMask, Stencil, Offset, AlphaToMask 
- Inside a SubShader, you can have multiple Passes.

Why multiple Passes? - You need different GPU behaviors:
- Example: Standard Lit shader needs:
    - Forward lighting pass 
    - Shadow caster pass 
    - Depth-only pass 
    - Meta pass (lightmapping)

**SubShader**
A SubShader is a group of passes.
Unity selects the first SubShader compatible with:
- Current Render Pipeline 
- Hardware capability

In modern URP projects: -> You usually only use ONE SubShader.

```hlsl
SubShader
{
    Tags { "RenderPipeline"="UniversalPipeline" }

    Pass
    {
        Name "ForwardLit"

        ZWrite On
        Cull Back
        Blend One Zero

        HLSLPROGRAM
        #pragma vertex vert
        #pragma fragment frag
        ENDHLSL
    }
}
```


**Data Type**
float
half
fixed (legacy)
int
bool
float2 / float3 / float4
float3x3 / float4x4
sampler2D
TEXTURE2D
SAMPLER

_Game tip_:
- Use half on mobile when possible.
- Use float for world space math.

**Semantics (GPU Inputs/Outputs)**
POSITION
NORMAL
TANGENT
TEXCOORD0-7
SV_POSITION
SV_Target
SV_Target0
SV_Depth

These connect mesh → vertex → fragment.