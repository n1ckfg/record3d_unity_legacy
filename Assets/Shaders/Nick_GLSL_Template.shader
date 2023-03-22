// https://en.wikibooks.org/wiki/GLSL_Programming/Unity/Minimal_Shader

Shader "Nick/GLSL_Template" {

    Properties {
        _MainTex ("Texture", 2D) = "white" {}
    }

    SubShader { 
        Pass { 
            GLSLPROGRAM
 
            #ifdef VERTEX 

            uniform sampler2D _MainTex;	
            uniform vec4 _MainTex_ST; 
            varying vec4 textureCoordinates;

            void main(void) {			
                textureCoordinates = gl_MultiTexCoord0;
                gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
            }

            #endif


            #ifdef FRAGMENT

            uniform sampler2D _MainTex;
            uniform vec4 _MainTex_ST;   
            varying vec4 textureCoordinates;

            void main() {
                gl_FragColor = texture2D(_MainTex,  _MainTex_ST.xy * textureCoordinates.xy + _MainTex_ST.zw);	
            }

            #endif

            ENDGLSL 
        }
    }

}