---
name: gbp-diagnostic
description: Run the 12-Minute Diagnostic System — a fast clarity scan that finds the 3–5 real ranking limiters holding back a Google Business Profile or local website, then outputs a prioritized fix path plus a client-ready branded report page. NOT a full audit; it's the triage you run before one. Use whenever a GBP is stuck or not moving, a local site's rankings are flat, a map-pack position has stalled, when evaluating a new local client or triaging a batch of leads, when sanity-checking a full audit, or when the user says "why isn't this GBP ranking", "diagnose this GBP", "GBP stuck", "map pack dropped", "local rankings flat", "triage these leads", or "12-minute diagnostic". Automatically orchestrates mcp-scraper evidence collection so teammates never call scraper tools, and always publishes the finished audit as a shareable Artifact branded to the running agency.
---

# GBP Diagnostic (12-Minute Diagnostic System)

Method: the **12-Minute Diagnostic System**, as taught by Locafy. The complete method is written out below — this skill is self-contained.

Local rankings don't usually stall because fifty things are broken. They stall because **a few critical signals are misaligned or missing**. The job of this diagnostic is NOT to fix everything or run every tool — it's to quickly identify the **3–5 ranking limiters that matter first**, before a full audit, before tool rabbit holes, and before hours are wasted fixing the wrong things.

Mantra: **Clarity before depth. Truth before tactics. Direction before execution.**

When to deploy:
- A GBP or local site isn't ranking like it should and nobody knows where to start
- Evaluating a new client or triaging a batch of inbound leads ("can we even help them?")
- A previously-moving GBP has stalled; a project is stuck
- Getting clarity when overwhelmed; avoiding audit rabbit holes
- Sanity-checking a completed full audit

What this is NOT: a full audit, a technical crawl report, or a keyword research pass. If the user wants those, this skill runs *first* and hands its verdict to the deeper work.

## Invocation flow

Run these six stages in order, announcing each as you enter it ("Stage 3/6 — evidence sweep…") so the teammate always knows where the diagnostic stands:

