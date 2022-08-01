using DG.Tweening;
using System.Collections;
using TMPro;
using UnityEngine;

public class HeadingSlide : MonoBehaviour, ISlide
{
    [SerializeField] private string _heading;
    [SerializeField] private TMP_Text _text;
    public bool Clear => true;

    public void Hide()
    {
        _text.SetText(string.Empty);
        _text.transform.DOComplete();
        _text.transform.localScale = Vector3.one;
        _text.gameObject.SetActive(false);
    }

    public IEnumerator Show()
    {
        _text.gameObject.SetActive(true);
        _text.SetText(_heading);
        _text.transform.DOComplete();
        _text.transform.localScale = new Vector3(0.8f, 0.8f, 0.8f);
        _text.transform.DOScale(new Vector3(1.2f, 1.2f, 1.2f), 20f).SetEase(Ease.Linear);
        yield return null;
    }
}
