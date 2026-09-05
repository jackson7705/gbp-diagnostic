# Building the client-facing Artifact

Stage 5 of every diagnostic. The markdown report is the working file; **this page is the deliverable** — the thing the agency forwards to their client. Build it every time, without being asked.

Load the `artifact-design` skill before writing the page. This file covers what is specific to a GBP diagnostic; that skill covers the craft.

---

## Treatment

A diagnostic is a **serious document that gets forwarded to someone paying for an answer**. Aim for polished and utilitarian — real typographic hierarchy, considered spacing, a proper palette. Not a landing page, no oversized hero, no decorative flourish.

The reader is usually the business owner, not an SEO. Terms of art are fine — that is what they are buying — but every finding states its evidence in plain numbers.

---

## Page order

Mirror the diagnostic's own logic. Verdict first, always.

1. **Masthead** — agency logo/wordmark, client business name, category and city, date, links to the site and the GBP (CID).
2. **Verdict** — the first fix in a callout, then the 3–5 limiters numbered in fix order. The numbering is real: it is the order of execution, so numbered markers are earned here.
3. **The decisive chart** — one visual that carries the headline finding. See below.
4. **Step results** — the six checks with PASS / FLAG / FAIL chips and one line of evidence each.
5. **What's already working** — findings in the client's favour. Never skip this section. It is honest, it changes the shape of the engagement, and a page that is nothing but failures reads as a sales document rather than a diagnosis.
6. **Priority path** — Week 1 → Month 3 (→ Months 4–6 where the work runs deep) on a timeline. A real sequence.
7. **Risks, notes and gaps** — guideline violations to defuse, assumptions made, and everything the evidence sweep could not retrieve.

---

## The chart

Every diagnostic has one number that decides it — review counts against the map pack, service page depth against the top 3, position over time. Find it and draw it. One chart, sized to the finding.

Horizontal bars ranking the competitive set with the client's bar in the `fail` colour is the workhorse: it makes a gap self-evident without a sentence of explanation.

Rules that matter:

- **Label the client's bar and the reference line.** A bar chart without a median or a pack floor is just shapes.
- **Reference lines draw on top of the bars, not behind them.** A line painted onto the track background disappears under every filled bar that crosses it and appears only on the short bars — which reads as a rendering bug. Use an `::after` on the track, positioned absolutely, above the fill.
- **Give the reference line its own token** that reads against both the empty track and the filled bar, in both themes.
- Bars use one muted neutral; only the client's bar takes semantic colour. Do not rainbow the competitors.
- `font-variant-numeric: tabular-nums` on every value column.
- Chart text takes its colour from theme tokens, never a literal.

State the retrieval date on the chart. SERPs move.

---

## Branding

From `brand.json` (see `branding.md`):

- `logoDataUri` → masthead. Constrain with `max-height: 34px; width: auto`. No logo? Set `agencyName` as a letter-spaced wordmark in the accent colour.
- `accentHex` → the `--accent` token, used for eyebrows, the first-fix callout rule, the active timeline node, and links.
- `agencyName` + `footer` → page footer, with the date.

**The accent is the only brand colour on the page.** PASS/FLAG/FAIL keep their own semantic palette (moss / ochre / brick) regardless of agency brand — severity has to read the same on every audit, and an agency whose brand colour is red must not end up with a page where everything looks like a failure.

If `accentHex` clashes badly with the semantic triad (a red or orange brand accent), desaturate the accent or shift it toward its analogous neighbour rather than changing the severity colours.

---

## Technical constraints

Published Artifacts run under a strict CSP. These bite:

- **External images are blocked.** The logo must be a `data:` URI. This is why `brand.json` stores it encoded.
- **Fonts** load only from `fonts.googleapis.com`. Always declare a real fallback stack.
- **No downloads.** `<a download>` and script-driven saves are inert for viewers — never offer "download this report as PDF". Viewers print to PDF from the browser instead.
- **Write the page content only** — no `<!DOCTYPE>`, `<html>`, `<head>` or `<body>` tags. Put `<title>` and `<style>` at the top of the file.

### Both themes, three states

Define the complete light palette on bare `:root`; redefine tokens under `@media (prefers-color-scheme: dark)` guarded as `:root:not([data-theme="light"])`; redefine again under `:root[data-theme="dark"]`. Give `body` an explicit token background. A colour whose only definition sits inside a media or `[data-theme]` block will not apply in the default un-stamped state — that is the classic unreadable-artifact bug, and it ships a broken page to a client.

### Look once

Render the file and take **one** screenshot before publishing — spend it on the chart, which is where the real bugs are. Then one pass of fixes, then publish. Do not build a test loop.

```bash
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless --disable-gpu \
  --hide-scrollbars --window-size=1200,3400 --virtual-time-budget=6000 \
  --screenshot=shot.png "file://$PWD/page.html"
```

Headless Chrome usually renders the dark palette, which conveniently checks the theme most likely to be broken.

---

## Naming

`<title>` is the name in the client's browser tab and the agency's gallery, where it sits beside every other audit. Make it identify *this* client:

- Good: `Nino Chan GBP Diagnostic`, `Halvorsen Dental Local Audit`
- Bad: `GBP Diagnostic Report` (indistinguishable from every other audit), `Local SEO Audit — Findings and Recommended Priority Path` (a summary, not a name)

Pass a one-sentence `description` for the gallery card, and a `favicon` on first publish.

---

## Handoff

Give the URL, then state plainly: **the page is private until shared from its share menu.** Diagnostics are usually blunt, and the agency decides when the client reads it. Do not announce a page as "sent to the client" — publishing is not sending.

To revise later, republish the same file path (same URL). Do not create a second artifact for a corrected audit.
