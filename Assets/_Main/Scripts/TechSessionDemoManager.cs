using System.Collections;
using UnityEngine;

public class TechSessionDemoManager : MonoBehaviour
{
    private ISlide[] _slides;
    private IEnumerator _co_handleDemo;
    private int _currentIndex;

    void Start()
    {
        _slides = GetComponentsInChildren<ISlide>(true);
        if (_slides == null || _slides.Length == 0)
            return;

        _co_handleDemo = HandleDemoLifetime(0);
        StartCoroutine(_co_handleDemo);
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.RightArrow))
            SkipForward();
        else if (Input.GetKeyDown(KeyCode.LeftArrow))
            SkipBackwards();

        if (Input.GetKeyDown(KeyCode.Escape))
            Application.Quit();
    }

    private IEnumerator HandleDemoLifetime(int startIndex)
    {
        for (int i = startIndex; i < _slides.Length; i++)
        {
            _currentIndex = i;
            ClearPreviousSlides(i);
            yield return _slides[i].Show();
            yield return TechSessionUtils.WaitForKeyPress(KeyCode.Space);
        }
    }

    private void ClearPreviousSlides(int i, bool force = false)
    {
        if (force || _slides[i].Clear)
        {
            int x = i - 1;
            while (x >= 0 && !_slides[x].Clear)
            {
                _slides[x].Hide();
                x--;
            }
            if (x >= 0 && _slides[x].Clear)
                _slides[x].Hide();
        }
    }

    private void SkipForward()
    {
        int x = _currentIndex + 1;
        while (x < _slides.Length && !_slides[x].Clear)
            x++;
        if (x >= _slides.Length || x == _currentIndex)
            return;
        StopCoroutine(_co_handleDemo);
        _slides[_currentIndex].Hide();
        ClearPreviousSlides(_currentIndex, true);
        _co_handleDemo = HandleDemoLifetime(x);
        StartCoroutine(_co_handleDemo);
    }

    private void SkipBackwards()
    {
        int x = _currentIndex - 1;
        while (x >= 0 && !_slides[x].Clear)
            x--;
        if (x < 0 || x == _currentIndex)
            return;
        StopCoroutine(_co_handleDemo);
        _slides[_currentIndex].Hide();
        ClearPreviousSlides(_currentIndex, true);
        _co_handleDemo = HandleDemoLifetime(x);
        StartCoroutine(_co_handleDemo);
    }
}
