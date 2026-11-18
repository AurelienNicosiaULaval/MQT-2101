from pathlib import Path
from zipfile import ZipFile, ZIP_DEFLATED
import os, shutil, json, re, subprocess

module = Path("modules/semaine-09-variables-externes-autocorrelation")
docs = Path("docs")
destination = docs / module
def run(*args):
    subprocess.run(args, check=True)
searchfile = docs / "search.json"
sitemap = docs / "sitemap.xml"
old_search = json.loads(searchfile.read_text())
old_sitemap = sitemap.read_text()
synthesis = (module / "media/pdf/notes-cours.pdf").read_bytes()
run("quarto", "render", str(module / "media/qmd"))
(destination / "notes-cours.html").touch()
run("node", "-e", "require('./scripts/35_export_supports_coherents.cjs').exportSupports({selected:['" + module.name + "'],out:'/tmp/controle-capsules'}).catch(e=>{console.error(e);process.exitCode=1})")
for base in [module, destination]:
    (base / "media/pdf/notes-cours.pdf").write_bytes(synthesis)
lot = module / "telechargements/module-09-pdf-2026-11-18-tournage.zip"
with ZipFile(lot, "w", ZIP_DEFLATED) as archive:
    for pdf in sorted((module / "media/pdf").glob("*.pdf")):
        archive.write(pdf, pdf.name)
for name in [lot.name, "module-09-pdf-2026-11-18.zip"]:
    for base in [module, destination]:
        out = base / "telechargements" / name
        if out != lot:
            shutil.copyfile(lot, out)
run("quarto","render",str(module / "capsules.qmd"))
run("quarto","render",str(module / "index.qmd"))
targets = {str(module / f) for f in ["index.html","capsules.html",*[f"media/qmd/capsule-0{i}-support.html" for i in range(1,6)]]}
def wanted(x):
    return x["href"].split("#")[0] in targets
new = [x for x in json.loads(searchfile.read_text()) if wanted(x)]
assert {x["href"].split("#")[0] for x in new} == targets
assert any("Fabriquer les paires" in x["text"] for x in new)
merged = [x for x in old_search if not wanted(x)] + new
assert len({x["objectID"] for x in merged}) == len(merged)
searchfile.write_text(json.dumps(merged,ensure_ascii=False,indent=2)+"\n")
def update_time(match):
    block=match.group()
    if any("/"+href+"</loc>" in block for href in targets):
        return re.sub(r"<lastmod>[^<]+</lastmod>", "<lastmod>2026-11-18</lastmod>", block)
    return block
sitemap.write_text(re.sub(r"<url>[\s\S]*?</url>",update_time,old_sitemap))
# Seuls les fichiers distribués concernés entrent dans le résultat.
safe = [searchfile,sitemap,destination/"index.html",destination/"index.llms.md",destination/"capsules.html",destination/"capsules.llms.md"]
for i in range(1,6):
    name = f"capsule-0{i}-support"
    safe += [destination/f"media/qmd/{name}.html",module/f"media/pdf/{name}.pdf",destination/f"media/pdf/{name}.pdf"]
    result = subprocess.check_output(["pdfinfo",str(module/f"media/pdf/{name}.pdf")],text=True)
    assert int(re.search(r"Pages:\s+(\d+)",result)[1]) == [13,13,14,14,14][i-1]
for base in [module,destination]:
    safe += [base/"telechargements"/name for name in [lot.name,"module-09-pdf-2026-11-18.zip"]]
run("git","add","-f","--",*map(str,safe))
run("git","-c","user.name=github-actions[bot]","-c","user.email=41898282+github-actions[bot]@users.noreply.github.com","commit","-m","Produire et vérifier les supports enrichis du module 09")
run("git","push","origin","HEAD:refs/heads/verification/tournage-module09-20261118")
