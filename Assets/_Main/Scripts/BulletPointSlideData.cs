using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class BulletPointSlideData : MonoBehaviour
{
    [SerializeField] private TMP_Text _heading;
    [SerializeField] private Transform _container;
    [SerializeField] private GameObject _template;
    private string[] _bulletPoints;
    private int _currentIndex;

    public void Setup(string heading, string[] bulletPoints)
    {
        _heading.SetText(heading);
        _bulletPoints = bulletPoints;
        _currentIndex = -1;
    }

    public bool Step()
    {
        if (_currentIndex + 1 >= _bulletPoints.Length)
            return false;
        _currentIndex++;
        var newBullet = Instantiate(_template, Vector3.zero, Quaternion.identity, _container);
        newBullet.gameObject.SetActive(true);
        newBullet.GetComponentInChildren<TMP_Text>().SetText(_bulletPoints[_currentIndex]);
        return true;
    }

    public void Cleanup()
    {
        var children = new List<GameObject>();
        foreach (Transform child in transform)
        {
            children.Add(child.gameObject);
        }
        foreach (var child in children)
        {
            Destroy(child);
        }
    }
}
