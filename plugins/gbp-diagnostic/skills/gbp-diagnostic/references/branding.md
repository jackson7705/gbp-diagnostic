# Agency branding — first-run onboarding

Audits ship under the operating agency's name. This file defines how that identity is captured once and applied to every audit afterwards.

**Location:** `~/.claude/gbp-diagnostic/brand.json`

It deliberately sits **outside** the skill directory so that reinstalling, updating, or re-cloning the skill never destroys it.

---

## When to run onboarding

| Situation | Action |
|---|---|
| `brand.json` missing | Run the onboarding below, in the same message as Stage 1 intake |
| `brand.json` present | Read it silently. **Never re-ask.** |
| "update my branding", "change our logo", "rebrand the audits" | Re-run onboarding, pre-filled with existing values |
| Onboarding declined or skipped | Write `brand.json` with `agencyName` only and proceed |

Onboarding is a single message, not an interview. Ask all of it at once.

---

## What to ask

Ask these together, marking clearly which are optional:

1. **Agency name** — required. Appears on every report and Artifact. ("Northline SEO")
2. **Logo** — optional. A path to a local PNG/SVG/JPG file. Say plainly: *"a file path on this machine — I'll embed it in the report so it travels with the page."*
3. **Accent colour** — optional. A hex value from their brand. Defaults to a neutral ink blue (`#1F3A93`) if not given.
4. **Report footer line** — optional. Website, email, or phone that should appear at the foot of client-facing audits.

Do not ask for anything else. No taglines, no brand guidelines, no font uploads — the audit is a diagnostic document, not a brochure.

---

## Why the logo has to be a file path

Published Artifacts run under a Content Security Policy that **blocks external images entirely**. A logo referenced by URL will silently fail to load and the client gets a broken page.

So the logo is read from disk, base64-encoded, and stored as a `data:` URI inside `brand.json`. It then travels inside every audit page with no external request.

If the user offers a URL instead of a path, download it first, then encode from the downloaded file.

---

## Encoding the logo

Keep the encoded logo **under ~200 KB** — it is embedded in every page, and the Artifact size ceiling is 16 MB total.

```bash
mkdir -p ~/.claude/gbp-diagnostic

LOGO="/path/to/logo.png"
BYTES=$(wc -c < "$LOGO")

# Downscale raster logos that are too heavy (macOS: sips; Linux: ImageMagick)
if [ "$BYTES" -gt 200000 ]; then
  if command -v sips >/dev/null; then
    sips -Z 600 "$LOGO" --out /tmp/gbp-logo.png >/dev/null && LOGO=/tmp/gbp-logo.png
  elif command -v convert >/dev/null; then
    convert "$LOGO" -resize 600x600\> /tmp/gbp-logo.png && LOGO=/tmp/gbp-logo.png
  fi
fi

# MIME type from the extension
case "${LOGO##*.}" in
  png) MIME=image/png ;;
  jpg|jpeg) MIME=image/jpeg ;;
  svg) MIME=image/svg+xml ;;
  webp) MIME=image/webp ;;
  *) MIME=image/png ;;
esac

echo "data:$MIME;base64,$(base64 < "$LOGO" | tr -d '\n')" > /tmp/gbp-logo-datauri.txt
wc -c < /tmp/gbp-logo-datauri.txt   # sanity-check the size
```

An SVG logo is ideal — it stays crisp and is usually the smallest. Encode it as-is; do not rasterize it.

---

## The file

Write it with a JSON-safe encoder (the data URI is long — never hand-assemble the file with `echo`):

```bash
python3 - <<'PY'
import json, os, pathlib
d = pathlib.Path.home() / ".claude" / "gbp-diagnostic"
d.mkdir(parents=True, exist_ok=True)
logo = ""
p = "/tmp/gbp-logo-datauri.txt"
if os.path.exists(p):
    logo = open(p).read().strip()
brand = {
    "agencyName": "Northline SEO",
    "logoDataUri": logo,
    "logoAlt": "Northline SEO",
    "accentHex": "#1F3A93",
    "footer": "northlineseo.com · hello@northlineseo.com",
    "updatedAt": "2026-09-05",
}
(d / "brand.json").write_text(json.dumps(brand, indent=2))
print("wrote", d / "brand.json")
PY
```

### Schema

| Key | Required | Notes |
|---|---|---|
| `agencyName` | yes | Full name, as it should read on a client deliverable |
| `logoDataUri` | no | `data:image/...;base64,...` — empty string when none |
| `logoAlt` | no | Alt text; defaults to `agencyName` |
| `accentHex` | no | Brand accent; defaults to `#1F3A93` |
| `footer` | no | One line of contact detail for the report foot |
| `updatedAt` | no | ISO date of last change |

Unknown keys are ignored, so the file is safe to extend by hand.

---

## Applying the brand

Read the file at Stage 0 and carry the values into both deliverables:

- **Markdown report** — agency name on the `Prepared by` line, `footer` at the bottom.
- **Artifact** — logo (or wordmark) in the masthead, `accentHex` bound to the `--accent` token, agency name and `footer` in the page footer. See `artifact-guide.md`.

**The brand is a frame, not a costume.** It goes in the masthead and the footer and sets the accent. It does not recolour severity chips, rewrite the verdict's tone, or soften a FAIL. A diagnostic that flatters the agency at the expense of the finding is worthless to the client who acts on it.

### Missing logo

Set the agency name as a wordmark instead — the display face at masthead scale, letter-spaced, in the accent colour. This looks deliberate, not broken. Never render an empty box or a placeholder graphic.

### Reading it

```bash
cat ~/.claude/gbp-diagnostic/brand.json 2>/dev/null || echo "FIRST_RUN"
```

`FIRST_RUN` means onboard. Anything else, parse and apply.
