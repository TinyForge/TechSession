using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class TechSessionUtils
{
    public static IEnumerator WaitForKeyPress(KeyCode key)
    {
        while (!Input.GetKeyDown(key))
            yield return null;
    }
}
