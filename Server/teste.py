import json
from fastapi import FastAPI, Request
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates

app = FastAPI()
templates = Jinja2Templates(directory="templates")

@app.get("/")
async def root(request: Request):
    with open("../GodotClient/save.json", "r") as file:
        data = json.load(file)

    return templates.TemplateResponse("index.html", {"request": request, "mapa": data})
