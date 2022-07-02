import os
import shutil
from pathlib import Path

from fastapi import FastAPI, UploadFile, HTTPException, status
from starlette.responses import FileResponse

DEFAULT_ROOT = Path(__file__).parent / 'files'
ROOT = os.getenv('TA_FILE_SERVER_ROOT_PATH', str(DEFAULT_ROOT))

app = FastAPI()


@app.on_event("startup")
async def startup_event():
    if not Path(ROOT).exists():
        Path(ROOT).mkdir()


@app.on_event("shutdown")
async def shutdown_event():
    root = Path(ROOT)
    shutil.rmtree(root, ignore_errors=True)
    root.mkdir()


@app.get("/files")
async def list_folder():
    files, dirs = [], []
    root = Path(ROOT)
    for i in os.listdir(root):
        if os.path.isfile(root / str(i)):
            files.append(i)
        else:
            dirs.append(i)
    return {'files': files, 'directories': dirs}


@app.get("/files/{file_name}", response_class=FileResponse)
async def get_file(file_name: str):
    file = Path(ROOT) / file_name
    if not file.exists():
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f'{file} does not exist')
    else:
        return Path(ROOT) / file_name


@app.delete("/files/{file_name}", status_code=status.HTTP_202_ACCEPTED)
async def delete_file(file_name: str):
    file = Path(ROOT) / file_name
    if not file.exists():
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f'{file} does not exist')
    else:
        file.unlink()
    return {"filename": str(file)}


@app.delete("/files", status_code=status.HTTP_202_ACCEPTED)
async def clean_folder():
    root = Path(ROOT)
    shutil.rmtree(root, ignore_errors=True)
    root.mkdir()
    return {"root": str(root)}


@app.post("/files", status_code=status.HTTP_201_CREATED)
async def upload_file(file: UploadFile):
    content = await file.read()
    new_file = Path(ROOT) / file.filename
    new_file.write_bytes(content)
    return {"filename": file.filename}


@app.put("/files/{file_name}", status_code=status.HTTP_202_ACCEPTED)
async def replace_file(file_name, file: UploadFile):
    file = Path(ROOT) / file_name
    if not file.exists():
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f'{file} does not exist')
    else:
        content = file.read_bytes()
        file.write_bytes(content)
        return {"filename": str(file)}
