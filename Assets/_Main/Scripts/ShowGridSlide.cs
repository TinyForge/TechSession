using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
using System.Linq;

public class ShowGridSlide : MonoBehaviour, ISlide
{
    [SerializeField] private Texture2D _gridImage;
    [SerializeField] private GameObject _prefab;
    [SerializeField] private Transform _centre;
    [SerializeField] private Vector3 _blockOffset = new Vector3(0.5f, 0, 0.5f);
    [SerializeField] private float _blockSize = 1;
    [SerializeField] private float _spawnSpeed = 0.5f;
    [SerializeField] private ColorPairs[] _colourPairs;
    private GameObject _tower;

    public bool Clear => true;
    public Texture2D GridImage => _gridImage;
    public Vector3 BlockOffset => _blockOffset;
    public GameObject Tower => _tower;

    public IEnumerator Show()
    {
        DeleteExistingCampaignGrid();
        CreateGrid();
        yield return new WaitForSeconds(Mathf.Max(_gridImage.width, _gridImage.height) * 0.5f * _spawnSpeed);
    }

    public void Hide()
    {
        DeleteExistingCampaignGrid();
    }

    public void ForEachNode(Action<Vector3, Color> action)
    {
        var width = _gridImage.width;
        var height = _gridImage.height;
        var offset = new Vector3(-(width / 2f), 0, -(height / 2f));
        var positionOffset = new Vector3(width / 2, 0, height / 2);
        var waitVar = new WaitForSeconds(0.02f);
        for (int x = 0; x < width; x++)
        {
            for (int y = 0; y < height; y++)
            {
                var pixel = _gridImage.GetPixel(x, y);
                var position = new Vector3(x * _blockSize, 0, y * _blockSize) - positionOffset + _blockOffset;
                action(position, pixel);
            }
        }
    }

    private void CreateGrid()
    {
        ForEachNode((position, pixel) => StartCoroutine(InstantiateAndAnimateWithDelay(position, pixel)));

        IEnumerator InstantiateAndAnimateWithDelay(Vector3 position, Color pixel)
        {
            yield return new WaitForSeconds(Vector3.Distance(position, _centre.position) * _spawnSpeed);
            var newBlock = Instantiate(_prefab, position, Quaternion.identity, transform);
            SetRenderer(newBlock, pixel);
        }
    }

    private void DeleteExistingCampaignGrid()
    {
        StopAllCoroutines();
        var children = new List<GameObject>();
        foreach (Transform child in transform)
        {
            children.Add(child.gameObject);
        }
        foreach (var child in children)
        {
            child.transform.DOComplete();
            Destroy(child);
        }
    }

    private void SetRenderer(GameObject block, Color color)
    {
        var renderer = block.GetComponent<Renderer>();
        renderer.material.DOColor(color, 0.5f);
        var pair = _colourPairs.FirstOrDefault(x => string.Equals(x.ColourHex, ColorUtility.ToHtmlStringRGB(color), StringComparison.InvariantCultureIgnoreCase));
        block.transform.DOMoveY(pair.HeightOffset, 0.5f).SetEase(Ease.OutBack);
        if (pair.IsTower)
            _tower = block;
    }

    [Serializable]
    private struct ColorPairs
    {
        public string ColourHex;
        public float HeightOffset;
        public bool IsTower;
    }
}
