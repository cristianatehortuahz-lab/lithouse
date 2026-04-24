const fs = require('fs');
const puppeteer = require('puppeteer');
const lighthouse = require('lighthouse');
const chromeLauncher = require('chrome-launcher');

async function runLighthouse(url) {
  console.log(`Auditing ${url}...`);
  // Lanzar chrome ignorando errores de certificados si los hubiera
  const chrome = await chromeLauncher.launch({
    chromeFlags: ['--headless', '--ignore-certificate-errors', '--disable-web-security', '--no-sandbox']
  });

  const options = {
    logLevel: 'info',
    output: 'html',
    onlyCategories: ['performance'],
    port: chrome.port,
  };

  const { default: lighthouseModule } = await import('lighthouse');
  const runnerResult = await lighthouseModule(url, options);

  // Guardar HTML
  fs.writeFileSync('lighthouse_report.html', runnerResult.report);
  
  // Guardar metricas en JSON (simplificado)
  const score = runnerResult.lhr.categories.performance.score * 100;
  console.log('Report is done for', runnerResult.lhr.finalDisplayedUrl);
  console.log('Performance score was', score);
  
  const results = {
      score: score,
      ttfb: runnerResult.lhr.audits['server-response-time'].displayValue,
      fcp: runnerResult.lhr.audits['first-contentful-paint'].displayValue,
      lcp: runnerResult.lhr.audits['largest-contentful-paint'].displayValue,
      tbt: runnerResult.lhr.audits['total-blocking-time'].displayValue,
      cls: runnerResult.lhr.audits['cumulative-layout-shift'].displayValue,
      clsElements: runnerResult.lhr.audits['layout-shift-elements']?.details?.items || [],
      lcpNode: runnerResult.lhr.audits['largest-contentful-paint-element']?.details?.items[0]?.node?.snippet || "None",
      mainThread: runnerResult.lhr.audits['mainthread-work-breakdown']?.details?.items.slice(0,3) || [],
      unusedJs: runnerResult.lhr.audits['unused-javascript']?.details?.items.map(i => i.url) || [],
      renderBlocking: runnerResult.lhr.audits['render-blocking-resources']?.details?.items.map(i => i.url) || []
  };
  fs.writeFileSync('lighthouse_summary.json', JSON.stringify(results, null, 2));

  await chrome.kill();
  return results;
}

runLighthouse('http://localhost:8080/people').catch(err => {
  console.error("Lighthouse run failed:", err);
});
