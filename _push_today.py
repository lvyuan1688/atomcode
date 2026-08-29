#!/usr/bin/env python3
"""Push 5 new IMPROVEMENTS (idx 70-74) to atomcode remote main, build a release per commit.

Strategy: work on a clean-push branch based on origin/main (no secret history).
For each idx: write target file, commit, push to remote main (fast-forward), create release.
"""
import os, sys, json, subprocess, urllib.request, urllib.error, re, datetime

# --- load PAT from env ---
PAT = os.environ.get("GH_PAT", "").strip()
if not PAT:
    # fallback: extract from origin remote URL
    try:
        url = subprocess.check_output(["git", "remote", "get-url", "origin"], text=True).strip()
        PAT = re.search(r"://([^:]+):([^@]+)@", url).group(2)
    except Exception:
        print("ERR no GH_PAT and cannot extract from origin URL", flush=True)
        sys.exit(2)

REPO = "lvyuan1688/atomcode"
HEADERS = {"Authorization": "Bearer " + PAT, "Accept": "application/vnd.github+json", "Content-Type": "application/json"}

def git(*a, **kw):
    r = subprocess.run(["git"] + list(a), capture_output=True, text=True, encoding="utf-8", errors="replace", **kw)
    return r

def run_cmd(*a, timeout_s=45):
    """Run a command with robust stderr decoding (git on Windows may emit GBK)."""
    try:
        r = subprocess.run(list(a), capture_output=True, timeout=timeout_s)
        return r.returncode, r.stdout.decode("utf-8", "replace"), (r.stderr.decode("utf-8", "replace") if r.stderr else "")
    except subprocess.TimeoutExpired:
        return 124, "", "timeout"
    except Exception as e:
        return 1, "", str(e)

def gh_get(path):
    req = urllib.request.Request("https://api.github.com" + path)
    for k, v in HEADERS.items(): req.add_header(k, v)
    return json.loads(urllib.request.urlopen(req, timeout=20).read())

def gh_post(path, payload):
    req = urllib.request.Request("https://api.github.com" + path, data=json.dumps(payload).encode(), method="POST")
    for k, v in HEADERS.items(): req.add_header(k, v)
    try:
        return True, json.loads(urllib.request.urlopen(req, timeout=20).read())
    except urllib.error.HTTPError as e:
        return False, {"code": e.code, "msg": e.read().decode()[:200]}

# --- import IMPROVEMENTS from maintain.py ---
sys.path.insert(0, ".")
# maintain.py reads GH_PAT at import time; set it
os.environ["GH_PAT"] = PAT
import importlib.util
spec = importlib.util.spec_from_file_location("m", "maintain.py")
m = importlib.util.module_from_spec(spec)
# stub __main__ block: set sys.argv so it doesn't auto-run with wrong arg
spec.loader.exec_module(m)
IMPROVEMENTS = m.IMPROVEMENTS

today = datetime.date.today().isoformat()
INDICES = [70, 71, 72, 73, 74]
results = []

# current release count (to compute next patch tag)
try:
    existing = gh_get(f"/repos/{REPO}/releases?per_page=100")
    base = len(existing)
except Exception:
    base = 100  # fallback

print(f"=== start: {len(INDICES)} commits, base releases={base}, date={today} ===", flush=True)

for n, idx in enumerate(INDICES):
    kind, msg, target, content = IMPROVEMENTS[idx]
    print(f"\n--- idx {idx}: {kind} {target} | {msg[:50]} ---", flush=True)

    # write target file
    d = os.path.dirname(target)
    if d: os.makedirs(d, exist_ok=True)
    with open(target, "w", encoding="utf-8", newline="\n") as f:
        f.write(content)
    print(f"  wrote {target} ({len(content)} bytes)", flush=True)

    # commit (-c overrides must come before the commit subcommand)
    git("add", "-A")
    rc = git("-c", "user.name=lvyuan1688", "-c", "user.email=lvyaoyuan168@gmail.com",
             "commit", "-m", msg)
    if rc.returncode != 0:
        print(f"  commit FAIL: {rc.stderr.strip()[:150]}", flush=True)
        results.append({"idx": idx, "commit_ok": False, "err": rc.stderr.strip()[:150]})
        continue
    print(f"  commit ok", flush=True)

    # push clean-push:main to origin (fast-forward, clean history)
    rc, out, err = run_cmd("git", "push", "origin", "clean-push:main", timeout_s=60)
    if rc != 0:
        print(f"  push FAIL rc={rc}: {err.strip()[:200]}", flush=True)
        results.append({"idx": idx, "commit_ok": True, "push_ok": False, "err": err.strip()[:200]})
        continue
    print(f"  push ok", flush=True)

    # create release
    patch = base + n + 1
    tag = f"v0.1.{patch}"
    name = f"atomcode {tag} - {kind} maintenance"
    body = f"Patch release {tag} ({today}).\n\n## Changes\n- {msg}\n\nActive maintenance by lvyuan1688."
    ok, resp = gh_post(f"/repos/{REPO}/releases",
                       {"tag_name": tag, "target_commitish": "main", "name": name, "body": body, "draft": False, "prerelease": False})
    if ok:
        print(f"  release {tag} ok: {resp.get('html_url','')}", flush=True)
        results.append({"idx": idx, "commit_ok": True, "push_ok": True, "release_tag": tag, "release_url": resp.get("html_url",""), "release_ok": True})
    else:
        print(f"  release {tag} FAIL: {resp}", flush=True)
        results.append({"idx": idx, "commit_ok": True, "push_ok": True, "release_tag": tag, "release_ok": False, "err": resp})

print("\n=== DONE ===", flush=True)
print(json.dumps(results, indent=2, ensure_ascii=False), flush=True)
