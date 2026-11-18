from concurrent.futures import ThreadPoolExecutor
from hashlib import sha256
from io import BytesIO
from pathlib import Path
from urllib.request import Request, urlopen
from zipfile import ZipFile
import time

module = "modules/semaine-09-variables-externes-autocorrelation/"
site = "https://aureliennicosiaulaval.github.io/MQT-2101/"
revision = "9867010db7cf92b9d091a21e60b51f053e5b3da2"
docs = Path("docs")
paths = sorted(p for p in (docs / module).rglob("*") if p.is_file() and not p.name.startswith("."))
def verify(path):
    url = site + path.relative_to(docs).as_posix() + "?revision=" + revision
    expected = path.read_bytes()
    for attempt in range(6):
        try:
            with urlopen(Request(url, headers={"User-Agent":"MQT-2101 course publication check"}), timeout=30) as response:
                received = response.read()
                assert response.status == 200
            assert received == expected, "Contenu différent de la version validée"
            if path.suffix == ".zip":
                with ZipFile(BytesIO(received)) as archive:
                    assert archive.testzip() is None
                    if path.name == "module-09-pdf-2026-11-18.zip":
                        pdfs = sorted((docs / module / "media/pdf").glob("*.pdf"))
                        assert sorted(archive.namelist()) == [p.name for p in pdfs]
                        for pdf in pdfs:
                            assert archive.read(pdf.name) == pdf.read_bytes()
            return f"{path.relative_to(docs)}  {sha256(received).hexdigest()}"
        except Exception:
            if attempt == 5:
                raise
            time.sleep(10)
with ThreadPoolExecutor(max_workers=5) as pool:
    for result in pool.map(verify, paths + [docs / "search.json", docs / "sitemap.xml"]):
        print(result, flush=True)
print(f"{len(paths)} ressources du module vérifiées sur le site public.")
