// Pilote Playwright pour capturer l'app Flutter web tournant en local.
// Usage : node drive.js <url> <outPng> [clicksJson]
// clicksJson = JSON: [{"x":..,"y":..,"wait":ms,"shot":"file.png"} ...]
const { chromium } = require('playwright');

(async () => {
  const url = process.argv[2] || 'http://localhost:8099/';
  const out = process.argv[3] || 'shot.png';
  const steps = process.argv[4] ? JSON.parse(process.argv[4]) : [];

  const browser = await chromium.launch({
    headless: true,
    args: ['--no-sandbox', '--disable-dev-shm-usage'],
  });
  const page = await browser.newPage({
    viewport: { width: 1100, height: 1500 },
    deviceScaleFactor: 2,
  });
  const errors = [];
  page.on('pageerror', (e) => errors.push('PAGEERROR: ' + e.message));
  page.on('console', (m) => {
    if (m.type() === 'error') errors.push('CONSOLE: ' + m.text());
  });
  // détecte le premier frame Flutter
  await page.addInitScript(() => {
    window.addEventListener('flutter-first-frame', () => (window.__ff = true));
  });

  await page.goto(url, { waitUntil: 'load', timeout: 60000 });
  await page
    .waitForFunction(() => window.__ff === true, { timeout: 45000 })
    .catch(() => console.log('(pas de flutter-first-frame détecté, on continue)'));
  await page.waitForTimeout(5000);
  await page.screenshot({ path: out });
  console.log('shot ->', out);

  // séquence d'interactions optionnelle
  for (const s of steps) {
    if (s.x != null && s.y != null) {
      await page.mouse.click(s.x, s.y);
    }
    await page.waitForTimeout(s.wait || 1500);
    if (s.shot) {
      await page.screenshot({ path: s.shot });
      console.log('shot ->', s.shot);
    }
  }

  if (errors.length) {
    console.log('--- erreurs page (' + errors.length + ') ---');
    console.log([...new Set(errors)].slice(0, 15).join('\n'));
  } else {
    console.log('--- aucune erreur page ---');
  }
  await browser.close();
})();
