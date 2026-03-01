#!/usr/bin/env python3
"""Image Downloader Skill

Usage examples (see README):
 - Download by page URL:
    python image_skill.py --page-url <unsplash-page-url> --out-base assets/images/hero-x
 - Search via UI and pick first result:
    python image_skill.py --search "artificial intelligence" --pick 1 --out-base assets/images/feature-x

"""
import argparse
import json
import os
import re
import sys
from urllib.parse import urlparse

# Minimal imports for runtime checks
try:
    from playwright.sync_api import sync_playwright
except Exception:
    sync_playwright = None

try:
    import requests
    from PIL import Image
except Exception:
    requests = None
    Image = None

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
CREDITS = os.path.join(ROOT, 'assets', 'credits.md')
METADATA = os.path.join(ROOT, 'data', 'model-metadata.json')


def accept_cookies_and_extract(page_url, headless=True):
    """Open page, accept a cookie dialog (best effort), return page JSON or largest image url and author metadata.

    headless: if False, launches a visible browser to allow demoing cookie acceptance interactively.
    """
    if not sync_playwright:
        raise RuntimeError('Playwright is not installed; see README and install requirements')
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=headless)
        page = browser.new_page()
        page.goto(page_url, timeout=30000)
        # try to click cookie buttons
        selectors = ['text="Accept"', 'text="Alle akzeptieren"', 'text="Accept all"', 'button:has-text("Accept")']
        for s in selectors:
            try:
                btn = page.query_selector(s)
                if btn:
                    btn.click()
                    break
            except Exception:
                pass
        # try to read /napi/photos/<slug>
        try:
            # find photo link
            a = page.query_selector('a[href*="/photos/"]')
            if a:
                href = a.get_attribute('href')
                # navigate to the photo page to fetch metadata
                photo_page = page.context.new_page()
                photo_page.goto(href)
                # fetch napi
                slug = href.split('/')[-1]
                napi = photo_page.evaluate(f'async () => {{ try {{ const res = await fetch("/napi/photos/" + "{slug}"); return res.ok ? await res.json() : null }} catch(e){{return null}} }}')
                # find largest src
                img = photo_page.query_selector('img[src*="images.unsplash.com/photo-"]')
                largest = None
                if img:
                    srcset = img.get_attribute('srcset') or ''
                    parts = [p.strip() for p in srcset.split(',') if p.strip()]
                    best = None
                    for p in parts:
                        try:
                            url,w = p.split(' ')
                            wnum = int(w.replace('w',''))
                            if not best or wnum>best[0]: best=(wnum,url)
                        except Exception:
                            pass
                    largest = best[1] if best else img.get_attribute('src')
                author = None
                author_el = photo_page.query_selector('a[href^="/@"]')
                if author_el:
                    author = { 'name': author_el.inner_text().strip(), 'url': author_el.get_attribute('href') }
                photo_page.close()
                browser.close()
                return { 'napi': napi, 'largest': largest, 'author': author }
        except Exception:
            pass
        # fallback: attempt find first image on search page
        img = page.query_selector('img[src*="images.unsplash.com/photo-"]')
        largest = img.get_attribute('src') if img else None
        browser.close()
        return { 'napi': None, 'largest': largest, 'author': None }


