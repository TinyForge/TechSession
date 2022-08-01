using DG.Tweening;
using UnityEngine;

public class NodeAgent : MonoBehaviour
{
    [SerializeField] private Ease _movementEase = Ease.InOutCubic;
    private Vector3[] _path;
    private int index = -1;
    public void Setup(Vector3[] path)
    {
        _path = path;
    }

    public bool Step(float speed)
    {
        index++;
        if (index >= _path.Length)
            return false;
        transform.DOComplete();
        transform.DOMove(_path[index], speed).SetEase(_movementEase);
        return true;
    }

    public Vector3 Pos => (index >= _path.Length) ? Vector3.negativeInfinity : _path[index];

    public void Kill()
    {
        transform.DOComplete();
        Destroy(gameObject);
    }
}
