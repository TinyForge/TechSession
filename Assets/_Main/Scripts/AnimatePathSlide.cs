using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class AnimatePathSlide : MonoBehaviour, ISlide
{
    [SerializeField] private NodePath _nodePath;
    [SerializeField] private NodeAgent _nodePrefab;
    [SerializeField] private int _agentCount;
    [SerializeField] private float _agentSpeed = 0.5f;
    [SerializeField] private bool _autoPath = false;
    [SerializeField] private ShowGridSlide _grid;
    [SerializeField] private string _rangeColour;
    [SerializeField] private TMP_Text _text;
    private List<Vector3> _rangePositions;
    private List<NodeAgent> _agents;
    private int _spawned;
    private int _hitCount;

    bool ISlide.Clear => false;

    void ISlide.Hide()
    {
        _text.SetText(string.Empty);
        if (_agents == null || _agents.Count == 0)
            return;
        foreach (var agent in _agents)
        {
            if (agent == null)
                continue;
            Destroy(agent.gameObject);
        }
    }

    IEnumerator ISlide.Show()
    {
        var path = _nodePath.Path;
        _spawned = 0;
        _hitCount = 0;
        UpdateText(_hitCount);
        _agents = new List<NodeAgent>();
        CalculateTowerRange(path);
        do
        {
            if (!_autoPath)
                yield return TechSessionUtils.WaitForKeyPress(KeyCode.Space);
            else
                yield return new WaitForSeconds(Input.GetKey(KeyCode.LeftAlt) ? _agentSpeed * 0.5f : _agentSpeed);
            if (Input.GetKey(KeyCode.LeftControl))
                _autoPath = !_autoPath;
            if (_spawned < _agentCount)
                CreateAgent(path);
            var agentsToRemove = new List<NodeAgent>();
            foreach (var agent in _agents)
            {
                if (!agent.Step(Input.GetKey(KeyCode.LeftAlt) ? _agentSpeed * 0.5f : _agentSpeed))
                    agentsToRemove.Add(agent);
            }
            foreach (var agent in agentsToRemove)
            {
                _agents.Remove(agent);
                agent.Kill();
            }
            foreach (var agent in _agents)
            {
                if (!IsInRange(agent.Pos))
                    continue;
                _hitCount++;
                _grid.Tower.transform.DOComplete();
                _grid.Tower.transform.DOPunchScale(new Vector3(0.1f, -0.1f, 0.1f), 0.2f);
                UpdateText(_hitCount);
                break;
            }
            yield return null;
        } while (_agents.Count > 0);
    }

    private void CreateAgent(Vector3[] path)
    {
        var newAgent = Instantiate(_nodePrefab, path[0], Quaternion.identity, transform);
        newAgent.Setup(path);
        _agents.Add(newAgent);
        _spawned++;
    }

    private void CalculateTowerRange(Vector3[] path)
    {
        _rangePositions = new List<Vector3>();
        _grid.ForEachNode((position, pixel) => {
            if (!string.Equals(ColorUtility.ToHtmlStringRGB(pixel), _rangeColour, System.StringComparison.InvariantCultureIgnoreCase))
                return;
            _rangePositions.Add(new Vector3(position.x, path[0].y, position.z));
        });
    }

    private bool IsInRange(Vector3 pos)
    {
        foreach (var range in _rangePositions)
        {
            if (range.x == pos.x && range.z == pos.z)
                return true;
        }
        return false;
    }

    private void UpdateText(int count)
    {
        _text.SetText($"{_agentCount}\tHit Count: {count}");
    }
}
