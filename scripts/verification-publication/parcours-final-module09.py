from pathlib import Path
from zipfile import ZipFile, ZIP_DEFLATED
from html.parser import HTMLParser
from urllib.parse import unquote, urlsplit
import shutil, subprocess, json, re
module=Path("modules/semaine-09-variables-externes-autocorrelation")
dest=Path("docs")/module
def run(*cmd):subprocess.run(list(map(str,cmd)),check=True)
pages=["index","capsules","exercices","lectures","demonstrations","notes-cours"]
search=Path("docs/search.json"); sitemap=Path("docs/sitemap.xml")
old=json.loads(search.read_text()); oldmap=sitemap.read_text()
run("quarto","render",module/"media/qmd")
run("quarto","render",module/"notes-cours.qmd")
run("node","-e","require('./scripts/35_export_supports_coherents.cjs').exportSupports({selected:['"+module.name+"'],out:'/tmp/mqt-diapos'}).catch(e=>{console.error(e);process.exitCode=1})")
names=[f"capsule-0{i}-support" for i in range(1,6)]
for f,n in zip(names+["notes-cours"],[13,13,14,14,14,34]):
 path=module/"media/pdf"/(f+".pdf")
 assert int(re.search(r"Pages:\s+(\d+)",subprocess.check_output(["pdfinfo",str(path)],text=True))[1])==n
lot=module/"telechargements/module-09-supports.zip"
with ZipFile(lot,"w",ZIP_DEFLATED) as z:
 for p in sorted((module/"media/pdf").glob("*.pdf")):z.write(p,p.name)
aliases=["module-09-supports.zip","module-09-pdf-2026-11-18.zip","module-09-pdf-2026-11-18-tournage.zip"]
for b in [module,dest]:
 for n in aliases:
  destination=b/"telechargements"/n
  if destination!=lot:shutil.copyfile(lot,destination)
safe=[]
# Les planches d'inspection relèvent de cette branche de vérification uniquement.
from PIL import Image,ImageOps,ImageDraw
tmp=Path('/tmp/mqt-planches');tmp.mkdir(exist_ok=True)
for nom in names+['notes-cours']:
 run('pdftoppm','-scale-to','520','-jpeg',module/('media/pdf/'+nom+'.pdf'),tmp/nom)
 imgs=sorted(tmp.glob(nom+'-*.jpg'))
 for pos in range(0,len(imgs),12):
  subset=imgs[pos:pos+12];out=Image.new('RGB',(3*420,((len(subset)+2)//3)*255),'#ddd')
  for j,page in enumerate(subset):
   pic=Image.open(page);pic.thumbnail((414,233))
   x=(j%3)*420;y=(j//3)*255;out.paste(pic,(x,y));ImageDraw.Draw(out).text((x+3,y+234),str(pos+j+1),fill='black')
  filename=Path('scripts/verification-publication/planches')/(nom+'-'+str(pos+1)+'.jpg');filename.parent.mkdir(exist_ok=True)
  out.save(filename,quality=79);safe.append(filename)
run('git','add','-f','--',*safe)
run('git','-c','user.name=github-actions[bot]','-c','user.email=41898282+github-actions[bot]@users.noreply.github.com','commit','-m','Rendre et contrôler le parcours complet du module 09')
run('git','push','origin','HEAD:refs/heads/verification/inspection-visuelle-module09-20261118')
