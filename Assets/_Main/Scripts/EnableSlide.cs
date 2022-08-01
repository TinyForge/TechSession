using System.Collections;
using UnityEngine;

public class EnableSlide : MonoBehaviour, ISlide
{
    public bool Clear => true;

    public void Hide()
    {
        gameObject.SetActive(false);
    }

    public IEnumerator Show()
    {
        gameObject.SetActive(true);
        yield return null;
    }
}
