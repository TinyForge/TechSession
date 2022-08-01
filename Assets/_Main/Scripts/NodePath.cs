using UnityEngine;

public class NodePath : MonoBehaviour
{
    [SerializeField] private Transform[] _nodes;
    private Vector3[] _path;
    public Vector3[] Path => _path;

    void Awake()
    {
        _path = new Vector3[_nodes.Length];
        for (int i = 0; i < _nodes.Length; i++)
        {
            _path[i] = _nodes[i].position;
        }
    }
}
