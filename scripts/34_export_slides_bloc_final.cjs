// Contrôler et exporter les supports des modules 08 à 10 et des laboratoires 03 et 04.
// Depuis la racine : node scripts/34_export_slides_bloc_final.cjs [dossier-de-controle]
// Dépendances : Playwright, Google Chrome, zip. Aucun envoi ni publication.
const fs=require('node:fs'),path=require('node:path');
const {pathToFileURL}=require('node:url');
const {execFileSync}=require('node:child_process');
const {chromium}=require(process.env.MQT_PLAYWRIGHT_MODULE||'playwright');
const root=process.cwd(),out=path.resolve(process.argv[2]||'output/controle-diapos-bloc-final');
const scopes=['semaine-08-tendance-saisonnalite','semaine-09-variables-externes-autocorrelation','semaine-10-classification-modeles-avances','atelier-03-series-chronologiques','atelier-04-recapitulation'];
fs.mkdirSync(out,{recursive:true});
async function ready(page){await page.waitForFunction(()=>window.Reveal?.isReady());await page.evaluate(async()=>{await document.fonts.ready;if(window.MathJax?.startup?.promise)await MathJax.startup.promise;await Promise.all([...document.images].filter(i=>i.complete&&i.getAttribute('src')).map(i=>i.decode()));});}
function inspect(){
 const slide=Reveal.getCurrentSlide(),frame=document.querySelector('.slides').getBoundingClientRect();
 const overflow=[...slide.querySelectorAll('h1,h2,h3,p,li,table,pre,img,.value,.label,mjx-container')].filter(e=>{
  if(e.closest('aside.notes,mjx-assistive-mml'))return false;
  const b=e.getBoundingClientRect();return b.width&&b.height&&(b.right>frame.right+4||b.bottom>frame.bottom+4||b.left<frame.left-4);
 }).map(e=>e.textContent.trim().slice(0,100));
 const grids=[...slide.querySelectorAll('.metric-grid')].map(g=>{
  const boxes=[...g.querySelectorAll(':scope > .metric')].map(c=>c.getBoundingClientRect());
  return {cards:boxes.length,columns:boxes.length===3&&boxes.every(b=>Math.abs(b.top-boxes[0].top)<2)&&boxes[0].right<=boxes[1].left+1&&boxes[1].right<=boxes[2].left+1};
 });
 const cardOverflow=[...slide.querySelectorAll('.metric .value,.metric .label')].filter(e=>{const r=document.createRange();r.selectNodeContents(e);const b=e.closest('.metric').getBoundingClientRect();return [...r.getClientRects()].some(t=>t.right>b.right+3||t.left<b.left-3);}).map(e=>e.textContent.trim());
 const h=slide.querySelector('h1,h2');return {title:h?.textContent.trim(),text:slide.innerText,grids,overflow,cardOverflow,mathErrors:slide.querySelectorAll('mjx-merror,.katex-error').length,brokenImages:[...slide.querySelectorAll('img')].filter(i=>!i.complete||!i.naturalWidth).length};
}
async function main(){const browser=await chromium.launch({channel:'chrome',headless:true});const reports=[],refs=[];
try{const page=await browser.newPage({viewport:{width:1600,height:900}});let errors=[];page.on('pageerror',e=>errors.push(String(e)));
 // Comparer les propriétés effectivement rendues avec les références actuelles.
 for(const file of ['modules/semaine-04-regression-nonlineaire/media/qmd/capsule-01-support.html','modules/semaine-06-series-chronologiques-intro/media/qmd/capsule-03-support.html']){
  await page.goto(pathToFileURL(path.resolve('docs',file)).href);await ready(page);refs.push({file,...await page.evaluate(()=>({font:getComputedStyle(document.querySelector('.reveal')).fontFamily,size:getComputedStyle(document.querySelector('.reveal')).fontSize,heading:getComputedStyle(document.querySelector('h2')).fontFamily,colour:getComputedStyle(document.querySelector('h2')).color}))});
 }
 for(const scope of scopes){const modulePath=path.join('modules',scope),target=path.join(out,scope);fs.mkdirSync(path.join(target,'html'),{recursive:true});fs.mkdirSync(path.join(target,'pdf'),{recursive:true});
  const decks=scope.startsWith('semaine-')?[1,2,3,4,5].map(i=>'media/qmd/capsule-0'+i+'-support').concat('notes-cours'):['presentation'];
  for(const deck of decks){const source=path.resolve(modulePath,deck+'.qmd'),html=path.resolve('docs',modulePath,deck+'.html'),url=pathToFileURL(html).href,name=path.basename(deck);if(fs.statSync(source).mtimeMs>fs.statSync(html).mtimeMs)throw Error('Source plus récente que le HTML : '+source);
   errors=[];await page.emulateMedia({media:'screen'});await page.goto(url);await ready(page);await page.addStyleTag({content:'.reveal .slides section { transition:none !important; }'});
   const style=await page.evaluate(()=>({font:getComputedStyle(document.querySelector('.reveal')).fontFamily,size:getComputedStyle(document.querySelector('.reveal')).fontSize,heading:getComputedStyle(document.querySelector('h2')).fontFamily,colour:getComputedStyle(document.querySelector('h2')).color}));
   for(const k of ['font','size','heading','colour'])if(style[k]!==refs[0][k]||style[k]!==refs[1][k])throw Error('Écart de thème '+scope+' '+k);
   const count=await page.evaluate(()=>Reveal.getTotalSlides()),slides=[];
   for(let i=0;i<count;i++){
    await page.evaluate(i=>Reveal.slide(i),i);await page.evaluate(async()=>{await Promise.all([...Reveal.getCurrentSlide().querySelectorAll('img')].map(i=>i.decode()));await document.fonts.ready;await new Promise(r=>requestAnimationFrame(()=>requestAnimationFrame(r)));});
    const state=await page.evaluate(inspect);slides.push(state);
    if(state.overflow.length||state.cardOverflow.length||state.mathErrors||state.brokenImages||state.grids.some(g=>!g.columns))throw Error(JSON.stringify({scope,deck,slide:i+1,...state}));
    await page.screenshot({path:path.join(target,'html',name+'-'+String(i+1).padStart(2,'0')+'.png')});
   }
   if(errors.length)throw Error(JSON.stringify(errors));
   await page.goto(url+'?print-pdf');await ready(page);await page.emulateMedia({media:'print'});await page.waitForFunction(n=>document.querySelectorAll('.pdf-page').length===n,count);await page.evaluate(async()=>{await Promise.all([...document.querySelectorAll('.pdf-page img')].map(i=>i.decode()));await document.fonts.ready;await new Promise(r=>requestAnimationFrame(()=>requestAnimationFrame(r)));});
   const printGrids=await page.locator('.pdf-page .metric-grid').evaluateAll(gs=>gs.map(g=>{const b=[...g.children].map(c=>c.getBoundingClientRect());return b.length===3&&b.every(x=>Math.abs(x.top-b[0].top)<2)&&b[0].right<=b[1].left+1&&b[1].right<=b[2].left+1;}));
   if(!printGrids.every(Boolean))throw Error('Cartes empilées dans le PDF : '+scope+' '+deck);
   await page.pdf({path:path.join(target,'pdf',name+'.pdf'),preferCSSPageSize:true,printBackground:true});reports.push({scope,deck,count,style,slides,printGrids});console.log(scope+' / '+name+' : '+count+' diapositives, '+printGrids.length+' grilles vérifiées.');
  }
 }
 // Installer seulement une fois les vingt supports contrôlés.
 for(const r of reports){const name=path.basename(r.deck)+'.pdf';for(const base of [root,path.join(root,'docs')]){const folder=path.join(base,'modules',r.scope,'media/pdf');fs.mkdirSync(folder,{recursive:true});fs.copyFileSync(path.join(out,r.scope,'pdf',name),path.join(folder,name));}}
 for(const scope of scopes.filter(s=>s.startsWith('semaine-'))){const text=fs.readFileSync(path.join('modules',scope,'capsules.qmd'),'utf8');const name=text.match(/telechargements\/(module-\d{2}-pdf-\d{4}-\d{2}-\d{2}-revu\.zip)/)?.[1];if(!name)throw Error('Lot révisé absent : '+scope);const archive=path.join(out,scope,name);fs.rmSync(archive,{force:true});const pdfs=reports.filter(r=>r.scope===scope).map(r=>path.join(out,scope,'pdf',path.basename(r.deck)+'.pdf'));execFileSync('zip',['-q','-j',archive,...pdfs]);for(const base of [root,path.join(root,'docs')])fs.copyFileSync(archive,path.join(base,'modules',scope,'telechargements',name));}
 fs.writeFileSync(path.join(out,'verification-diaporamas.json'),JSON.stringify({references:refs,supports:reports},null,2));
}finally{await browser.close();}}
main().catch(e=>{console.error(e);process.exitCode=1;});
