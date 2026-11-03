// Exporter les six supports des modules 07 ou 08 depuis leurs HTML déjà rendus.
// Dépendances : Node.js, Playwright et Google Chrome.
// Depuis la racine : node scripts/33_export_module07_pdfs.cjs [dossier-de-controle] [modules/nom-du-module]
// Si Playwright est ailleurs, renseigner NODE_PATH ou MQT_PLAYWRIGHT_MODULE.
const fs = require('node:fs');
const path = require('node:path');
const { pathToFileURL } = require('node:url');
const { execFileSync } = require('node:child_process');
const { chromium } = require(process.env.MQT_PLAYWRIGHT_MODULE || 'playwright');

const root = process.cwd();
const modulePath = process.argv[3] || 'modules/semaine-07-lissage';
if (!/^modules\/semaine-0[78]-[a-z-]+$/.test(modulePath)) throw new Error('Choisir le module 07 ou 08.');
const reportPath = path.resolve(process.argv[2] || 'output/controle-pdf-module07');
const decks = [1, 2, 3, 4, 5].map(i => `capsule-0${i}-support`).concat('notes-cours');
fs.mkdirSync(path.join(reportPath, 'diapositives'), { recursive: true });
fs.mkdirSync(path.join(reportPath, 'pdf'), { recursive: true });

async function ready(page) {
  await page.waitForFunction(() => window.Reveal?.isReady());
  await page.evaluate(async () => {
    await document.fonts.ready;
    if (window.MathJax?.startup?.promise) await MathJax.startup.promise;
  });
}

// Mesurer les cartes réellement dessinées, plutôt que la seule présence du CSS.
function inspectSlide() {
  const slide = Reveal.getCurrentSlide();
  const bounds = document.querySelector('.slides').getBoundingClientRect();
  const grids = [...slide.querySelectorAll('.metric-grid')].map(grid => {
    const cards = [...grid.querySelectorAll(':scope > .metric')];
    const boxes = cards.map(card => card.getBoundingClientRect());
    return {
      cards: cards.length,
      columns: boxes.length === 3 && boxes.every(box => Math.abs(box.top - boxes[0].top) < 2)
        && boxes[0].right <= boxes[1].left && boxes[1].right <= boxes[2].left,
      labels: cards.map(card => card.querySelector('.value')?.textContent.trim())
    };
  });
  const overflow = [...slide.children].filter(element => {
    const box = element.getBoundingClientRect();
    return !element.matches('aside.notes') && box.width && box.height
      && (box.right > bounds.right + 3 || box.bottom > bounds.bottom + 3 || box.left < bounds.left - 3);
  }).map(element => element.textContent.trim().slice(0, 100));
  return {
    title: slide.querySelector('h1,h2')?.textContent.trim(), grids, overflow,
    mathErrors: slide.querySelectorAll('mjx-merror,.katex-error').length,
    brokenImages: [...slide.querySelectorAll('img')].filter(img => !img.complete || !img.naturalWidth).length,
    images: slide.querySelectorAll('img').length,
    tables: slide.querySelectorAll('table').length
  };
}

