// Exporter le PDF depuis la géométrie du diaporama à l’écran.
// Le texte et les figures restent vectoriels; aucune capture n’est convertie en PDF.
// Usage : node scripts/35_export_supports_coherents.cjs [dossier-de-controle]
// Dépendances : Playwright, Chrome, zip et pdfinfo (Poppler).
// MQT_PLAYWRIGHT_MODULE permet de préciser l’emplacement de Playwright.
const fs = require('node:fs');
const path = require('node:path');
const { pathToFileURL } = require('node:url');
const { execFileSync } = require('node:child_process');
const { chromium } = require(process.env.MQT_PLAYWRIGHT_MODULE || 'playwright');

const scopes = [
  'semaine-07-lissage', 'semaine-08-tendance-saisonnalite',
  'semaine-09-variables-externes-autocorrelation', 'semaine-10-classification-modeles-avances',
  'atelier-03-series-chronologiques', 'atelier-04-recapitulation'
];
const selectors = 'h1,h2,h3,p,li,table,pre,img,.value,.label,mjx-container';

async function ready(page) {
  await page.waitForFunction(() => window.Reveal?.isReady());
  await page.evaluate(async () => {
    await document.fonts.ready;
    if (window.MathJax?.startup?.promise) await MathJax.startup.promise;
    if (window.MathJax?.Hub?.Queue) await new Promise(resolve => MathJax.Hub.Queue(resolve));
    await document.fonts.ready;
  });
}

async function show(page, index) {
  await page.evaluate(index => Reveal.slide(index), index);
  await page.evaluate(async () => {
    if (window.MathJax?.Hub?.Queue) await new Promise(resolve => MathJax.Hub.Queue(resolve));
    await Promise.all([...Reveal.getCurrentSlide().querySelectorAll('img')].map(i => i.decode()));
    await document.fonts.ready;
    await new Promise(r => requestAnimationFrame(() => requestAnimationFrame(r)));
  });
}

// Les coordonnées sont normalisées par rapport à la page, et non au canevas logique.
async function snapshot(page) {
  return page.evaluate(selectors => {
    const section = Reveal.getCurrentSlide(), css = getComputedStyle(section);
    const rect = element => {
      const b = element.getBoundingClientRect();
      return { x: b.x, y: b.y, width: b.width, height: b.height };
    };
    const widget = element => {
      if (!element) return null;
      const c = getComputedStyle(element);
      return { ...rect(element), text: element.textContent.trim(), source: element.getAttribute('src'),
        font: c.font, fontFamily: c.fontFamily, fontSize: c.fontSize, lineHeight: c.lineHeight,
        padding: c.padding, color: c.color, background: c.background };
    };
    const s = rect(section), pseudo = getComputedStyle(section, '::before');
    const elements = [...section.querySelectorAll(selectors)]
      .filter(e => !e.closest('aside.notes,mjx-assistive-mml'))
      .map(e => ({ text: e.textContent.trim(), tag: e.tagName, ...rect(e) }));
    const overflow = elements.filter(e => e.width && e.height &&
      (e.x < s.x - 3 || e.x + e.width > s.x + s.width + 3 || e.y + e.height > s.y + s.height + 3))
      .map(e => e.text.slice(0, 80));
    const cardOverflow = [...section.querySelectorAll('.metric .value,.metric .label')].filter(e => {
      const r = document.createRange(); r.selectNodeContents(e); const box = e.closest('.metric').getBoundingClientRect();
      return [...r.getClientRects()].some(b => b.left < box.left - 3 || b.right > box.right + 3);
    }).map(e => e.textContent.trim());
    const grids = [...section.querySelectorAll('.metric-grid')].map(g => {
      const b = [...g.querySelectorAll(':scope>.metric')].map(rect);
      return { cards: b.length, columns: b.length === 3 && b.every(r => Math.abs(r.y - b[0].y) < 1)
        && b[0].x + b[0].width <= b[1].x + 1 && b[1].x + b[1].width <= b[2].x + 1 };
    });
    return { title: section.querySelector('h1,h2')?.textContent.trim(), text: section.innerText,
      section: s, scale: s.width / Reveal.getConfig().width, padding: css.padding, boxSizing: css.boxSizing,
      elements, grids, overflow, cardOverflow, logo: widget(document.querySelector('.slide-logo')),
      number: widget(document.querySelector('.slide-number')),
      brand: { visible: pseudo.display !== 'none' && pseudo.content !== 'none', height: parseFloat(pseudo.height),
        borderTop: parseFloat(pseudo.borderTopWidth), borderBottom: parseFloat(pseudo.borderBottomWidth),
        borderTopColor: pseudo.borderTopColor, background: pseudo.background },
      mathErrors: section.querySelectorAll('mjx-merror,.katex-error').length,
      brokenImages: [...section.querySelectorAll('img')].filter(i => !i.complete || !i.naturalWidth).length };
  }, selectors);
}

