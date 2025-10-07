from sanic import Sanic
from sanic.exceptions import FileNotFound
import sanic.response as response

app = Sanic("CVServer")

app.static("/", "public", index="index.html")


@app.exception(FileNotFound)
def ignore_file_not_found(_, exception: FileNotFound):
    return response.text("File not found: {}".format(exception.relative_url), 404)
