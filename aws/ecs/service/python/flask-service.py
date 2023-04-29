import os

from flask import Flask, jsonify, request

service_name = os.environ.get('SERVICE_NAME', 'hello world')
service_port = os.environ.get('SERVICE_PORT', 8000)
allowed_http_methods = ['DELETE', 'GET', 'HEAD', 'OPTIONS', 'PATCH', 'POST', 'PUT']

print(service_name, service_port)

app = Flask(__name__)


@app.route('/', methods=allowed_http_methods, defaults={'path': ''})
@app.route('/<path:path>', methods=allowed_http_methods)
def fn(path: str):
    return jsonify(service_name=service_name, service_port=service_port, path=f'/{path}', method=request.method)


app.run(host='0.0.0.0', port=service_port)