function compareGeometry(expected, actual, multiplier = 1) {
  if (expected.elements.length !== actual.elements.length) return ['Nombre d’éléments différent'];
  const errors = [];
  expected.elements.forEach((e, i) => {
    const a = actual.elements[i];
    if (e.text !== a.text || e.tag !== a.tag) errors.push('Texte ou élément différent : ' + e.text.slice(0, 60));
    for (const key of ['x', 'y', 'width', 'height']) {
      if (Math.abs(e[key] - a[key] * multiplier) > 1.5) errors.push(key + ' : ' + e.text.slice(0, 60));
    }
  });
  return errors;
}

async function printLikeScreen(page, url, screens, width, height, pdf) {
  await page.setViewportSize({ width, height });
  await page.emulateMedia({ media: 'screen' });
  await show(page, 0);
  // Conserver les mêmes nœuds, polices et formules que ceux contrôlés à l’écran.
  // RevealJS ne reconstruit pas une seconde mise en page d’impression.
  await page.evaluate(() => {
    const slides = document.querySelector('.slides');
    for (const section of [...slides.querySelectorAll(':scope > section')]) {
      const page = document.createElement('div'); page.className = 'mqt-pdf-page';
      section.before(page); page.appendChild(section);
    }
    document.documentElement.classList.add('mqt-pdf-export');
  });
  await page.addStyleTag({ content: `
    @page { size: ${width}px ${height}px; margin: 0; }
    body > :not(.reveal), .reveal > :not(.slides) { display: none !important; }
    html.mqt-pdf-export, html.mqt-pdf-export body { width: ${width}px !important; height: auto !important;
      margin: 0 !important; padding: 0 !important; overflow: visible !important; }
    .mqt-pdf-export .reveal, .mqt-pdf-export .reveal .slides { width: ${width}px !important; height: auto !important;
      margin: 0 !important; padding: 0 !important; position: static !important; transform: none !important; overflow: visible !important; }
    .mqt-pdf-page { width: ${width}px !important; height: ${height}px !important; position: relative !important;
      margin: 0 !important; padding: 0 !important; overflow: hidden !important; break-after: page !important; }
    .mqt-pdf-page:last-child { break-after: auto !important; page-break-after: auto !important; }
    .mqt-pdf-export section::before { display: none !important; }
  ` });
  await page.evaluate(({ screens, width, height }) => {
    const set = (element, properties) => Object.entries(properties).forEach(([k, v]) => element.style.setProperty(k, v, 'important'));
    for (const [i, page] of [...document.querySelectorAll('.mqt-pdf-page')].entries()) {
      const s = page.querySelector('section'), x = screens[i];
      set(s, { width: width + 'px', height: height + 'px', 'min-height': height + 'px',
        left: x.section.x + 'px', top: x.section.y + 'px', padding: x.padding, 'box-sizing': x.boxSizing,
        position: 'absolute', transform: 'scale(' + x.scale + ')', 'transform-origin': '0 0',
        display: 'block', visibility: 'visible', opacity: '1' });
      if (x.brand.visible) {
        const bar = document.createElement('div'), h = (x.brand.height + x.brand.borderTop + x.brand.borderBottom) * x.scale;
        set(bar, { position: 'absolute', left: x.section.x + 'px', top: (x.section.y + x.section.height - h) + 'px',
          width: x.section.width + 'px', height: h + 'px', background: x.brand.background,
          'border-top': (x.brand.borderTop * x.scale) + 'px solid ' + x.brand.borderTopColor,
          'box-sizing': 'border-box', 'z-index': '5' });
        page.appendChild(bar);
      }
      if (x.logo) {
        const logo = document.createElement('img'); logo.src = x.logo.source; logo.alt = 'Université Laval, FSA';
        set(logo, { position: 'absolute', left: x.logo.x + 'px', top: x.logo.y + 'px', width: x.logo.width + 'px',
          height: x.logo.height + 'px', 'max-height': 'none', margin: '0', 'z-index': '1000' });
        page.appendChild(logo);
      }
      if (x.number) {
        const n = document.createElement('div'); n.textContent = x.number.text;
        set(n, { position: 'absolute', left: x.number.x + 'px', top: x.number.y + 'px', width: x.number.width + 'px',
          height: x.number.height + 'px', font: x.number.font, 'font-family': x.number.fontFamily,
          'font-size': x.number.fontSize, 'line-height': x.number.lineHeight, padding: x.number.padding,
          color: x.number.color, background: x.number.background, 'box-sizing': 'border-box' });
        page.appendChild(n);
      }
    }
  }, { screens, width, height });
  await page.evaluate(async () => {
    await document.fonts.ready;
    await Promise.all([...document.querySelectorAll('.mqt-pdf-page img')].map(i => i.decode()));
    await new Promise(r => requestAnimationFrame(() => requestAnimationFrame(r)));
  });
  const printed = await page.locator('.mqt-pdf-page').evaluateAll((pages, selectors) => pages.map(page => {
    const origin = page.getBoundingClientRect();
    return { elements: [...page.querySelector('section').querySelectorAll(selectors)]
      .filter(e => !e.closest('aside.notes,mjx-assistive-mml')).map(e => {
        const b = e.getBoundingClientRect();
        return { text: e.textContent.trim(), tag: e.tagName, x: b.x - origin.x, y: b.y - origin.y, width: b.width, height: b.height };
      }) };
  }), selectors);
  for (const [i, p] of printed.entries()) {
    const errors = compareGeometry(screens[i], p);
    if (errors.length) {
      fs.writeFileSync(pdf + '.geometrie.json', JSON.stringify({ page: i + 1, screen: screens[i], print: p }, null, 2));
      throw Error('Écart écran/PDF, page ' + (i + 1) + ' : ' + errors.slice(0, 8).join('; '));
    }
  }
  await page.pdf({ path: pdf, preferCSSPageSize: true, printBackground: true });
  const info = execFileSync('pdfinfo', [pdf], { encoding: 'utf8' });
  const pages = Number(info.match(/^Pages:\s+(\d+)/m)?.[1]);
  if (pages !== screens.length) throw Error('Nombre de pages PDF incorrect : ' + pdf + ' (' + pages + ')');
}

