// Exporter les supports des modules 07 ou 08 avec la même mise en page que le HTML.
// Usage : node scripts/33_export_module07_pdfs.cjs [dossier-de-controle] [modules/nom-du-module]
const { exportSupports } = require('./35_export_supports_coherents.cjs');
const modulePath = process.argv[3] || 'modules/semaine-07-lissage';
if (!/^modules\/semaine-0[78]-[a-z-]+$/.test(modulePath)) throw Error('Choisir le module 07 ou 08.');
exportSupports({ selected: [modulePath.slice('modules/'.length)], out: process.argv[2] || 'output/controle-pdf-module07' })
  .catch(error => { console.error(error); process.exitCode = 1; });