def download_image(url, out_base, source_page=None):
    """Download image and produce -1280/-640 and webp variants. Append credits minimal entry to assets/credits.md"""
    import requests
    from PIL import Image
    from io import BytesIO
    headers={'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'}
    if source_page:
        headers['Referer']=source_page
    print('Downloading', url)
    r = requests.get(url, headers=headers, timeout=30)
    r.raise_for_status()
    img = Image.open(BytesIO(r.content)).convert('RGB')
    os.makedirs(os.path.dirname(out_base) or '.', exist_ok=True)
    orig = out_base + '.jpg'
    img.save(orig, 'JPEG', quality=95)
    for s in (1280, 640):
        im = img.copy()
        im.thumbnail((s, s), Image.LANCZOS)
        jpg = f"{out_base}-{s}.jpg"
        webp = f"{out_base}-{s}.webp"
        im.save(jpg, 'JPEG', quality=85)
        im.save(webp, 'WEBP', quality=80)
    # append credit stub
    with open(CREDITS, 'a', encoding='utf-8') as f:
        f.write('\n- file: ' + os.path.relpath(orig, start=ROOT) + '\n')
        f.write('  provider: Unsplash\n')
        if source_page:
            f.write('  source_url: ' + source_page + '\n')
        f.write('  fetch_method: browser-automated-download\n')
    print('Saved', orig)
    return orig


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--page-url')
    parser.add_argument('--search')
    parser.add_argument('--pick', type=int, default=1, help='Which result to pick from search (1-based)')
    parser.add_argument('--out-base', required=True, help='Output basename (e.g. assets/images/hero-3)')
    parser.add_argument('--no-headless', action='store_true', help='Run browser with GUI (non-headless) for demo/inspection')
    args = parser.parse_args()

    # determine headless flag (allow --no-headless to run visible browser for demo)
    headless = not getattr(args, 'no_headless', False)

    if args.page_url:
        res = accept_cookies_and_extract(args.page_url, headless=headless)
        url = res.get('largest')
        author = res.get('author')
        napi = res.get('napi')
        if not url:
            print('No image found on page')
            sys.exit(1)
        orig = download_image(url, args.out_base, source_page=args.page_url)
        print('Downloaded to', orig)
        # update metadata minimal
        try:
            with open(METADATA, 'r', encoding='utf-8') as f:
                meta = json.load(f)
        except Exception:
            meta = {}
        meta.setdefault('images', {})
        meta['images']['hero'] = orig.replace('\\','/')
        meta['images']['hero_credit'] = { 'author': author['name'] if author else 'unknown', 'author_url': author['url'] if author else '', 'source_url': args.page_url, 'license': 'https://unsplash.com/license', 'fetch_date': '' }
        with open(METADATA, 'w', encoding='utf-8') as f:
            json.dump(meta, f, indent=4, ensure_ascii=False)
        print('Updated metadata')
        sys.exit(0)

    if args.search:
        if not sync_playwright:
            raise RuntimeError('Playwright not installed; see README')
        with sync_playwright() as p:
            browser = p.chromium.launch(headless=headless)
            page = browser.new_page()
            page.goto('https://unsplash.com/s/photos/' + args.search)
            # accept cookie
            try:
                btn = page.query_selector('text="Accept"') or page.query_selector('text="Alle akzeptieren"')
                if btn: btn.click()
            except Exception:
                pass
            imgs = page.query_selector_all('img[src*="images.unsplash.com/photo-"]')
            idx = args.pick-1
            if idx < 0 or idx>=len(imgs):
                print('No such result')
                sys.exit(1)
            img = imgs[idx]
            # choose the >=1280 url if available
            srcset = img.get_attribute('srcset') or ''
            chosen = None
            for part in srcset.split(','):
                ppart = part.strip().split(' ')
                if len(ppart)>=2 and ppart[1].endswith('w') and int(ppart[1][:-1])>=1280:
                    chosen = ppart[0]; break
            if not chosen:
                chosen = img.get_attribute('src')
            # find photo page
            link = img.closest('a')
            photo_href = link.get_attribute('href') if link else None
            author_el = page.query_selector('a[href^="/@"]')
            author = None
            if author_el:
                author = { 'name': author_el.inner_text().strip(), 'url': author_el.get_attribute('href') }
            browser.close()
        orig = download_image(chosen, args.out_base, source_page=photo_href)
        print('Downloaded', orig)
        # append credit similar to page flow
        # (user can run metadata update separately)
        sys.exit(0)

    parser.print_help()


if __name__ == '__main__':
    main()
