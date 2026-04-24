import glob
import os
import lxml.etree as ET
from acdh_tei_pyutils.tei import TeiReader
from collections import defaultdict
from tqdm import tqdm

files = glob.glob('./data/editions/*.xml')
indices = [
    './data/indices/listperson.xml',
    './data/indices/listwork.xml',
]

d = defaultdict(set)

# Schritt 1: Sammle Verweise aus den Editionsdateien
for x in tqdm(sorted(files), total=len(files)):
    doc = TeiReader(x)
    file_name = os.path.split(x)[1]
    html_base = os.path.splitext(file_name)[0] + ".html"
    title_nodes = (
        doc.any_xpath('.//tei:titleStmt/tei:title[@level="a"]/text()')
        or doc.any_xpath('.//tei:titleStmt/tei:title/text()')
    )
    doc_title = title_nodes[0] if title_nodes else file_name
    date_nodes = doc.any_xpath('.//tei:publicationStmt/tei:date/@when')
    doc_date = date_nodes[0] if date_nodes else ""
    for entity in doc.any_xpath('.//tei:body//*[starts-with(@xml:id, "pmb")]/@xml:id'):
        target = f"{html_base}#{entity}"
        d[entity].add(f"{target}_____{doc_title}_____{doc_date}")

# Schritt 2: Bearbeite die Indices
for x in indices:
    print(x)
    doc = TeiReader(x)

    for node in doc.any_xpath('.//tei:body//*[@xml:id]'):
        # Lösche vorhandene tei:note[@target and @corresp]
        for old_note in node.xpath('./tei:note[@target and @corresp]', namespaces={'tei': 'http://www.tei-c.org/ns/1.0'}):
            node.remove(old_note)

        # Füge neue tei:note-Elemente hinzu
        node_id = node.attrib['{http://www.w3.org/XML/1998/namespace}id']
        for mention in d.get(node_id, []):
            target, doc_title, doc_date = mention.split('_____')
            note = ET.Element('{http://www.tei-c.org/ns/1.0}note')
            note.attrib['target'] = target
            note.attrib['corresp'] = doc_date
            note.attrib['type'] = "mentions"
            note.text = doc_title
            node.append(note)

    doc.tree_to_file(x)

print("DONE")
