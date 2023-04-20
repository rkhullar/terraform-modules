from pip._internal import main as pipmain
from types import ModuleType
pipmain = getattr(pipmain, 'main') if isinstance(pipmain, ModuleType) else pipmain
pipmain(['install', 'flask'])
from flask import Flask, jsonify, request
import os
service_name = os.environ.get('SERVICE_NAME', 'hello world')
service_port = os.environ.get('SERVICE_PORT', 8080)
print(service_name, service_port)
app = Flask(__name__)
allowed_http_methods = ['DELETE', 'GET', 'HEAD', 'OPTIONS', 'PATCH', 'POST', 'PUT']
app_route_index_annotation = app.route('/', methods=allowed_http_methods, defaults={'path': ''})
app_route_path_annotation = app.route('/<path:path>', methods=allowed_http_methods)
catch_all = lambda path: jsonify(service_name=service_name, service_port=service_port, path=f'/{path}', method=request.method)
catch_all = app_route_path_annotation(catch_all)
catch_all = app_route_index_annotation(catch_all)
app.run(host='0.0.0.0', port=service_port)
