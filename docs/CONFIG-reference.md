# Configuration Reference

## [llm]
| Key | Type | Default | Description |
|---|---|---|---|
| provider | string | anthropic | LLM provider |
| endpoint | string | provider default | API endpoint |
| model | string | claude-sonnet-4-5 | Model ID |
| temperature | float | 0.2 | Sampling temp |
| max_tokens | int | 8192 | Max output tokens |

## [agent]
| Key | Type | Default | Description |
|---|---|---|---|
| tools | list | [edit_file,run_command] | Enabled tools |
| verify | string | cargo build | Verification command |
