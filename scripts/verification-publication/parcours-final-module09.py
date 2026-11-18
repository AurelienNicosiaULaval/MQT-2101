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
# Ces deux pages R ont été exécutées dans des sessions neuves sur le poste du cours.
from hashlib import sha256
import base64,zlib
secours = Path("scripts/verification-publication/secours")
extra = []
for nom in ["demonstrations","exercices"]:
 f=dest/(nom+".html");before=f.read_bytes()
 delta=json.loads(zlib.decompress((secours/(nom+".delta")).read_bytes()))
 assert sha256(before).hexdigest()==delta["old"]
 content=b"".join(before[op[0]:op[0]+op[1]] if isinstance(op,list) else base64.b64decode(op) for op in delta["ops"])
 assert sha256(content).hexdigest()==delta["new"]
 f.write_bytes(content)
 shutil.copyfile(secours/(nom+".llms.md"),dest/(nom+".llms.md"))
 extra+=json.loads((secours/(nom+".json")).read_text())
for p in ["lectures","capsules","index"]:
 run("quarto","render",module/(p+".qmd"))
targets={str(module/(p+".html")) for p in pages}|{str(module/("media/qmd/"+n+".html")) for n in names}
fresh=[e for e in json.loads(search.read_text()) if e["href"].split("#")[0] in targets]
fresh=[e for e in fresh if e["href"].split("#")[0] not in {str(module/"demonstrations.html"),str(module/"exercices.html")}] + extra
assert {x["href"].split("#")[0] for x in fresh}==targets
records=[e for e in old if e["href"].split("#")[0] not in targets]+fresh
assert len({e["objectID"] for e in records})==len(records)
search.write_text(json.dumps(records,indent=2,ensure_ascii=False)+"\n")
def update(match):
 b=match[0]
 return re.sub(r'<lastmod>[^<]+</lastmod>','<lastmod>2026-11-18</lastmod>',b) if any('/'+x+'</loc>' in b for x in targets) else b
sitemap.write_text(re.sub(r'<url>[\s\S]*?</url>',update,oldmap))
class Links(HTMLParser):
 def __init__(self):super().__init__();self.ids=set();self.links=[]
 def handle_starttag(self,tag,attrs):
  d=dict(attrs)
  if 'id' in d:self.ids.add(d['id'])
  if tag=='a' and d.get('href'):self.links.append(d['href'])
seen={}
def parse(p):
 if p not in seen:
  h=Links();h.feed(p.read_text());seen[p]=h
 return seen[p]
for name in pages:
 p=(dest/(name+'.html')).resolve()
 for href in parse(p).links:
  u=urlsplit(href)
  if u.scheme or u.netloc or not u.path:continue
  target=(p.parent/unquote(u.path)).resolve()
  if not str(target).startswith(str(dest.resolve())+'/'):continue
  assert target.exists(),(name,href)
  if u.fragment and target.suffix=='.html':assert unquote(u.fragment) in parse(target).ids,(name,href)
assert not (dest/'solutions.html').exists()
for name in ['variables-ventes','variables-succursales','demonstration-variables','corrige-succursales','complements-variables']:
 with ZipFile(module/'telechargements'/(name+'.zip')) as z:assert z.testzip() is None
run('docker','run','--rm','-v',str(Path.cwd())+':/cours:ro','-w','/cours','rocker/r-ver:4.5.1','sh','-ec','Rscript scripts/12_validate_module_coherence.R && Rscript scripts/13_validate_data_assets.R && Rscript scripts/14_validate_site_output.R && Rscript scripts/25_validate_module06_format.R')
safe=[search,sitemap]
for name in pages:
 safe += [dest/(name+'.html')]
 ll=dest/(name+'.llms.md')
 if ll.exists():safe.append(ll)
for name in names:safe += [dest/('media/qmd/'+name+'.html')]
for b in [dest,module]:
 safe+=list((b/'media/pdf').glob('*.pdf'))
 safe += [b/'telechargements'/n for n in aliases]
for p in list((module/'R').glob('figures-parcours.R'))+list((module/'telechargements').glob('*.zip')):
 if not p.name.startswith('module-'):
  public=Path('docs')/p;shutil.copy2(p,public);safe.append(public)
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
run('git','push','origin','HEAD:refs/heads/verification/edition-module09-20261118')
