# GBP Diagnostic

**Local SEO triage for Claude Code.** Point it at a Google Business Profile and it comes back with the three-to-five things actually holding the rankings back — in fix order, with the first one called out — plus a client-ready audit page branded to your agency.

It is the clarity scan you run *before* a full audit. Not instead of one.

> Local rankings don't stall because fifty things are broken. They stall because a few critical signals are misaligned or missing.

---

## Why this exists

Most local SEO audits produce a 40-page tool dump that tells you everything that is technically wrong and nothing about what to do on Monday. This runs the opposite way: a time-boxed evidence sweep, seven ordered checks, and a verdict that names the limiters and stops.

The output is deliberately short. If the diagnosis is "your competitors are simply better and you need reviews before anything else matters," it says that in one line and does not pad it out.

---

## Install

**As a plugin (recommended):**

```
/plugin marketplace add jackson7705/gbp-diagnostic
/plugin install gbp-diagnostic
```

**Or manually:**

```bash
git clone https://github.com/jackson7705/gbp-diagnostic.git
cd gbp-diagnostic
./install.sh
```

Restart Claude Code afterwards — skills are discovered at startup, not per session.

---

## Use

```
/gbp-diagnostic Halvorsen Dental, Portland OR
/gbp-diagnostic https://maps.app.goo.gl/xxxxxxxx
/gbp-diagnostic                    ← it will ask for the business
```

Give it a business name and city, or just paste a Google Maps link and it will resolve the rest.

**Triaging a batch of leads?** Paste the list. You get one audit per lead plus a ranked triage summary, best opportunity first.

---

## First run: your agency branding

The first time you run it, it asks four things — once:

- **Agency name** (required)
- **Logo** — a file path on your machine, optional
- **Accent colour** — a hex from your brand, optional
- **Footer line** — website or email for the report foot, optional

Every audit after that carries your identity. Stored at `~/.claude/gbp-diagnostic/brand.json`, **outside** the skill directory, so updating or reinstalling never wipes it.

Change it any time — *"update my agency branding"* — or without a session:

```bash
plugins/gbp-diagnostic/scripts/brand.sh set "Northline SEO" ~/logo.svg "#1F3A93" "northlineseo.com"
plugins/gbp-diagnostic/scripts/brand.sh show
```

Logos are base64-embedded into the report page, because published pages block external images — a logo referenced by URL would silently break. An SVG is ideal.

Your brand sets the masthead, the footer, and the accent colour. It deliberately does **not** recolour the PASS/FLAG/FAIL chips: severity has to read identically on every audit, and an agency with a red brand shouldn't end up with a page where everything looks like a failure.

---

## What you get

Two deliverables, every run:

1. **`GBP-DIAGNOSTIC.md`** — the working file, in your project folder.
2. **A published audit page** — branded, shareable, sent to you as a link.

The page is **private until you share it** from its share menu. Publishing is not sending. Diagnostics tend to be blunt, so you decide when the client reads it.

The page covers: the verdict and first fix, a chart of whatever number decides the case, the six check results with severity chips, **what's already working**, the priority path on a timeline, and an honest list of what the evidence sweep couldn't retrieve.

That "what's already working" section is not padding. A page that is nothing but failures reads as a sales document rather than a diagnosis, and it hides the findings that change the shape of the engagement.

---

## The seven checks

| # | Check | The question |
|---|---|---|
| 1 | GBP alignment | Are the category, services, description and website link pointing the same direction? |
| 2 | Anchor page intent | Which page should Google trust for the main category — and does it claim it? |
| 3 | URL & structure | Clean and logical, or buried and overlapping? |
| 4 | Service page intent | Does this page actually deserve to rank? |
| 5 | Internal links | Does the blog drive authority into the money pages? *(8 in 10 sites fail this)* |
| 6 | Competitor context | Are they beatable, or simply better? |
| 7 | Diagnosis | The 3–5 limiters, in fix order. |

Limiters almost always fall into: GBP misalignment · anchor page confusion · weak service pages · dirty structure · internal linking failures · keyword cannibalization · competitors simply outperforming.

---

## Requirements

- **Claude Code**
- **[MCP Scraper](https://github.com/boshify/mcp-scraper)** — used for GBP data, SERPs and map results. Strongly recommended.

Without MCP Scraper the skill still runs, falling back to direct fetch and web search, but GBP category/services/review data is much harder to retrieve and some fields will come back unknown. It reports those as evidence gaps rather than guessing — see below.

Ahrefs is optional garnish for competitor context. The diagnostic never blocks on it.

---

## What it will not do

- **It does not edit anything.** It reads. It never touches a client's GBP, site, or listings — it hands you a prioritized path you execute.
- **It does not invent numbers.** When a tool times out or returns nothing, the field is reported as unretrieved and listed under evidence gaps. No estimates dressed as data.
- **It does not manufacture problems.** If the site is fine, it says so. "The competition is simply better" is a legitimate verdict, and often the most useful one.
- **It is not a full audit.** No crawl report, no keyword research, no backlink analysis. It tells you where to point those.

---

## Credits

The method is the **12-Minute Diagnostic System**, as taught by [Locafy](https://locafy.com). This repo is an implementation of that method for Claude Code; it does not redistribute the course.

MIT licensed — see [LICENSE](LICENSE).