function createPdfArchives(reports, root, target, selected) {
  for (const scope of selected.filter(s => s.startsWith('semaine-'))) {
    const text = fs.readFileSync(path.join(root, 'modules', scope, 'capsules.qmd'), 'utf8');
    const name = text.match(/telechargements\/(module-\d{2}-pdf-\d{4}-\d{2}-\d{2}(?:-[a-z]+)?\.zip)/)?.[1];
    if (!name) throw Error('Lot PDF actif absent : ' + scope);
    const files = reports.filter(r => r.scope === scope).map(r => path.join(target, scope, 'pdf', path.basename(r.deck) + '.pdf'));
    // Distribuer seulement les annotations effectivement annoncées, sans réécrire leurs PDF.
    const annotated = [...new Set([...text.matchAll(/media\/pdf\/([a-z0-9-]+-annote\.pdf)/g)].map(m => m[1]))];
    for (const file of annotated) {
      const source = path.join(root, 'modules', scope, 'media/pdf', file);
      if (!fs.existsSync(source)) throw Error('PDF annoté absent : ' + source);
      files.push(source);
      fs.copyFileSync(source, path.join(root, 'docs/modules', scope, 'media/pdf', file));
    }
    const zip = path.join(target, name); fs.rmSync(zip, { force: true });
    execFileSync('zip', ['-q', '-j', zip, ...files]);
    for (const base of [root, path.join(root, 'docs')]) fs.copyFileSync(zip, path.join(base, 'modules', scope, 'telechargements', name));
  }
}

