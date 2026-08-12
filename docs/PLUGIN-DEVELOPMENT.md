# Plugin Development (v0.2 preview)

## Plugin Manifest

```toml
[plugin]
name = "my-plugin"
version = "0.1.0"
entry = "plugins/my-plugin/main.rs"
hooks = ["pre-tool", "post-tool"]
```

## Hook Lifecycle

1. `pre-tool`: called before each tool dispatch, can veto
2. `post-tool`: called after, can transform result

## Stability

Plugin API is unstable until v0.2.0 GA. Pin exact versions.
