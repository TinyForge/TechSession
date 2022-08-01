using System.Collections;
using UnityEngine;

public interface ISlide
{
    bool Clear { get; }
    IEnumerator Show();
    void Hide();
}
