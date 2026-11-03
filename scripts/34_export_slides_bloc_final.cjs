// Exporter les modules 08 à 10 et les laboratoires 03 et 04 sans recomposer les diapositives.
// Usage : node scripts/34_export_slides_bloc_final.cjs [dossier-de-controle]
const { exportSupports } = require('./35_export_supports_coherents.cjs');
exportSupports({ selected: ['semaine-08-tendance-saisonnalite', 'semaine-09-variables-externes-autocorrelation',
  'semaine-10-classification-modeles-avances', 'atelier-03-series-chronologiques', 'atelier-04-recapitulation'],
  out: process.argv[2] || 'output/controle-diapos-bloc-final' })
  .catch(error => { console.error(error); process.exitCode = 1; });
