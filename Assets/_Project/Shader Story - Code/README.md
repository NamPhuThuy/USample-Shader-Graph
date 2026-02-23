## General
#pragma vertex vert: 
- This tells the compiler that the function named vert contains the logic for the Vertex Shader (processing individual vertices, primarily for position transformation).

#pragma fragment frag: 
- This tells the compiler that the function named frag contains the logic for the Fragment Shader (processing individual pixels/fragments to determine their final color)


## 11 Sqrt
- This code snippet is a Constant Buffer declaration in HLSL, specifically designed for URP
```hlsl
CBUFFER_START(UnityPerMaterial)
    half3 _Tint01;
    half3 _Tint02;
    half _GraphLineWidth;
CBUFFER_END
```

**CBUFFER_START(UnityPerMaterial) / CBUFFER_END**:
- These macros define a block of memory on the GPU (a Constant Buffer) used to store uniform variables.
- UnityPerMaterial: This specific name is a reserved keyword in URP. It groups all material-specific properties together.

**Why is this important? (SRP Batcher)**:
- Using UnityPerMaterial enables the SRP Batcher.
- The SRP Batcher is a rendering optimization that significantly reduces CPU overhead. Instead of rebinding global shader values for every object, the engine binds this buffer once and simply updates the data offset for different materials.
- Crucial Rule: For the SRP Batcher to work, every property declared in the shader's Properties block (that isn't a Texture) must be declared inside this specific UnityPerMaterial CBUFFER.

**The Variables**:
- half3 _Tint01;: Defines a variable to hold RGB color data (matching your _Tint01 property).
- half _GraphLineWidth;: Defines a scalar variable (matching your _GraphLineWidth property).


#pragma shader_feature_local:
- This directive tells the Unity shader compiler to generate multiple variants of your shader based on keywords, but with specific optimizations for the URP and modern Unity versions.
  - When you add #pragma shader_feature_local INVERSE_SQRT, Unity compiles two versions of the code: one where INVERSE_SQRT is defined, and one where it is not.
  - This allows you to use #ifdef INVERSE_SQRT to switch logic without using expensive if statements (branching) on the GPU during runtime.
- "Local" Keywords:
  - The Problem: Unity has a global limit of 256 shader keywords per project. If you use standard #pragma shader_feature, you consume these global slots.
  - The Solution: The _local suffix tells Unity that this keyword is specific only to this shader. It does not count toward the global limit (instead, there is a limit of 64 local keywords per shader), which is much safer for project scalability.
- Build Optimization:
  - Unlike **multi_compile**, **shader_feature** checks your materials at build time. If you have a material that uses the "Inverse" toggle, that variant is included. If no materials in your project use that toggle, the code for that variant is stripped out entirely to save file size.