Shader "Unlit/GradientUiShader"
{
    Properties
    {
        [NoScaleOffset] _MainTex("Mask", 2D) = "white" {}
        [NoScaleOffset]Texture2D_9379594eca0b47e5add6d1702550ac81("Gradient Texture", 2D) = "white" {}
        Vector1_fa3163880f57417abeb5d1d7feed44b1("Hue Offset", Range(0, 1)) = 0
        [HDR]Color_1ad50b9caa1d451eaaf7abbd15b480e2("Glow", Color) = (0.5377358, 0.5377358, 0.5377358, 1)
        Vector4_da70906a2b554736a0b115c4db87e6d7("Tiling", Vector) = (1, 1, 0, 0)
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}

        // Added to make it work with Unity Masks:
        [HideInInspector]_StencilComp("Stencil Comparison", Float) = 8
        [HideInInspector]_Stencil("Stencil ID", Float) = 0
        [HideInInspector]_StencilOp("Stencil Operation", Float) = 0
        [HideInInspector]_StencilWriteMask("Stencil Write Mask", Float) = 255
        [HideInInspector]_StencilReadMask("Stencil Read Mask", Float) = 255
        [HideInInspector]_ColorMask("Color Mask", Float) = 15
        // end

    }
        SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "RenderType" = "Transparent"
            "UniversalMaterialType" = "Unlit"
            "Queue" = "Transparent"
        }

        // Added to make it work with Unity Masks:
        Stencil
        {
            Ref[_Stencil]
            Comp[_StencilComp]
            Pass[_StencilOp]
            ReadMask[_StencilReadMask]
            WriteMask[_StencilWriteMask]
        }

        ColorMask[_ColorMask]
        // end
        Pass
        {
            Name "Sprite Unlit"
            Tags
            {
                "LightMode" = "Universal2D"
            }

        // Render State
        Cull Off
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
    ZTest LEqual
    ZWrite Off

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 2.0
    #pragma exclude_renderers d3d11_9x
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _AlphaClip 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SPRITEUNLIT
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        float4 uv0 : TEXCOORD0;
        float4 color : COLOR;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float4 texCoord0;
        float4 color;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float4 uv0;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float4 interp0 : TEXCOORD0;
        float4 interp1 : TEXCOORD1;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyzw = input.texCoord0;
        output.interp1.xyzw = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.texCoord0 = input.interp0.xyzw;
        output.color = input.interp1.xyzw;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 _MainTex_TexelSize;
float4 Texture2D_9379594eca0b47e5add6d1702550ac81_TexelSize;
float Vector1_fa3163880f57417abeb5d1d7feed44b1;
float4 Color_1ad50b9caa1d451eaaf7abbd15b480e2;
float4 Vector4_da70906a2b554736a0b115c4db87e6d7;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(_MainTex);
SAMPLER(sampler_MainTex);
TEXTURE2D(Texture2D_9379594eca0b47e5add6d1702550ac81);
SAMPLER(samplerTexture2D_9379594eca0b47e5add6d1702550ac81);

// Graph Functions

void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
{
    Out = UV * Tiling + Offset;
}

void Unity_Blend_Lighten_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
{
    Out = max(Blend, Base);
    Out = lerp(Base, Out, Opacity);
}

void Unity_Hue_Normalized_float(float3 In, float Offset, out float3 Out)
{
    // RGB to HSV
    float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    float4 P = lerp(float4(In.bg, K.wz), float4(In.gb, K.xy), step(In.b, In.g));
    float4 Q = lerp(float4(P.xyw, In.r), float4(In.r, P.yzx), step(P.x, In.r));
    float D = Q.x - min(Q.w, Q.y);
    float E = 1e-4;
    float3 hsv = float3(abs(Q.z + (Q.w - Q.y) / (6.0 * D + E)), D / (Q.x + E), Q.x);

    float hue = hsv.x + Offset;
    hsv.x = (hue < 0)
            ? hue + 1
            : (hue > 1)
                ? hue - 1
                : hue;

    // HSV to RGB
    float4 K2 = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    float3 P2 = abs(frac(hsv.xxx + K2.xyz) * 6.0 - K2.www);
    Out = hsv.z * lerp(K2.xxx, saturate(P2 - K2.xxx), hsv.y);
}

void Unity_Blend_Overlay_float3(float3 Base, float3 Blend, out float3 Out, float Opacity)
{
    float3 result1 = 1.0 - 2.0 * (1.0 - Base) * (1.0 - Blend);
    float3 result2 = 2.0 * Base * Blend;
    float3 zeroOrOne = step(Base, 0.5);
    Out = result2 * zeroOrOne + (1 - zeroOrOne) * result1;
    Out = lerp(Base, Out, Opacity);
}

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    description.Position = IN.ObjectSpacePosition;
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
    float3 BaseColor;
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    UnityTexture2D _Property_645730cf03634c88a4c73c4df74fc03e_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_9379594eca0b47e5add6d1702550ac81);
    float4 _Property_a24818c06fac4b2f938707086cd3de5e_Out_0 = Vector4_da70906a2b554736a0b115c4db87e6d7;
    float _Split_210b77e739be4934a2603a6a0264219a_R_1 = _Property_a24818c06fac4b2f938707086cd3de5e_Out_0[0];
    float _Split_210b77e739be4934a2603a6a0264219a_G_2 = _Property_a24818c06fac4b2f938707086cd3de5e_Out_0[1];
    float _Split_210b77e739be4934a2603a6a0264219a_B_3 = _Property_a24818c06fac4b2f938707086cd3de5e_Out_0[2];
    float _Split_210b77e739be4934a2603a6a0264219a_A_4 = _Property_a24818c06fac4b2f938707086cd3de5e_Out_0[3];
    float2 _Vector2_89bdfba7830040e28fdb3611bb4a64a4_Out_0 = float2(_Split_210b77e739be4934a2603a6a0264219a_R_1, _Split_210b77e739be4934a2603a6a0264219a_G_2);
    float2 _Vector2_9fcf8649d8394c61a94efad9b1fad8b9_Out_0 = float2(_Split_210b77e739be4934a2603a6a0264219a_B_3, _Split_210b77e739be4934a2603a6a0264219a_A_4);
    float2 _TilingAndOffset_53f095eeff174bf991a34558351baef7_Out_3;
    Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_89bdfba7830040e28fdb3611bb4a64a4_Out_0, _Vector2_9fcf8649d8394c61a94efad9b1fad8b9_Out_0, _TilingAndOffset_53f095eeff174bf991a34558351baef7_Out_3);
    float4 _SampleTexture2D_a0a8beb4c5cf4dd1a85a849e3e71b94c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_645730cf03634c88a4c73c4df74fc03e_Out_0.tex, _Property_645730cf03634c88a4c73c4df74fc03e_Out_0.samplerstate, _TilingAndOffset_53f095eeff174bf991a34558351baef7_Out_3);
    float _SampleTexture2D_a0a8beb4c5cf4dd1a85a849e3e71b94c_R_4 = _SampleTexture2D_a0a8beb4c5cf4dd1a85a849e3e71b94c_RGBA_0.r;
    float _SampleTexture2D_a0a8beb4c5cf4dd1a85a849e3e71b94c_G_5 = _SampleTexture2D_a0a8beb4c5cf4dd1a85a849e3e71b94c_RGBA_0.g;
    float _SampleTexture2D_a0a8beb4c5cf4dd1a85a849e3e71b94c_B_6 = _SampleTexture2D_a0a8beb4c5cf4dd1a85a849e3e71b94c_RGBA_0.b;
    float _SampleTexture2D_a0a8beb4c5cf4dd1a85a849e3e71b94c_A_7 = _SampleTexture2D_a0a8beb4c5cf4dd1a85a849e3e71b94c_RGBA_0.a;
    float4 Color_68dad9208b18470a97928899ef497a3c = IsGammaSpace() ? float4(0, 0, 0, 0) : float4(SRGBToLinear(float3(0, 0, 0)), 0);
    UnityTexture2D _Property_07dc27cce6a8475d953d9891f420dd1f_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
    float4 _SampleTexture2D_7024c79dcae14ff687758c458a80a773_RGBA_0 = SAMPLE_TEXTURE2D(_Property_07dc27cce6a8475d953d9891f420dd1f_Out_0.tex, _Property_07dc27cce6a8475d953d9891f420dd1f_Out_0.samplerstate, IN.uv0.xy);
    float _SampleTexture2D_7024c79dcae14ff687758c458a80a773_R_4 = _SampleTexture2D_7024c79dcae14ff687758c458a80a773_RGBA_0.r;
    float _SampleTexture2D_7024c79dcae14ff687758c458a80a773_G_5 = _SampleTexture2D_7024c79dcae14ff687758c458a80a773_RGBA_0.g;
    float _SampleTexture2D_7024c79dcae14ff687758c458a80a773_B_6 = _SampleTexture2D_7024c79dcae14ff687758c458a80a773_RGBA_0.b;
    float _SampleTexture2D_7024c79dcae14ff687758c458a80a773_A_7 = _SampleTexture2D_7024c79dcae14ff687758c458a80a773_RGBA_0.a;
    float4 _Blend_91ea8f199f8547c8b79bed44007834ed_Out_2;
    Unity_Blend_Lighten_float4(_SampleTexture2D_a0a8beb4c5cf4dd1a85a849e3e71b94c_RGBA_0, Color_68dad9208b18470a97928899ef497a3c, _Blend_91ea8f199f8547c8b79bed44007834ed_Out_2, (_SampleTexture2D_7024c79dcae14ff687758c458a80a773_RGBA_0).x);
    float _Property_4c0ee9f4563f4afbbb778c25c86e17a4_Out_0 = Vector1_fa3163880f57417abeb5d1d7feed44b1;
    float3 _Hue_9241e0e59e9d402eafa64a55501d5e85_Out_2;
    Unity_Hue_Normalized_float((_Blend_91ea8f199f8547c8b79bed44007834ed_Out_2.xyz), _Property_4c0ee9f4563f4afbbb778c25c86e17a4_Out_0, _Hue_9241e0e59e9d402eafa64a55501d5e85_Out_2);
    float4 _Property_4a136030ba7f44ebb011dd132ebb8218_Out_0 = IsGammaSpace() ? LinearToSRGB(Color_1ad50b9caa1d451eaaf7abbd15b480e2) : Color_1ad50b9caa1d451eaaf7abbd15b480e2;
    float3 _Blend_5836e449593d4c429a136d87b54479c3_Out_2;
    Unity_Blend_Overlay_float3(_Hue_9241e0e59e9d402eafa64a55501d5e85_Out_2, (_Property_4a136030ba7f44ebb011dd132ebb8218_Out_0.xyz), _Blend_5836e449593d4c429a136d87b54479c3_Out_2, 1);
    surface.BaseColor = _Blend_5836e449593d4c429a136d87b54479c3_Out_2;
    surface.Alpha = _SampleTexture2D_7024c79dcae14ff687758c458a80a773_A_7;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





    output.uv0 = input.texCoord0;
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

    return output;
}

    // --------------------------------------------------
    // Main

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SpriteUnlitPass.hlsl"

    ENDHLSL
}
Pass
{
    Name "Sprite Unlit"
    Tags
    {
        "LightMode" = "UniversalForward"
    }

        // Render State
        Cull Off
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
    ZTest LEqual
    ZWrite Off

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 2.0
    #pragma exclude_renderers d3d11_9x
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _AlphaClip 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SPRITEFORWARD
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        float4 uv0 : TEXCOORD0;
        float4 color : COLOR;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float4 texCoord0;
        float4 color;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float4 uv0;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float4 interp0 : TEXCOORD0;
        float4 interp1 : TEXCOORD1;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyzw = input.texCoord0;
        output.interp1.xyzw = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.texCoord0 = input.interp0.xyzw;
        output.color = input.interp1.xyzw;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 _MainTex_TexelSize;
float4 Texture2D_9379594eca0b47e5add6d1702550ac81_TexelSize;
float Vector1_fa3163880f57417abeb5d1d7feed44b1;
float4 Color_1ad50b9caa1d451eaaf7abbd15b480e2;
float4 Vector4_da70906a2b554736a0b115c4db87e6d7;
CBUFFER_END

// Object and Global properties
SAMPLER(SamplerState_Linear_Repeat);
TEXTURE2D(_MainTex);
SAMPLER(sampler_MainTex);
TEXTURE2D(Texture2D_9379594eca0b47e5add6d1702550ac81);
SAMPLER(samplerTexture2D_9379594eca0b47e5add6d1702550ac81);

// Graph Functions

void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
{
    Out = UV * Tiling + Offset;
}

void Unity_Blend_Lighten_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
{
    Out = max(Blend, Base);
    Out = lerp(Base, Out, Opacity);
}

void Unity_Hue_Normalized_float(float3 In, float Offset, out float3 Out)
{
    // RGB to HSV
    float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    float4 P = lerp(float4(In.bg, K.wz), float4(In.gb, K.xy), step(In.b, In.g));
    float4 Q = lerp(float4(P.xyw, In.r), float4(In.r, P.yzx), step(P.x, In.r));
    float D = Q.x - min(Q.w, Q.y);
    float E = 1e-4;
    float3 hsv = float3(abs(Q.z + (Q.w - Q.y) / (6.0 * D + E)), D / (Q.x + E), Q.x);

    float hue = hsv.x + Offset;
    hsv.x = (hue < 0)
            ? hue + 1
            : (hue > 1)
                ? hue - 1
                : hue;

    // HSV to RGB
    float4 K2 = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    float3 P2 = abs(frac(hsv.xxx + K2.xyz) * 6.0 - K2.www);
    Out = hsv.z * lerp(K2.xxx, saturate(P2 - K2.xxx), hsv.y);
}

void Unity_Blend_Overlay_float3(float3 Base, float3 Blend, out float3 Out, float Opacity)
{
    float3 result1 = 1.0 - 2.0 * (1.0 - Base) * (1.0 - Blend);
    float3 result2 = 2.0 * Base * Blend;
    float3 zeroOrOne = step(Base, 0.5);
    Out = result2 * zeroOrOne + (1 - zeroOrOne) * result1;
    Out = lerp(Base, Out, Opacity);
}

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    description.Position = IN.ObjectSpacePosition;
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
    float3 BaseColor;
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    UnityTexture2D _Property_645730cf03634c88a4c73c4df74fc03e_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_9379594eca0b47e5add6d1702550ac81);
    float4 _Property_a24818c06fac4b2f938707086cd3de5e_Out_0 = Vector4_da70906a2b554736a0b115c4db87e6d7;
    float _Split_210b77e739be4934a2603a6a0264219a_R_1 = _Property_a24818c06fac4b2f938707086cd3de5e_Out_0[0];
    float _Split_210b77e739be4934a2603a6a0264219a_G_2 = _Property_a24818c06fac4b2f938707086cd3de5e_Out_0[1];
    float _Split_210b77e739be4934a2603a6a0264219a_B_3 = _Property_a24818c06fac4b2f938707086cd3de5e_Out_0[2];
    float _Split_210b77e739be4934a2603a6a0264219a_A_4 = _Property_a24818c06fac4b2f938707086cd3de5e_Out_0[3];
    float2 _Vector2_89bdfba7830040e28fdb3611bb4a64a4_Out_0 = float2(_Split_210b77e739be4934a2603a6a0264219a_R_1, _Split_210b77e739be4934a2603a6a0264219a_G_2);
    float2 _Vector2_9fcf8649d8394c61a94efad9b1fad8b9_Out_0 = float2(_Split_210b77e739be4934a2603a6a0264219a_B_3, _Split_210b77e739be4934a2603a6a0264219a_A_4);
    float2 _TilingAndOffset_53f095eeff174bf991a34558351baef7_Out_3;
    Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_89bdfba7830040e28fdb3611bb4a64a4_Out_0, _Vector2_9fcf8649d8394c61a94efad9b1fad8b9_Out_0, _TilingAndOffset_53f095eeff174bf991a34558351baef7_Out_3);
    float4 _SampleTexture2D_a0a8beb4c5cf4dd1a85a849e3e71b94c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_645730cf03634c88a4c73c4df74fc03e_Out_0.tex, _Property_645730cf03634c88a4c73c4df74fc03e_Out_0.samplerstate, _TilingAndOffset_53f095eeff174bf991a34558351baef7_Out_3);
    float _SampleTexture2D_a0a8beb4c5cf4dd1a85a849e3e71b94c_R_4 = _SampleTexture2D_a0a8beb4c5cf4dd1a85a849e3e71b94c_RGBA_0.r;
    float _SampleTexture2D_a0a8beb4c5cf4dd1a85a849e3e71b94c_G_5 = _SampleTexture2D_a0a8beb4c5cf4dd1a85a849e3e71b94c_RGBA_0.g;
    float _SampleTexture2D_a0a8beb4c5cf4dd1a85a849e3e71b94c_B_6 = _SampleTexture2D_a0a8beb4c5cf4dd1a85a849e3e71b94c_RGBA_0.b;
    float _SampleTexture2D_a0a8beb4c5cf4dd1a85a849e3e71b94c_A_7 = _SampleTexture2D_a0a8beb4c5cf4dd1a85a849e3e71b94c_RGBA_0.a;
    float4 Color_68dad9208b18470a97928899ef497a3c = IsGammaSpace() ? float4(0, 0, 0, 0) : float4(SRGBToLinear(float3(0, 0, 0)), 0);
    UnityTexture2D _Property_07dc27cce6a8475d953d9891f420dd1f_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
    float4 _SampleTexture2D_7024c79dcae14ff687758c458a80a773_RGBA_0 = SAMPLE_TEXTURE2D(_Property_07dc27cce6a8475d953d9891f420dd1f_Out_0.tex, _Property_07dc27cce6a8475d953d9891f420dd1f_Out_0.samplerstate, IN.uv0.xy);
    float _SampleTexture2D_7024c79dcae14ff687758c458a80a773_R_4 = _SampleTexture2D_7024c79dcae14ff687758c458a80a773_RGBA_0.r;
    float _SampleTexture2D_7024c79dcae14ff687758c458a80a773_G_5 = _SampleTexture2D_7024c79dcae14ff687758c458a80a773_RGBA_0.g;
    float _SampleTexture2D_7024c79dcae14ff687758c458a80a773_B_6 = _SampleTexture2D_7024c79dcae14ff687758c458a80a773_RGBA_0.b;
    float _SampleTexture2D_7024c79dcae14ff687758c458a80a773_A_7 = _SampleTexture2D_7024c79dcae14ff687758c458a80a773_RGBA_0.a;
    float4 _Blend_91ea8f199f8547c8b79bed44007834ed_Out_2;
    Unity_Blend_Lighten_float4(_SampleTexture2D_a0a8beb4c5cf4dd1a85a849e3e71b94c_RGBA_0, Color_68dad9208b18470a97928899ef497a3c, _Blend_91ea8f199f8547c8b79bed44007834ed_Out_2, (_SampleTexture2D_7024c79dcae14ff687758c458a80a773_RGBA_0).x);
    float _Property_4c0ee9f4563f4afbbb778c25c86e17a4_Out_0 = Vector1_fa3163880f57417abeb5d1d7feed44b1;
    float3 _Hue_9241e0e59e9d402eafa64a55501d5e85_Out_2;
    Unity_Hue_Normalized_float((_Blend_91ea8f199f8547c8b79bed44007834ed_Out_2.xyz), _Property_4c0ee9f4563f4afbbb778c25c86e17a4_Out_0, _Hue_9241e0e59e9d402eafa64a55501d5e85_Out_2);
    float4 _Property_4a136030ba7f44ebb011dd132ebb8218_Out_0 = IsGammaSpace() ? LinearToSRGB(Color_1ad50b9caa1d451eaaf7abbd15b480e2) : Color_1ad50b9caa1d451eaaf7abbd15b480e2;
    float3 _Blend_5836e449593d4c429a136d87b54479c3_Out_2;
    Unity_Blend_Overlay_float3(_Hue_9241e0e59e9d402eafa64a55501d5e85_Out_2, (_Property_4a136030ba7f44ebb011dd132ebb8218_Out_0.xyz), _Blend_5836e449593d4c429a136d87b54479c3_Out_2, 1);
    surface.BaseColor = _Blend_5836e449593d4c429a136d87b54479c3_Out_2;
    surface.Alpha = _SampleTexture2D_7024c79dcae14ff687758c458a80a773_A_7;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





    output.uv0 = input.texCoord0;
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

    return output;
}

    // --------------------------------------------------
    // Main

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SpriteUnlitPass.hlsl"

    ENDHLSL
}
    }
        FallBack "Hidden/Shader Graph/FallbackError"
}