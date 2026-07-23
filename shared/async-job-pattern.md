# Async job pattern (submit → poll → read)

Several ColdIQ endpoint groups are asynchronous: you POST a job, get an id, then poll a GET
until it returns results. This is the shape for **batch** (`/v1/limadata/batch/*`), **export/email-finder**
(`/v1/ai-ark/people/export`, `…/email-finder`), **scrapers** (`/v1/meta-ads/*`, `/v1/google-maps/*`,
`/v1/reddit/*`, `/v1/linkedin-ad-library/*`, `/v1/google-ads/*`), **bulk enrichment**
(`/v1/fullenrich/contact/enrich/bulk`, `/v1/wiza/lists`), and **post engagement** (`/v1/jungler/*`).

## Contract

```
POST  <submit_path>            → { id | jobId | trackId | enrichment_id }   (often HTTP 202)
GET   <poll_or_result_path>    → 202 while running, 200 with results when done
```

The catalog entry carries `"async": true` plus `poll_path` and/or `result_path` (with the id
placeholder), so an agent can chain the two calls without guessing.

## Generic poll loop

```python
import time, requests

def poll_job(get_url, headers, interval=10, max_wait=600):
    """Poll an async ColdIQ job until it returns results (HTTP 200)."""
    elapsed = 0
    while elapsed < max_wait:
        r = requests.get(get_url, headers=headers)
        if r.status_code == 200:
            return r.json()              # done
        if r.status_code not in (200, 202):
            r.raise_for_status()         # real error
        time.sleep(interval)             # 202 = still running
        elapsed += interval
    raise TimeoutError(f"job not finished within {max_wait}s")
```

## Rules

- **Poll every ~60s** for batch/scraper jobs; ~10s is fine for small bulk enrichment jobs.
- **Pull pages as they complete** for large batch prospect jobs — don't block on full completion.
- **Reserve credits upfront, settle on completion**: many per-result endpoints reserve worst-case
  credits at submit and refund the unused portion when the job finishes.
- Scraper/poll GETs are **free** (`credits: free`) — only the submit costs.
