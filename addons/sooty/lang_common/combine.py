import yaml, json, csv
from pathlib import Path

def get_path(folder, name, lang, ext):
    Path(f"./{folder}/").mkdir(exist_ok=True)
    if lang:
        return Path(f"./{folder}/") / f"{name}.{lang}.{ext}"
    else:
        return Path(f"./{folder}/") / f"{name}.{ext}"

def save_json(data, name, lang):
    with open(get_path("json", name, lang, "json"), "w", encoding='utf8') as f:
        json.dump(data, f, ensure_ascii=False, indent=4)
    
def save_json_min(data, name, lang):
    with open(get_path("json_min", name, lang, "json"), "w", encoding='utf8') as f:
        json.dump(data, f, ensure_ascii=False, separators=(',', ':'))

def save_csv(data, name, lang):
    with open(get_path("csv", name, lang, "csv"), "w") as f:
        csvwriter = csv.writer(f)
        csvwriter.writerow(["keys", lang])
        for k in data:
            csvwriter.writerow([k, data[k]])

def save_tres(data, name, lang):
    keys = []
    for k in data:
        keys.append(k)
        keys.append(data[k])
    keys = '", "'.join(keys)
    tres = f'[gd_resource type="Translation" format=2]\n\n[resource]\n\nmessages = PoolStringArray( "{keys}" )\nlocale = "{lang}"\n'
    with open(get_path("tres", name, lang, "tres"), "w") as f:
        f.write(tres)

def save_all(data:dict, name:str, lang:str):
    save_json(data, name, lang)
    #save_json_min(data, name, lang)
    #save_csv(data, name, lang)
    #save_tres(data, name, lang)

def get_name_lang(name:str) -> str:
    if "." in name:
        return name.rsplit(".", 1)
    return name, ""

def build():
    full = {}
    
    for path in Path("./").rglob('*.yaml'):
        name, lang = get_name_lang(path.stem)
        print(lang, name)
        
        with open(path, "r") as f:
            data = yaml.safe_load(f)
        
        if lang:
            path = Path(f"./{name}.{lang}.yaml")
        else:
            path = Path(f"./{name}.yaml")
        
        #save_all(data, name, lang)
        
        # merge with full dict
        if lang:
            if not lang in full:
                full[lang] = {}
            for k in data:
                full[lang][k] = data[k]
    
    # entire language dictionary combined
    for lang in full:
        save_all(full[lang], "ALL_WORDS", lang)

build()