async function exportSupports({ selected = scopes, out = 'output/controle-html-pdf' } = {}) {
  const root = process.cwd(), reports = [], target = path.resolve(out);
  fs.mkdirSync(target, { recursive: true });
  const browser = await chromium.launch({ channel: 'chrome', headless: true });
  try {
    const page = await browser.newPage({ viewport: { width: 1600, height: 900 } });
    let pageErrors = []; page.on('pageerror', e => pageErrors.push(String(e)));
    for (const scope of selected) {
      const decks = scope.startsWith('semaine-') ? [1, 2, 3, 4, 5].map(i => 'media/qmd/capsule-0' + i + '-support').concat('notes-cours') : ['presentation'];
      const folder = path.join(target, scope);
      for (const sub of ['html', 'integre', 'pdf']) fs.mkdirSync(path.join(folder, sub), { recursive: true });
      for (const deck of decks) {
        const source = path.join(root, 'modules', scope, deck + '.qmd'), html = path.join(root, 'docs/modules', scope, deck + '.html');
        if (fs.statSync(source).mtimeMs > fs.statSync(html).mtimeMs) throw Error('Rendre la source avant export : ' + source);
        const url = pathToFileURL(html).href, name = path.basename(deck), screens = [];
        await page.setViewportSize({ width: 1600, height: 900 }); await page.emulateMedia({ media: 'screen' });
        pageErrors = []; await page.goto(url); await ready(page);
        await page.evaluate(() => Reveal.configure({ transition: 'none', backgroundTransition: 'none' }));
        await page.addStyleTag({ content: '.reveal section,.reveal .backgrounds div{transition:none!important}.reveal .controls,.reveal .progress,.slide-menu-button{display:none!important}' });
        const count = await page.evaluate(() => Reveal.getTotalSlides());
        for (let i = 0; i < count; i++) {
          await show(page, i); const state = await snapshot(page);
          if (state.mathErrors || state.brokenImages || state.grids.some(g => !g.columns) || state.overflow.length || state.cardOverflow.length) {
            throw Error('Diapositive incorrecte : ' + scope + '/' + name + '/' + (i + 1) + ' : ' + JSON.stringify({ overflow: state.overflow, cartes: state.cardOverflow }));
          }
          screens.push(state); await page.screenshot({ path: path.join(folder, 'html', name + '-' + String(i + 1).padStart(2, '0') + '.png') });
        }
        await page.setViewportSize({ width: 800, height: 450 });
        for (let i = 0; i < count; i++) {
          await show(page, i); const embedded = await snapshot(page), errors = compareGeometry(screens[i], embedded, 2);
          if (errors.length || embedded.grids.some(g => !g.columns)) throw Error('Écart dans le cadre intégré : ' + scope + '/' + name + '/' + (i + 1) + ' : ' + errors.slice(0, 8).join('; '));
          await page.screenshot({ path: path.join(folder, 'integre', name + '-' + String(i + 1).padStart(2, '0') + '.png') });
        }
        await printLikeScreen(page, url, screens, 1600, 900, path.join(folder, 'pdf', name + '.pdf'));
        if (pageErrors.length) throw Error(pageErrors.join('\n'));
        reports.push({ scope, deck, count, screens, geometryScreenPdf: true, geometryEmbedded: true });
        console.log(scope + '/' + name + ' : ' + count + ' diapositives concordantes, écran, cadre intégré et PDF.');
      }
    }
    // Installer les fichiers seulement une fois tous les supports contrôlés.
    for (const r of reports) for (const base of [root, path.join(root, 'docs')]) {
      fs.copyFileSync(path.join(target, r.scope, 'pdf', path.basename(r.deck) + '.pdf'), path.join(base, 'modules', r.scope, 'media/pdf', path.basename(r.deck) + '.pdf'));
    }
    createPdfArchives(reports, root, target, selected);
    fs.writeFileSync(path.join(target, 'verification-diaporamas.json'), JSON.stringify(reports, null, 2));
    return reports;
  } finally { await browser.close(); }
}

module.exports = { exportSupports, createPdfArchives };
if (require.main === module) exportSupports({ out: process.argv[2] }).catch(e => { console.error(e); process.exitCode = 1; });
