from flask_login import UserMixin   # import it
from extension import db

class User(db.Model, UserMixin):
    __tablename__ = 'users'
    user_id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(50), unique=True, nullable=False)
    email = db.Column(db.String(100), unique=True, nullable=False)
    password = db.Column(db.String(255), nullable=False)
    is_admin = db.Column(db.Boolean, default=False)

    profile = db.relationship('Profile', backref='user', uselist=False)

    # Override get_id() so Flask-Login uses user_id
    def get_id(self):
        return str(self.user_id)

class Profile(db.Model):
    __tablename__ = 'profiles'
    user_id = db.Column(db.Integer, db.ForeignKey('users.user_id'), primary_key=True)
    display_name = db.Column(db.String(100))
    profile_img_path = db.Column(db.String(255))