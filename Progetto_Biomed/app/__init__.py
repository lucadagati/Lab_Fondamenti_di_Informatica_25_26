import os
from flask import Flask
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()


def create_app():
    app = Flask(__name__)

    basedir = os.path.abspath(os.path.dirname(os.path.dirname(__file__)))
    app.config['SECRET_KEY'] = 'hm-iot-biomed-2024'
    app.config['SQLALCHEMY_DATABASE_URI'] = (
        f'sqlite:///{os.path.join(basedir, "health_monitor.db")}'
    )
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024  # 16 MB

    db.init_app(app)

    from app.routes import main
    app.register_blueprint(main)

    return app
