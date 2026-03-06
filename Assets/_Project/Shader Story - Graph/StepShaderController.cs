using NamPhuThuy.Common;
using UnityEngine;

#if UNITY_EDITOR
using UnityEditor;
#endif

[RequireComponent(typeof(Renderer))]
public class StepShaderController : MonoBehaviour
{
    // ─── Shader Property References ───────────────────────────────────────────
    private static readonly int EdgeID    = Shader.PropertyToID("_EdgeValue");
    private static readonly int SpeedID   = Shader.PropertyToID("_AnimSpeed");
    private static readonly int StepsID   = Shader.PropertyToID("_StepCount");

    // ─── Inspector Settings ───────────────────────────────────────────────────
    [Header("=== Playback Control ===")]
    public bool isPlaying = false;

    [Header("=== Step Settings ===")]
    [Range(0f, 1f)]  public float edgeValue  = 0f;
    [Range(0.1f, 5f)] public float animSpeed = 1f;
    [Range(1, 16)]    public int   stepCount  = 4;

    [Header("=== Direction ===")]
    public bool reverseDirection = false;

    // ─── Private State ────────────────────────────────────────────────────────
    private Material _mat;
    private float    _timer;
    private bool     _wasPlaying;

    // ══════════════════════════════════════════════════════════════════════════
    void Start()
    {
        _mat = GetComponent<Renderer>().material;
        SyncToShader();
    }

    void Update()
    {
        // Sync inspector sliders to shader live (even when not animating)
        SyncToShader();

        if (!isPlaying) return;

        _timer += Time.deltaTime * animSpeed * (reverseDirection ? -1f : 1f);

        float t       = Mathf.Repeat(_timer, 1f);
        float stepped = Mathf.Floor(t * stepCount) / stepCount;

        edgeValue = stepped;
        _mat.SetFloat(EdgeID, edgeValue);
    }

    // ─── Public Methods (called by Inspector buttons) ─────────────────────────
    public void Play()
    {
        isPlaying = true;
    }

    public void Pause()
    {
        isPlaying = false;
    }

    public void Stop()
    {
        isPlaying = false;
        _timer    = 0f;
        edgeValue = 0f;
        SyncToShader();
    }

    public void StepForward()
    {
        isPlaying = false;
        float stepSize = 1f / stepCount;
        edgeValue = Mathf.Clamp(Mathf.Round((edgeValue + stepSize) * stepCount) / stepCount, 0f, 1f);
        SyncToShader();
    }

    public void StepBackward()
    {
        isPlaying = false;
        float stepSize = 1f / stepCount;
        edgeValue = Mathf.Clamp(Mathf.Round((edgeValue - stepSize) * stepCount) / stepCount, 0f, 1f);
        SyncToShader();
    }

    // ─── Internal ─────────────────────────────────────────────────────────────
    private void SyncToShader()
    {
        if (_mat == null)
        {
            DebugLogger.Log(message:$"The material is null");
            return;
        }
        _mat.SetFloat(EdgeID,  edgeValue);
        _mat.SetFloat(SpeedID, animSpeed);
        _mat.SetFloat(StepsID, stepCount);
    }
}


// ══════════════════════════════════════════════════════════════════════════════
//  CUSTOM INSPECTOR
// ══════════════════════════════════════════════════════════════════════════════
#if UNITY_EDITOR
[CustomEditor(typeof(StepShaderController))]
public class StepShaderControllerEditor : Editor
{
    public override void OnInspectorGUI()
    {
        StepShaderController ctrl = (StepShaderController)target;

        // ── Header ──────────────────────────────────────────────────────────
        EditorGUILayout.Space(4);
        GUIStyle titleStyle = new GUIStyle(EditorStyles.boldLabel)
        {
            fontSize  = 13,
            alignment = TextAnchor.MiddleCenter
        };
        EditorGUILayout.LabelField("Step Shader Controller", titleStyle);
        EditorGUILayout.Space(6);

        // ── Playback Buttons ────────────────────────────────────────────────
        EditorGUILayout.LabelField("Playback", EditorStyles.boldLabel);
        EditorGUILayout.BeginHorizontal();

        GUI.backgroundColor = ctrl.isPlaying ? Color.green : Color.white;
        if (GUILayout.Button("▶  Play", GUILayout.Height(30)))
        {
            ctrl.Play();
            EditorUtility.SetDirty(ctrl);
        }

        GUI.backgroundColor = !ctrl.isPlaying ? new Color(1f, 0.85f, 0.2f) : Color.white;
        if (GUILayout.Button("⏸  Pause", GUILayout.Height(30)))
        {
            ctrl.Pause();
            EditorUtility.SetDirty(ctrl);
        }

        GUI.backgroundColor = new Color(1f, 0.4f, 0.4f);
        if (GUILayout.Button("⏹  Stop", GUILayout.Height(30)))
        {
            ctrl.Stop();
            EditorUtility.SetDirty(ctrl);
        }

        GUI.backgroundColor = Color.white;
        EditorGUILayout.EndHorizontal();

        EditorGUILayout.Space(4);

        // ── Step Buttons ────────────────────────────────────────────────────
        EditorGUILayout.LabelField("Manual Step", EditorStyles.boldLabel);
        EditorGUILayout.BeginHorizontal();

        GUI.backgroundColor = new Color(0.6f, 0.8f, 1f);
        if (GUILayout.Button("◀  Step Back", GUILayout.Height(26)))
        {
            ctrl.StepBackward();
            EditorUtility.SetDirty(ctrl);
        }

        if (GUILayout.Button("Step Forward  ▶", GUILayout.Height(26)))
        {
            ctrl.StepForward();
            EditorUtility.SetDirty(ctrl);
        }

        GUI.backgroundColor = Color.white;
        EditorGUILayout.EndHorizontal();

        EditorGUILayout.Space(8);

        // ── Default Inspector Fields ────────────────────────────────────────
        DrawDefaultInspector();

        // ── Status Bar ──────────────────────────────────────────────────────
        EditorGUILayout.Space(6);
        string status = ctrl.isPlaying ? "● PLAYING" : "■ STOPPED";
        GUIStyle statusStyle = new GUIStyle(EditorStyles.helpBox)
        {
            alignment = TextAnchor.MiddleCenter,
            fontSize  = 11,
            fontStyle = FontStyle.Bold
        };
        GUI.color = ctrl.isPlaying ? Color.green : Color.gray;
        EditorGUILayout.LabelField(status, statusStyle, GUILayout.Height(22));
        GUI.color = Color.white;

        // Repaint inspector while playing so sliders update live
        if (ctrl.isPlaying)
            Repaint();
    }
}
#endif