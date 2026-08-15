#!/usr/bin/env bash
set -euo pipefail
echo 'Installing atomcode pre-commit hooks...'
cat > .git/hooks/pre-commit <<'HOOK'
#!/usr/bin/env bash
cargo fmt --all -- --check
HOOK
chmod +x .git/hooks/pre-commit
echo 'Hooks installed.'
