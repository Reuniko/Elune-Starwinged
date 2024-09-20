using System.Linq;
using UnityEngine;

namespace CasTools
{
    public static class CasHelpers
    {
        public static Texture2D CreateColorTexture2D(Color color)
        {
            var texture = new Texture2D(10, 10);
            Color[] pixels = Enumerable.Repeat(color, Screen.width * Screen.height).ToArray();
            texture.SetPixels(pixels);
            texture.Apply();
            return texture;
        }
    }
}