0. **Brand check** — read `~/.claude/gbp-diagnostic/brand.json`. If it does not exist, this is a first run: complete the onboarding in `references/branding.md` before anything else. Every report and Artifact carries this agency's identity, so it has to be settled up front. On later runs this stage is a silent file read — never re-ask a teammate who is already onboarded.
1. **Intake** — resolve the Inputs below. If anything is missing, ask for ALL missing items in one message — with Stage 0, the only stage that stops for the user. On a first run, fold the brand questions and the intake questions into that single message. Batch mode: confirm the lead list before starting.
2. **Evidence sweep** — collect everything in the evidence table, up front, time-boxed. No diagnosing yet.
3. **Seven steps** — work Steps 1–7 strictly in order, recording PASS / FLAG / FAIL plus the one-line evidence note *as each step completes*, not retroactively at the end.
4. **Report** — write the markdown report from `references/report-template.md` per the Output section: verdict first, then Priority Path.
5. **Artifact** — publish the branded client-facing page. **This is not optional** — see Output. Build it per `references/artifact-guide.md`.
6. **Handoff** — in chat, state the 3–5 limiters with the single first fix called out, give the Artifact URL, point to the markdown file, and offer the next moves: run the Week 1 fixes now, proceed to a full audit, or (for a mature site that's plateaued) an Unstuck escalation.

## Inputs

Resolve before starting (from the user, project files, or `custom/projects/<active>/`):
1. **Business name + city** (or a Google Maps / GBP link)
2. **Website URL**
3. **Main service / primary category the client wants to rank for** (if unknown, infer from the GBP primary category in Step 1 and confirm in the report)

If the user gives a batch of leads, run the whole diagnostic per lead and produce one report per lead plus a ranked triage summary (best-opportunity first).

## Agency branding

Audits go out under the running agency's name, not the tool's. The brand lives at `~/.claude/gbp-diagnostic/brand.json`, outside the skill directory so reinstalling or updating the skill never clobbers it.

- **First run** (no `brand.json`): run the onboarding in `references/branding.md`. It collects agency name, logo, accent colour, and report footer contact, and writes the file. Ask once, in the same message as the Stage 1 intake questions.
- **Every later run**: read the file silently and apply it. Never re-ask.
- **Changing it**: "update my agency branding" / "change the logo" re-runs the onboarding against the existing file.
- **No logo supplied**: proceed with a wordmark set in the agency name. The audit is never blocked on a missing asset.

Full spec, the JSON shape, and the logo-to-data-URI commands are in `references/branding.md`.

## Evidence collection (agent-run, time-boxed)

Call MCP Scraper tools directly — never ask the teammate to run them. Gather once, up front, then eyeball. Keep the spirit of the system: this is a **clarity scan**, not a crawl. Do not spiral into full-site extraction.

| Evidence | Tool | Feeds steps |
|---|---|---|
| GBP data: primary + secondary categories, services, description, address/service area, website link, reviews, photos | `maps_place_intel` (set `includeServices: true`) | 1, 7 |
| Local pack + top-3 competitors for the main category + city | `maps_search`, `search_serp` | 6 |
| Site URL inventory / structure | `map_site_urls` | 3, 5 |
| Home page, location page, main service page(s) content | `extract_url` (3–6 pages max) | 2, 4, 5 |
| Competitor anchor/service pages (top 1–2 competitors only) | `extract_url` | 6 |
| Emergency tech signals: HTTPS, redirect of domain variants, navigation renders | `curl -sI` on http/https/www/non-www + `extract_url` of home page | Priority Path |

Ahrefs (when available) is optional garnish — DR/backlink context for the competitor step. Never block the diagnostic on it, and never invent metrics.

## The seven steps

Work through all seven **in order**. For each step, record PASS / FLAG / FAIL plus a one-line evidence note — these become the verdict.

### Step 1 — GBP Alignment Check (start here, 100% of the time)

The GBP is the strongest local signal Google has. If GBP signals are wrong or conflicting, nothing else moves. Check:
- **Primary category** — is it the right one for the money service?
- **Secondary/supporting categories** — present, relevant, not diluting?
- **Services** — complete and matching what the business actually sells?
- **Description intent** — does it reinforce the primary category, or the wrong intent?
- **Address / service area accuracy** — matches reality and the website?
- **Website link relevance** — does the GBP link to the page that actually reinforces the category (not a confusing or generic URL)?
- **GBP ↔ website message alignment** — if the GBP says one thing and the site says another, Google ranks neither (or ranks poorly). Fixing GBP alignment often unlocks everything.

### Step 2 — Anchor Page Intent Check (home page vs location page)

The home page doesn't always have to reinforce the main GBP category — branded and multi-service sites often shouldn't. Ask ONE question: **which page is the anchor Google should trust for the main category?**

If the **home page** is the anchor:
- Does it clearly reinforce the main service/category? Does it match the GBP primary category?
- Is it diluted (under-optimized, too broad, too branded)?
- Does it properly link to the priority pages (core service pages, location pages)?

If a **location page** is the anchor:
- Does it reinforce the GBP category *and* the location?
- Is it deep enough? Internally linked properly?
- Does the home page *support* it instead of competing with it (competition here = keyword cannibalization)?

The goal is not "home page must rank." The goal is: **the anchor page — whichever it is — clearly supports the GBP category and is the page the GBP links to.**

### Step 3 — URL & Structure Check (clean-build scan)

Diagnose structure visually from the URL inventory — no crawler reports needed:
- Are URLs clean and logical?
- Are services buried too deep?
- Unnecessary folders?
- Overlapping URLs that could cannibalize each other?
- Does the structure match the GBP categories/services and their intent?

**Messy structure = messy rankings.** This is fundamental and gets hairy fast; if it's broken, it's a priority fix.

### Step 4 — Service Page Intent Check ("does this page deserve to rank?")

For the page(s) Google should rank for a given service:
- Does it satisfy the intent better than the competitors' pages?
- Is it deep enough? Optimized properly? Structured clearly?
- Does it reinforce the GBP signals?
- Does it demonstrate expertise — or is it thin and generic?

**If the page doesn't deserve to rank, no amount of SEO will save it** — and it won't send the signals Google needs to rank the GBP for that service either.

### Step 5 — Internal Links Check (the most underutilized unlock)

- Does the home page link to the core service pages? (Multi-location: to the location pages too?)
- Are supporting pages pointing authority *upward* to the money pages?
- Are orphan pages killing relevance?
- Is internal linking logical and intentional?
- **The 8-out-of-10-fail check:** is the blog being used to drive authority to important pages (service pages, location pages)? Most sites fail this.

Internal linking is one of the biggest ranking unlocks in local SEO.

### Step 6 — Competitor Context (the reality check)

Look at what's actually ranking in the top 3 (map pack + organic):
- Are competitors simply stronger?
- Do they satisfy intent better? Are their pages deeper?
- Is their structure cleaner? Is their GBP more aligned?

Sometimes the project isn't broken — **the competition is just better**, and the bar is "do better than them," not "fix bugs." This one check can change the entire strategy.

### Step 7 — Diagnosis (the quick verdict)

From steps 1–6, name the **3–5 ranking limiters**. They almost always fall into:
1. GBP misalignment
2. Anchor page confusion
3. Weak service pages
4. Dirty structure
5. Internal linking failures
6. Keyword cannibalization
7. Competitors simply outperforming

**Knowing the limiter(s) = knowing the path forward.**

## Priority Path (fix what matters first)

Write this into the report using `references/report-template.md`. Scale honestly: if the issues run deep (e.g., all eight service pages weak, not one), stretch the 3-month plan to 6.

**Week 1 — ranking limiters + emergency tech fixes**
- GBP: categories, services, description
- GBP ↔ website alignment
- Anchor page intent clarity
- Emergency technical fixes (these can tank rankings on their own):
  - Site not on HTTPS → fix immediately
  - **Multiple site versions loading** (http/https, www/non-www both resolving without redirect) → Google sees duplicate content; can tank rankings
  - **Broken navigation / off-pattern layout** — Google expects sites in a niche to look comparable to the top 3; missing services in nav or broken nav must be fixed

**Month 1 — clean-build foundation** (pick 2–3; doing all is unrealistic)
- URL structure corrections
- Cannibalization cleanup
- Strengthen the (1–2 most important) service pages
- Internal linking optimization
- Navigation cleanup

**Month 2 — intent reinforcement**
- Deepen anchor pages; add topical support; add contextual links
- Improve GBP-to-site synergy
- Boost E-E-A-T

**Month 3 — trust & momentum** (elements can move into months 1–2 depending on what's wrong)
- Review velocity, photo updates, proof content
- Re-evaluate competition (SERPs shift constantly)
- Strengthen high-potential pages
- Standing rule: service pages get refreshed every 3–6 months

## Output

Every diagnostic produces **two** deliverables. The markdown is the working file; the Artifact is what the client sees.

1. **Markdown** — write `GBP-DIAGNOSTIC.md` (per client/lead) into the active project folder if one exists (`custom/projects/<active>/`), else the working directory — use `references/report-template.md`.
   - Lead with the **verdict**: the 3–5 named limiters, each with its one-line evidence.
   - Then the Priority Path (Week 1 → Month 3).
2. **Artifact — always, without being asked.** Publish the finished audit as a branded Artifact and hand back the URL. A diagnostic that ends in a terminal or a local file is not delivered: the whole point is that the agency forwards a link to their client. Build it per `references/artifact-guide.md`, branded from `brand.json`. Never ask "would you like an artifact?" — publish it, then mention it. The one exception is a client on manual-publish rules; even then the Artifact is still built, because it is private until the agency shares it.
3. **Batch mode** — one Artifact per lead, plus `GBP-TRIAGE-SUMMARY.md` ranking leads by opportunity (clear limiters we can fix fast = high; "competition simply better" = long game). Publish the triage summary as its own Artifact too — that is the page the agency reviews internally.
4. Close by reminding: this prevents wasted time inside a full audit but does not replace one. Pair fixes with quick-win tactics for maximum movement (clarity + tactics).

Artifacts are private to the publisher until shared from the page's share menu. Say so at handoff — the verdict is usually blunt, and the agency should choose when the client sees it.

## Guardrails

- Time-box it. The whole point is 12 minutes of clarity, not 4 hours of crawling. Cap evidence collection at the table above.
- Tools point out what's *technically* wrong; judgment decides what's a *priority*. Never present a tool dump as the diagnosis.
- Don't recommend fixing everything — 3–5 limiters, ordered, with the first fix explicit.
- **Diagnose, don't edit.** This skill reads. It never changes a client's GBP, website, or listings — it hands the agency a prioritized path they execute. If a teammate asks you to apply a fix, that's a separate, explicitly authorized job.
- **Report honestly.** Where the evidence says the site is fine, say so — a diagnostic that manufactures five problems to look thorough is worse than useless. "The competition is simply better" is a legitimate verdict, and often the most valuable one. Name what's already working; it changes the shape of the engagement.
- Never invent metrics. If a tool times out or returns nothing, say the field is unretrieved rather than estimating it, and list it under evidence gaps.
- Any local client-publishing rules in the operator's own CLAUDE.md still apply on top of this skill.
