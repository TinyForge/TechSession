using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Video;

public class VideoSlide : MonoBehaviour, ISlide
{
    [SerializeField] private VideoClip _video;
    [SerializeField] private VideoPlayer _videoPlayer;
    public bool Clear => true;

    public void Hide()
    {
        _videoPlayer.clip = null;
        _videoPlayer.gameObject.SetActive(false);
    }

    public IEnumerator Show()
    {
        _videoPlayer.gameObject.SetActive(true);
        _videoPlayer.clip = _video;
        yield return null;
    }
}
