# info/ — Claude guidance

**Before designing, building, or naming anything, read every file in this folder.**

This is the ground truth about the client. Every design and content decision should trace back to something here. If the answer isn't in these files, ask Amila — do not invent.

## Files

| File                 | Purpose                                                              |
|----------------------|----------------------------------------------------------------------|
| `questionnaire.md`   | The base Q&A sent to the client. Client answers live here inline.    |
| `business.md`        | About the business — products/services, voice, USP, competitors.     |
| `audience.md`        | Target audience, personas, pains, goals.                             |
| `brand.md`           | Brand direction, references, dos/don'ts, existing assets.            |
| `sitemap.md`         | Pages, structure, primary CTAs per page.                             |
| `technical.md`       | Domain, hosting, integrations, constraints, analytics.               |
| `feedback.md`        | Running log of client feedback per review round.                     |
| `notes/`             | Free-form raw notes — call transcripts, chat excerpts, voice memos.  |

## How replies come in

Amila relays client replies in whatever form they arrive. When given raw input:

1. Drop the raw text into `info/notes/<date>-<context>.md` so nothing is lost.
2. Extract structured info into the relevant `info/*.md` file above.
3. **If there's a gap or ambiguity, ask Amila** — don't assume.
4. Never guess a brand color, font, or content preference. If it isn't written down, it isn't decided.

## When feedback lands

After a review round, append to `info/feedback.md` with a timestamp, the verbatim feedback, and what changed in response. This becomes the change log.
