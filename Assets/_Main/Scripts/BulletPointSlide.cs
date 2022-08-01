using System.Collections;
using UnityEngine;

public class BulletPointSlide : MonoBehaviour, ISlide
{
    [SerializeField] private string _title;
    [SerializeField] private string[] _bullets;
    [SerializeField] private Transform _container;
    [SerializeField] private BulletPointSlideData _data;
    private BulletPointSlideData _currentData;
    public bool Clear => true;

    public IEnumerator Show()
    {
        if (_currentData != null)
            Destroy(_currentData.gameObject);
        _currentData = Instantiate(_data, _container);
        _currentData.Setup(_title, _bullets);
        while (_currentData.Step())
        {
            yield return null;
            yield return TechSessionUtils.WaitForKeyPress(KeyCode.Space);
        }
    }

    public void Hide()
    {
        if (_currentData == null)
            return;
        _currentData.Cleanup();
        Destroy(_currentData.gameObject);
    }
}
