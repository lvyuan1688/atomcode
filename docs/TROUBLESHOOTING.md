# Troubleshooting

## Install fails with 'linker not found'

Install a C linker:
- Ubuntu: `sudo apt install build-essential`
- macOS: `xcode-select --install`
- Windows: install Visual Studio Build Tools

## 'cargo: command not found' after install

Restart shell or `source ~/.cargo/env`.

## LLM connection timeout

Check `endpoint` in config. If behind proxy, set `HTTPS_PROXY`.

## Permission denied on ~/.atomcode

`chmod -R u+rwX ~/.atomcode` (Unix) or run shell as current user (Windows).
