using System.Collections;
using UnityEngine;
using UnityEngine.UI;

public class ShowImageSlide : MonoBehaviour, ISlide
{
    [SerializeField] private bool _clear;
    [SerializeField] private Image _image;
    [SerializeField] private Sprite _imageToShow;
    public bool Clear => _clear;

    public void Hide()
    {
        _image.sprite = null;
        _image.gameObject.SetActive(false);
    }

    public IEnumerator Show()
    {
        _image.sprite = _imageToShow;
        _image.gameObject.SetActive(true);
        yield return null;
    }
}