async function main() {
  const browser = await chromium.launch({ channel: 'chrome', headless: true });
  const reports = [];
  try {
    const page = await browser.newPage({ viewport: { width: 1600, height: 900 } });
    for (const deck of decks) {
      const html = path.resolve('docs', modulePath, deck === 'notes-cours' ? `${deck}.html` : `media/qmd/${deck}.html`);
      const source = path.resolve(modulePath, deck === 'notes-cours' ? `${deck}.qmd` : `media/qmd/${deck}.qmd`);
      if (fs.statSync(source).mtimeMs > fs.statSync(html).mtimeMs) {
        throw new Error(`Rendre la source modifiée avant l’export : ${source}`);
      }
      const url = pathToFileURL(html).href;
      await page.emulateMedia({ media: 'screen' });
      await page.goto(url);
      await ready(page);
      await page.addStyleTag({ content: '.reveal .slides section { transition: none !important; }' });
      const count = await page.evaluate(() => Reveal.getTotalSlides());
      const slides = [];
      for (let i = 0; i < count; i++) {
        await page.evaluate(i => Reveal.slide(i), i);
        await page.evaluate(async () => {
          await Promise.all([...Reveal.getCurrentSlide().querySelectorAll('img')].map(img => img.decode()));
          await new Promise(resolve => requestAnimationFrame(() => requestAnimationFrame(resolve)));
          // Certains glyphes mathématiques ne chargent leur police qu’à l’affichage.
          await document.fonts.ready;
          await new Promise(resolve => requestAnimationFrame(resolve));
        });
        const state = await page.evaluate(inspectSlide);
        if (state.grids.some(grid => !grid.columns) || state.overflow.length || state.mathErrors || state.brokenImages) {
          throw new Error(`Diapositive à corriger : ${deck} ${i + 1} ${JSON.stringify(state)}`);
        }
        await page.screenshot({ path: path.join(reportPath, 'diapositives', `${deck}-${String(i + 1).padStart(2, '0')}.png`) });
        slides.push(state);
      }
      await page.goto(`${url}?print-pdf`);
      await ready(page);
      await page.emulateMedia({ media: 'print' });
      // Reveal reconstruit le DOM pour l’impression après son premier événement ready.
      // Attendre les sections finales, les polices, les équations et les images.
      await page.waitForFunction(count => document.querySelectorAll('.pdf-page').length === count
        && document.querySelectorAll('.pdf-page .metric-grid').length > 0, count);
      await page.evaluate(async () => {
        await document.fonts.ready;
        await Promise.all([...document.querySelectorAll('.pdf-page img')].map(img => img.decode()));
        await new Promise(resolve => requestAnimationFrame(() => requestAnimationFrame(resolve)));
      });
      const printGrids = await page.locator('.pdf-page .metric-grid').evaluateAll(grids => grids.map(grid => {
        const boxes = [...grid.children].map(card => card.getBoundingClientRect());
        return boxes.length === 3 && boxes.every(box => Math.abs(box.top - boxes[0].top) < 2)
          && boxes[0].right <= boxes[1].left && boxes[1].right <= boxes[2].left;
      }));
      if (!printGrids.every(Boolean)) throw new Error(`Cartes empilées à l’impression : ${deck}`);
      const pdf = path.join(reportPath, 'pdf', `${deck}.pdf`);
      await page.pdf({ path: pdf, preferCSSPageSize: true, printBackground: true });
      reports.push({ deck, count, slides, printGrids });
      console.log(`${deck} : ${count} diapositives, ${printGrids.length} grilles en colonnes vérifiées.`);
    }
    // Le lot annoncé par les pages doit contenir exactement les mêmes PDF.
    const capsulePage = fs.readFileSync(path.join(modulePath, 'capsules.qmd'), 'utf8');
    const archiveName = capsulePage.match(/telechargements\/(module-0[78]-pdf-\d{4}-\d{2}-\d{2}\.zip)/)?.[1];
    if (!archiveName) throw new Error('Lot PDF courant absent de capsules.qmd.');
    const archive = path.join(reportPath, archiveName);
    fs.rmSync(archive, { force: true });
    execFileSync('zip', ['-q', '-j', archive, ...decks.map(deck => path.join(reportPath, 'pdf', `${deck}.pdf`))]);
    // Installer seulement après réussite de tous les contrôles des six supports.
    for (const deck of decks) {
      for (const base of [root, path.join(root, 'docs')]) {
        fs.copyFileSync(path.join(reportPath, 'pdf', `${deck}.pdf`), path.join(base, modulePath, 'media/pdf', `${deck}.pdf`));
      }
    }
    for (const base of [root, path.join(root, 'docs')]) {
      fs.copyFileSync(archive, path.join(base, modulePath, 'telechargements', archiveName));
    }
    fs.writeFileSync(path.join(reportPath, 'verification-diaporamas.json'), JSON.stringify(reports, null, 2));
  } finally {
    await browser.close();
  }
}
main().catch(error => { console.error(error); process.exitCode = 1; });
