#!/usr/bin/env bash
# validate-site.sh — Quick technical audit for a website
# Usage: ./validate-site.sh <URL>
# Output: JSON snapshot of Core Web Vitals via Lighthouse + basic checks

set -euo pipefail

URL="${1:-}"
if [ -z "$URL" ]; then
  echo "Usage: $0 <URL>"
  echo "Example: $0 https://example.com"
  exit 1
fi

echo "🔍 Audit Architect — Quick Site Validation"
echo "============================================"
echo "URL: $URL"
echo ""

# 1. Basic HTTP check
echo "📡 HTTP Status..."
HTTP_CODE=$(curl -sI -o /dev/null -w "%{http_code}" --max-time 10 "$URL" 2>/dev/null || echo "000")
if [ "$HTTP_CODE" = "200" ]; then
  echo "   ✅ HTTP $HTTP_CODE"
elif [ "$HTTP_CODE" = "301" ] || [ "$HTTP_CODE" = "302" ]; then
  REDIRECT=$(curl -sI --max-time 10 "$URL" 2>/dev/null | grep -i "location:" | sed 's/.*location: //i' | tr -d '\r')
  echo "   ⚠️  HTTP $HTTP_CODE → $REDIRECT"
else
  echo "   🔴 HTTP $HTTP_CODE"
fi

# 2. SSL check
echo "🔒 SSL Certificate..."
SSL_EXPIRY=$(echo | openssl s_client -servername "$(echo "$URL" | sed 's|https://||;s|/.*||')" -connect "$(echo "$URL" | sed 's|https://||;s|/.*||'):443" 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null | sed 's/notAfter=//')
if [ -n "$SSL_EXPIRY" ]; then
  echo "   ✅ Expires: $SSL_EXPIRY"
else
  echo "   🔴 Could not check SSL"
fi

# 3. Response size
echo "📦 Page Size..."
SIZE_BYTES=$(curl -s --max-time 10 "$URL" 2>/dev/null | wc -c)
SIZE_KB=$((SIZE_BYTES / 1024))
if [ "$SIZE_KB" -lt 500 ]; then
  echo "   ✅ ${SIZE_KB}KB (small)"
elif [ "$SIZE_KB" -lt 2000 ]; then
  echo "   🟡 ${SIZE_KB}KB (medium)"
else
  echo "   🔴 ${SIZE_KB}KB (large — consider compressing)"
fi

# 4. Meta tags check
echo "🏷️  Meta Tags..."
HTML=$(curl -s --max-time 10 "$URL" 2>/dev/null)
TITLE=$(echo "$HTML" | grep -oP '<title[^>]*>\K[^<]+' | head -1)
DESC=$(echo "$HTML" | grep -oP '<meta[^>]*name="description"[^>]*content="\K[^"]+' | head -1)
VIEWPORT=$(echo "$HTML" | grep -oP '<meta[^>]*name="viewport"[^>]*>' | head -1)
CANONICAL=$(echo "$HTML" | grep -oP '<link[^>]*rel="canonical"[^>]*href="\K[^"]+' | head -1)
SCHEMA=$(echo "$HTML" | grep -oP '<script[^>]*type="application/ld\+json"[^>]*>' | head -1)

[ -n "$TITLE" ] && echo "   ✅ Title: ${TITLE:0:80}" || echo "   🔴 Missing <title>"
[ -n "$DESC" ] && echo "   ✅ Description: ${DESC:0:80}" || echo "   🟠 Missing meta description"
[ -n "$VIEWPORT" ] && echo "   ✅ Viewport present" || echo "   🔴 Missing viewport (not mobile-friendly)"
[ -n "$CANONICAL" ] && echo "   ✅ Canonical: $CANONICAL" || echo "   🟡 No canonical tag"
[ -n "$SCHEMA" ] && echo "   ✅ Schema markup found" || echo "   🟡 No JSON-LD schema markup"

# 5. Security headers
echo "🛡️  Security Headers..."
HEADERS=$(curl -sI --max-time 10 "$URL" 2>/dev/null)
HSTS=$(echo "$HEADERS" | grep -i "strict-transport-security" || echo "")
CSP=$(echo "$HEADERS" | grep -i "content-security-policy" || echo "")
XFRAME=$(echo "$HEADERS" | grep -i "x-frame-options" || echo "")

[ -n "$HSTS" ] && echo "   ✅ HSTS enabled" || echo "   🟠 HSTS missing"
[ -n "$CSP" ] && echo "   ✅ CSP configured" || echo "   🟡 CSP missing"
[ -n "$XFRAME" ] && echo "   ✅ X-Frame-Options set" || echo "   🟡 X-Frame-Options missing"

# 6. robots.txt & sitemap
echo "🤖 robots.txt / sitemap..."
BASE_URL=$(echo "$URL" | sed 's|/.*||')

ROBOTS=$(curl -s --max-time 5 "${BASE_URL}/robots.txt" 2>/dev/null || echo "")
if [ -n "$ROBOTS" ]; then
  echo "   ✅ robots.txt found"
  SITEMAP=$(echo "$ROBOTS" | grep -i "sitemap:" | sed 's/.*: //i' | tr -d '\r')
  [ -n "$SITEMAP" ] && echo "   ✅ Sitemap: $SITEMAP" || echo "   🟡 No sitemap in robots.txt"
else
  echo "   🟠 No robots.txt found"
fi

# 7. Lighthouse audit (if npx available)
echo ""
echo "📊 Lighthouse Audit..."
if command -v npx &>/dev/null; then
  echo "   Running Lighthouse (this may take 30s)..."
  LIGHTHOUSE_OUTPUT=$(npx lighthouse "$URL" \
    --output json \
    --chrome-flags="--headless --no-sandbox --disable-gpu" \
    --only-categories=performance \
    --quiet \
    2>/dev/null || echo "")

  if [ -n "$LIGHTHOUSE_OUTPUT" ]; then
    PERF_SCORE=$(echo "$LIGHTHOUSE_OUTPUT" | python3 -c "
import json, sys
try:
    d = json.load(sys.stdin)
    score = d.get('categories',{}).get('performance',{}).get('score',0)
    print(int(score * 100))
except: print('N/A')
" 2>/dev/null || echo "N/A")

    LCP=$(echo "$LIGHTHOUSE_OUTPUT" | python3 -c "
import json, sys
try:
    d = json.load(sys.stdin)
    lcp = d.get('audits',{}).get('largest-contentful-paint',{}).get('displayValue','N/A')
    print(lcp)
except: print('N/A')
" 2>/dev/null || echo "N/A")

    echo "   Performance Score: ${PERF_SCORE}/100"
    echo "   LCP (Largest Contentful Paint): $LCP"

    if [ "$PERF_SCORE" != "N/A" ]; then
      if [ "$PERF_SCORE" -ge 90 ]; then
        echo "   ✅ Performance: Excellent"
      elif [ "$PERF_SCORE" -ge 50 ]; then
        echo "   🟡 Performance: Needs improvement"
      else
        echo "   🔴 Performance: Critical — fix before spending on ads"
      fi
    fi
  else
    echo "   ⚠️  Lighthouse failed to run. Try manually: npx lighthouse $URL"
  fi
else
  echo "   ⚠️  npx not available. Install Node.js for Lighthouse audit."
fi

echo ""
echo "============================================"
echo "✅ Quick audit complete"
