# GBP-DIAGNOSTIC.md — Report Template

Copy this structure. Lead with the verdict; keep evidence to one line per check. The report is a triage document, not an audit.

```markdown
# GBP Diagnostic — {Business Name}, {City}

**Date:** {date} · **Website:** {url} · **GBP:** {maps link}
**Main service / target category:** {category}
**Prepared by:** {agencyName from brand.json}
**Client report:** {published Artifact URL — always present; see artifact-guide.md}
**Method:** 12-Minute Diagnostic System

## Verdict — Ranking Limiters (fix in this order)

1. **{Limiter}** — {one-line evidence}
2. **{Limiter}** — {one-line evidence}
3. **{Limiter}** — {one-line evidence}
{3–5 total. Taxonomy: GBP misalignment · anchor page confusion · weak service
pages · dirty structure · internal linking failures · keyword cannibalization ·
competitors simply outperforming}

**First fix:** {the single change to make first, and why}

## Step Results

| # | Check | Result | Evidence |
|---|-------|--------|----------|
| 1 | GBP alignment | PASS/FLAG/FAIL | {primary cat, services, description intent, address/SA, website link, GBP↔site message} |
| 2 | Anchor page intent | PASS/FLAG/FAIL | {anchor = home page or location page; reinforces category? diluted? linked from GBP?} |
| 3 | URL & structure | PASS/FLAG/FAIL | {clean URLs? buried services? overlaps?} |
| 4 | Service page intent | PASS/FLAG/FAIL | {deserves to rank? depth vs competitors? thin/generic?} |
| 5 | Internal links | PASS/FLAG/FAIL | {home → services/locations? blog → money pages? orphans?} |
| 6 | Competitor context | PASS/FLAG/FAIL | {top-3 stronger? deeper pages? cleaner GBP?} |

## Emergency Tech Flags

- HTTPS: {ok / NOT SECURE}
- Single canonical version: {ok / http+https or www+non-www both load → duplicate-content risk}
- Navigation: {ok / broken or off-pattern for the niche}

## Priority Path

**Week 1 — limiters + emergency fixes**
- {GBP categories/services/description fixes}
- {GBP ↔ website alignment fixes}
- {Anchor page clarity fixes}
- {Emergency tech fixes, if flagged}

**Month 1 — clean-build foundation** (2–3 items max)
- {URL structure / cannibalization cleanup / strengthen 1–2 service pages / internal linking / nav cleanup}

**Month 2 — intent reinforcement**
- {Deepen anchor pages, topical support, contextual links, GBP-site synergy, E-E-A-T}

**Month 3 — trust & momentum**
- {Review velocity, photos, proof content, re-check competition, strengthen high-potential pages}

{If issues run deep, note that the plan stretches to 6 months and say which items slide.}

## What's Already Working

- {Findings in the client's favour — checks that passed, and why that changes the shape of the work}
{Never omit this section. If genuinely nothing passed, say that explicitly rather than deleting the heading.}

## Notes

- This is a clarity scan, not a full audit — it tells us what to fix first, not everything that's wrong.
- {Anything ambiguous, assumptions made, evidence gaps — name every field a tool failed to retrieve rather than estimating it}

---
{footer from brand.json} · {agencyName}
```

## Batch triage summary (multiple leads)

When diagnosing several leads, also write `GBP-TRIAGE-SUMMARY.md`:

```markdown
# GBP Triage Summary — {date}

| Rank | Business | Verdict (top limiter) | Opportunity | Why |
|------|----------|----------------------|-------------|-----|
| 1 | {name} | {limiter} | High | {clear limiters, fast fixes} |
| 2 | {name} | {limiter} | Medium | {…} |
| 3 | {name} | {limiter} | Long game | {competition simply better} |
```

Opportunity scale: **High** = clear limiters we can fix fast (GBP alignment, internal links, anchor clarity). **Medium** = structural work needed (URLs, service page rebuilds). **Long game** = competition simply outperforms; requires sustained investment.
